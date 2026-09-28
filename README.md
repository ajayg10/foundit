# Found It — AI-Powered Lost & Found Platform

> **Built for the Build Something Real — Serverpod Hackathon**  
> An intelligent, privacy-first lost & found platform for college campuses and office buildings powered by **Serverpod 4**, **PostgreSQL**, and **Flutter**.

[![Serverpod 4](https://img.shields.io/badge/Serverpod-4.0.3-blue)](https://serverpod.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-02569B?logo=flutter)](https://flutter.dev)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18.3-336791?logo=postgresql)](https://postgresql.org)
[![Dart](https://img.shields.io/badge/Dart-3.13.4-0175C2?logo=dart)](https://dart.dev)

---

## 🌟 Overview

Losing an item on a large college campus or office complex is frustrating. Traditional lost-and-found bulletin boards and group chats suffer from:
1. **Low visibility and manual effort**: People rarely cross-reference separate lost and found threads.
2. **Ambiguity and false positives**: Searches like "found keys" or "lost bag" return dozens of non-matching items.
3. **Fraud and theft risks**: Anyone can claim an item if details and serial numbers are publicly exposed.

**Found It** solves this by providing:
- **Autonomous Multi-Signal AI Matching**: Reports are scored in real time against candidate items using 4 weighted dimensions: Text Similarity, Spatial Distance, Temporal Proximity, and Category Matching.
- **Explainable Match Confidence**: Both parties receive transparent breakdowns showing exactly why two reports matched (e.g., *"High text similarity (93%), 0.8 km distance (+24%), within 2 hours (+19%)"*).
- **Private Ownership Verification Challenge**: Finders define a secret verification question with a salted, SHA-256 hashed answer. Claimants must prove ownership without the answer ever being exposed or sent across the network.
- **Privacy-Preserving Public Board**: Items are displayed with human-friendly approximate campus zones (e.g., *"Near Main Library"*) rather than exact GPS coordinates.
- **Real-Time Streaming Notifications**: Instant updates via Serverpod 4 streaming methods and pub/sub message brokers.

---

## 📐 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 Flutter Frontend (Web / Mobile)             │
│   - Multi-user demo switcher (Alice: Lost, Bob: Found)      │
│   - Material 3 Design System (Inter typography, rich dark)  │
│   - Real-time notification streams via Serverpod client     │
└──────────────────────────────┬──────────────────────────────┘
                               │ Serverpod Client Protocol
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 Serverpod Monolith Server (Dart)            │
│                                                             │
│  Endpoints:                                                 │
│   • ReportEndpoint       • MatchEndpoint                    │
│   • VerificationEndpoint • NotificationEndpoint (Stream)    │
│   • UserEndpoint         • DashboardEndpoint                │
│                                                             │
│  Domain Services:                                           │
│   • MatchingService      • SimilarityService                │
│   • DistanceService      • TimeService                      │
│   • VerificationService  • NotificationService              │
│   • SeedDataService                                         │
└──────────────────────────────┬──────────────────────────────┘
                               │ ORM & SQL Queries
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 PostgreSQL Database (with pg_trgm)          │
│   • app_user             • item_report                      │
│   • item_match           • verification                     │
│   • app_notification                                        │
└─────────────────────────────────────────────────────────────┘
```

---

## 🧠 Multi-Signal Matching Engine

When an item is reported, `MatchingService` compares it against open candidate items of the opposite type (`LOST` ↔ `FOUND`). The final **Match Confidence (0–100%)** is calculated using a weighted multi-signal model:

$$\text{Confidence} = 0.40 \cdot S_{\text{text}} + 0.25 \cdot S_{\text{dist}} + 0.20 \cdot S_{\text{time}} + 0.15 \cdot S_{\text{cat}}$$

### 1. Text Similarity ($S_{\text{text}}$ — Weight: 40%)
Calculated via `SimilarityService`:
- **Trigram Overlap (`pg_trgm`)**: Captures typos and morphological variations.
- **Token Jaccard Similarity**: Evaluates word overlap between titles and descriptions.
- **Keyword Containment**: Bonus weighting when key terms match directly (e.g., *"Wildcraft Backpack"* and *"Backpack"*).
- Pluggable interface for external semantic embedding providers.

### 2. Spatial Closeness ($S_{\text{dist}}$ — Weight: 25%)
Calculated via `DistanceService` using the **Haversine formula**:
- Distance $\le 100$ meters $\rightarrow 1.0$ (Max score)
- Distance $\le 500$ meters $\rightarrow 0.95$
- Distance $\le 1.0$ km $\rightarrow 0.85$
- Distance $\le 2.0$ km $\rightarrow 0.65$
- Distance $\le 5.0$ km $\rightarrow 0.30$
- Distance $> 5.0$ km $\rightarrow 0.0$

### 3. Temporal Closeness ($S_{\text{time}}$ — Weight: 20%)
Calculated via `TimeService` based on event time delta:
- Delta $\le 3$ hours $\rightarrow 1.0$
- Delta $\le 12$ hours $\rightarrow 0.90$
- Delta $\le 24$ hours $\rightarrow 0.80$
- Delta $\le 72$ hours $\rightarrow 0.60$
- Delta $\le 7$ days $\rightarrow 0.30$
- Delta $> 7$ days $\rightarrow 0.05$

### 4. Category Match ($S_{\text{cat}}$ — Weight: 15%)
- Exact category match (e.g., `ELECTRONICS` == `ELECTRONICS`) $\rightarrow 1.0$
- General fallback category (`OTHER`) $\rightarrow 0.5$
- Incompatible categories $\rightarrow 0.0$

---

## 🔒 Private Ownership Verification Challenge

To prevent fraudulent claims, the finder configures an ownership challenge:
1. **Challenge Setup**: The finder inputs a question (e.g., *"What brand is the keychain?"*) and the expected answer (*"Red keychain"*).
2. **Server-Side Salted Hash**: The backend generates a random 32-byte cryptographic salt and computes:
   $$\text{Hash} = \text{SHA-256}(\text{Salt} \parallel \text{normalized\_answer})$$
   The raw answer is **never** saved in the database and **never** returned through the client API.
3. **Claimant Verification**:
   - The claimant sees only the question and an input field.
   - Submitted answers are trimmed, lowercased, salted, and verified server-side.
4. **Brute-Force Rate Limiting**:
   - The verification challenge allows a maximum of **5 attempts**.
   - Each failed attempt decrements the attempt counter.
   - Upon 5 failed attempts, the challenge is locked (`LOCKED`) and the finder is alerted.
5. **Lifecycle Transition**: Successful verification marks the challenge as `VERIFIED` and unlocks final return handover (`RETURNED`).

---

## 🚀 Running the Project

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ($\ge 3.40.0$)
- [Dart SDK](https://dart.dev/get-dart) ($\ge 3.10.0$)
- [Serverpod CLI](https://serverpod.dev) (`dart pub global activate serverpod_cli`)
- [PostgreSQL](https://www.postgresql.org/download/) running on `localhost:5432` with database `found_it`.

### 1. Database Setup
Create database and enable `pg_trgm`:
```sql
CREATE DATABASE found_it;
\c found_it;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
```

### 2. Start Backend Server
```powershell
cd found_it_server
dart run bin/main.dart
```
The Serverpod server will initialize:
- **API Server**: `http://localhost:8080/`
- **Web App Server**: `http://localhost:8082/`

### 3. Run Flutter Frontend
To run as a web app or desktop/mobile:
```powershell
cd found_it_flutter
flutter run -d chrome
```
*Note: A pre-compiled web build is also hosted directly by the Serverpod server at `http://localhost:8082/`.*

---

## 🧪 Running Automated Tests

Run the backend integration test suite:
```powershell
cd found_it_server
dart test test/integration/found_it_test.dart
```

### Test Coverage:
- `SimilarityService`: Exact match, partial overlap, empty string edge cases.
- `DistanceService`: Haversine accuracy, zero distance, score thresholds.
- `TimeService`: Closeness decay curves and future time handling.
- `MatchingService`: Multi-signal scoring and JSON explanation structure.
- `VerificationService`: SHA-256 salted hashing, correct answer verification, wrong answer rate-limiting, and 5-attempt brute-force lockout.
- `End-to-End Flow`: Lost report + Found report $\rightarrow$ automatic match $\rightarrow$ notification dispatch $\rightarrow$ challenge response $\rightarrow$ item return.

---

## 🎬 Live Hackathon Demo Walkthrough

The application includes a built-in **Demo User Switcher** in the top navigation bar to seamlessly simulate two phones:

1. **Switch to Alice (Phone A — Lost Item)**:
   - Alice lost her **"Black Wildcraft Backpack"** at the **Main Library** around 10:00 AM.
   - She clicks **"I Lost Something"**, enters the details, and submits the report.
2. **Switch to Bob (Phone B — Found Item)**:
   - Bob discovers a **"Black Backpack"** at the **Engineering Block** (0.8 km away) around 12:00 PM.
   - He clicks **"I Found Something"**, sets the verification question:  
     *Question*: `"What is attached to the front zipper?"`  
     *Secret Answer*: `"Red keychain"`
   - Submits the found report.
3. **Instant AI Match**:
   - The Serverpod engine pairs Alice's and Bob's reports with **~91% Match Confidence**.
   - Notifications stream in real time to both Alice and Bob.
4. **Alice Verifies Ownership**:
   - Alice clicks the match notification to inspect the breakdown.
   - Clicks **"Verify Ownership"**, sees Bob's question, and inputs `"Red keychain"`.
   - The challenge verifies instantly, transitioning the item to `RETURNED`.

---

## 📂 Project Structure

```
found_it/
├── found_it_server/             # Serverpod backend application
│   ├── config/                  # Serverpod environment configurations
│   ├── lib/
│   │   ├── src/
│   │   │   ├── dashboard/       # Dashboard analytics endpoint and models
│   │   │   ├── matching/        # Matching engine models & endpoint
│   │   │   ├── notifications/   # Real-time streaming notification endpoint
│   │   │   ├── reports/         # Item reports (lost/found) endpoint & models
│   │   │   ├── services/        # Matching, distance, time, and verification logic
│   │   │   ├── users/           # User management endpoint & models
│   │   │   └── verification/    # Verification challenge endpoint & models
│   │   └── server.dart          # Serverpod server startup & route registration
│   ├── test/                    # Integration and unit test suite
│   └── web/app/                 # Compiled Flutter Web production build
├── found_it_client/             # Generated Dart client protocol library
└── found_it_flutter/            # Flutter cross-platform client
    ├── lib/
    │   ├── screens/             # UI screens (Home, Lost, Found, Public Board, etc.)
    │   ├── state/               # AppState notifier (demo switcher, streams, caching)
    │   ├── theme/               # Material 3 custom theme and color tokens
    │   └── widgets/             # Reusable cards, metric displays, and dialogs
    └── pubspec.yaml             # Flutter dependencies
```

---

## 🏆 Serverpod Hackathon Highlights

- **100% Serverpod First**: Built strictly on Serverpod 4 ORM, streaming methods, migrations, and generated client.
- **Production-Grade Data Integrity**: Strongly typed schema models (`.spy.yaml`) with relational foreign keys.
- **Privacy-First**: Hashed verification secrets and approximate geographic labeling protect users from scam claims and location tracking.
- **Explainable AI**: Transparent, interpretable multi-signal scoring rather than black-box approximations.
