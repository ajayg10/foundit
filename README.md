# 🔍 Found It — AI-Powered Lost & Found Platform

> **A smart, community-driven Lost & Found web and mobile platform built for colleges, airports, tech parks, and transit hubs.**  
> Automatically reunites people with their lost belongings using multi-signal algorithmic matching, area-scoped filtering, interactive maps, and fraud-proof ownership verification.

---

## 🌟 What is Found It? (In Plain English)

Losing your laptop bag, earphones, phone, or student ID card in a large university campus, airport terminal, or corporate office is stressful. Traditional lost-and-found desks rely on physical notebooks, messy WhatsApp/Telegram groups, or static notice boards where messages quickly get lost.

**Found It** solves this problem by acting as an intelligent, automated matchmaker:
1. **If you lost something:** You post a lost report with details, photos, and approximate location/time.
2. **If you found something:** You snap a picture, describe where you found it, and set a private verification question (e.g., *"What sticker is on the back?"*).
3. **The app does the rest:** Our built-in matching engine automatically compares lost and found reports in real time using text analysis, location distance, category, and time. If there's a match, both people get notified immediately.
4. **Safe Handoff:** The owner proves it's theirs by answering the verification question before any personal contact details or recovery instructions are revealed.

---

## 🚀 Key Highlights

- 🧠 **Smart Matching with Zero External API Costs:** Runs completely on your own server. No expensive OpenAI, Google Gemini, or Claude API keys required!
- 🗺️ **100% Free Maps (No Google Maps API Key):** Uses **OpenStreetMap** with **Nominatim** geocoding for search, pin dropping, and reverse addresses at zero cost.
- 📍 **Area-Scoped Everywhere:** Filter and view items specifically for your university campus, airport terminal, or building zone.
- 🔐 **Fraud-Proof Ownership Verification:** Finders can hide distinctive secrets (like serial numbers or lock screen wallpapers) into verification questions to prevent false claims.
- ⚡ **Full-Stack Dart:** Flutter on the frontend, Serverpod on the backend, and shared type-safe models across both.

---

## 🛠️ Tech Stack Explained

| Layer | Technology | Why We Use It |
|---|---|---|
| **Frontend UI** | **Flutter 3.44+ (Dart)** | Single codebase that compiles to **Web (Chrome/Edge)**, **Android**, **iOS**, and **Desktop** with smooth 60fps animations. |
| **Typography & Styling** | **Google Fonts (Outfit & Inter)** | Modern, clean typography and curated color palette (clean dark slate + emerald green + vibrant indigo). |
| **Mapping & Location** | **flutter_map + latlong2 + Nominatim** | High-performance OpenStreetMap tile rendering and free reverse-geocoding without any credit card or Google Cloud keys. |
| **Backend Framework** | **Serverpod 4.0** | Enterprise-grade backend for Dart. Offers built-in ORM, secure authentication, streaming WebSockets, and automatic API client generation. |
| **Database** | **PostgreSQL 15+** | Rock-solid relational database storing user accounts, lost/found reports, location zones, and match scores. |
| **Matching Engine** | **Deterministic NLP + Spatial Math** | Built directly into Serverpod using Trigram string similarity, token Jaccard indices, Haversine geospatial distance, and temporal decay. |

---

## 🧠 How the "AI Matched" Engine Works (No Paid API Needed)

You might wonder: *How can the app match items without paying for OpenAI or Gemini?*

Found It uses a **multi-signal heuristic matching algorithm** running directly inside Serverpod ([matching_service.dart](file:///C:/Users/Ajay/foundit/found_it_server/lib/src/services/matching_service.dart)):

```
                        ┌──────────────────────────────────────────────┐
                        │          Found It Matching Engine            │
                        └──────────────────────┬───────────────────────┘
                                               │
      ┌────────────────────┬───────────────────┼────────────────────┬───────────────────┐
      ▼                    ▼                   ▼                    ▼                   ▼
Text NLP Engine    Geospatial Distance  Temporal Proximity   Category Taxonomy   Location Entity
 (Weight: 35%)        (Weight: 20%)       (Weight: 20%)        (Weight: 15%)      (Weight: 10%)
```

### The 5 Signals:
1. **Text NLP Similarity (35% Weight):**
   - **Character Trigrams ($n$-grams):** Handles typos and spelling variations (e.g. *"Wildcraft"* vs *"Wildcrafts"*).
   - **Token Jaccard Similarity:** Compares word overlap between titles and descriptions.
   - **Synonym Knowledge Graph:** Automatically understands related words:
     - Bags: `backpack` ↔ `bag` ↔ `rucksack`
     - Phones: `iphone` ↔ `smartphone` ↔ `mobile`
     - Audio: `earbuds` ↔ `airpods` ↔ `headphones`
     - Colors: `navy` ↔ `blue`, `charcoal` ↔ `black`
2. **Geospatial Distance (20% Weight):** Uses the Haversine formula to compute exact distance in meters/kilometers between where the item was lost and found.
3. **Temporal Proximity (20% Weight):** Computes time difference. An item lost 1 hour before an item was found scores much higher than an item lost weeks apart.
4. **Category Taxonomy (15% Weight):** Ensures items belong to compatible categories (`Electronics`, `Bags`, `Keys`, `Wallets`, `IDs`, etc.).
5. **Location Entity (10% Weight):** Checks if both reports occurred at the same campus or designated building zone.

**Explainable Results:** Every match provides a transparent breakdown explaining *why* it matched (e.g., *"Matched category 'Bags', shared keywords 'Black, Wildcraft', 150m apart, lost 2 hours before found"*).

---

## 📱 Complete Feature Guide

### 1. 🔐 Authentication & Quick Switcher
- **Sign In & Sign Up:** Register with email, password, full name, and phone number.
- **1-Tap Demo Switcher:** Perfect for hackathon presentations or quick testing. Instantly log in as:
  - **Alice Johnson:** The user who lost her backpack.
  - **Bob Martinez:** The campus security or fellow student who found the backpack.
- **Sign Out:** Tap your user profile pill in the app bar anytime to sign out.

### 2. 📊 Interactive Dashboard & Metric Cards
The top of the home screen features 4 interactive metric cards:
- **Lost Reported:** Displays all lost items reported by you (`By you • Tap to view`). Tapping opens your **My Reports** dashboard.
- **Found Posted:** Shows all found items posted in your currently selected area (`In [Area Name] • Tap to view`). Tapping opens the **Public Board** scoped to that venue.
- **AI Matched:** Live count of potential matches discovered for your reports. Tapping opens the **Matches** view.
- **Items Returned:** Tracks total successfully returned items.

### 3. 🗺️ Area-Scoped Venue Selector & Map Pin Drop
- Tap the **Active Location Pill** in the top navigation bar to switch between campuses, universities, airports, or tech parks (e.g., *IIT Delhi*, *Kempegowda Airport T2*, *Cyber City Gurgaon*).
- **Interactive OpenStreetMap:** Search for any place name via free Nominatim search, or tap directly on the map to drop a pin.
- All cards, feeds, and boards instantly filter to your chosen location.

### 4. 📝 Report Lost Item
- Upload or take a picture of what you lost.
- Select category, date, and approximate time.
- Pick the campus/venue and pin-point the area or building.
- Set contact options and submit for automatic real-time matching.

### 5. 🔍 Report Found Item & Fraud-Proof Verification
- Finder submits item description, photo, and found location.
- **Ownership Verification Question:** The finder can set a secret question only the true owner would know:
  - *Example Question:* "What brand of water bottle is in the side pocket?"
  - *Secret Answer:* "Blue Milton thermos"
- The question is presented to anyone claiming the item before handoff.

### 6. 📋 Public Board
- A community-wide directory of all found items in your venue.
- Filter by category (`Electronics`, `Bags`, `IDs`, etc.) or search by keywords.
- Strict privacy: Exact GPS coordinates and finder emails are protected; only venue name and photo are visible.

### 7. 🔔 Live Notifications & WebSocket Alerts
- Serverpod streaming updates send immediate in-app alerts whenever a candidate match is discovered or a claim is submitted.

### 8. ⚡ 1-Click Demo Scenario Seeder
- Click the **Bolt icon (⚡)** in the top app bar anytime to immediately populate the database with realistic lost and found reports (Alice's backpack & Bob's found item) to demonstrate live 94% confidence AI matching.

---

## 📂 Project Structure

```
foundit/
├── found_it_flutter/            # Flutter Frontend Application
│   ├── lib/
│   │   ├── main.dart            # App entry point & reactive Auth Gate
│   │   ├── client.dart          # Serverpod client initialization
│   │   ├── screens/             # UI Screens
│   │   │   ├── home_screen.dart         # Home feed & interactive metric cards
│   │   │   ├── sign_in_screen.dart      # Auth gate with 1-tap demo logins
│   │   │   ├── public_board_screen.dart # Public found items board
│   │   │   ├── dashboard_screen.dart    # My Reports & items history
│   │   │   ├── matches_screen.dart      # AI match cards with explanations
│   │   │   ├── location_selector_screen.dart # Campus switcher
│   │   │   ├── location_picker_screen.dart   # Interactive OpenStreetMap pin picker
│   │   │   └── notifications_screen.dart     # Real-time alert center
│   │   ├── state/
│   │   │   └── app_state.dart   # Central ChangeNotifier state & auth session
│   │   └── widgets/             # Reusable UI components (MetricCard, etc.)
│   └── pubspec.yaml
│
├── found_it_server/             # Serverpod Backend (Dart)
│   ├── bin/main.dart            # Server entry point
│   ├── lib/
│   │   ├── server.dart          # Server routes, auth, and static web hosting
│   │   └── src/
│   │       ├── services/        # Core business logic
│   │       │   ├── matching_service.dart   # Multi-signal matching engine
│   │       │   ├── similarity_service.dart # NLP text & synonym algorithm
│   │       │   ├── distance_service.dart   # Haversine distance calculator
│   │       │   └── time_service.dart       # Temporal decay modeling
│   │       └── endpoints/       # RPC endpoints (Report, Match, Location, User)
│   └── config/
│       └── development.yaml     # Database and port configurations
│
└── found_it_client/             # Auto-generated client library
    └── lib/src/protocol/        # Serialized models shared between front & back
```

---

## 🚀 Step-by-Step Setup Guide (For Beginners)

### Step 1: Prerequisites
Make sure you have installed on your computer:
1. **Flutter SDK (v3.24+ / 3.44+)**: [Install Flutter](https://docs.flutter.dev/get-started/install)
2. **PostgreSQL (v15+)**: [Download PostgreSQL](https://www.postgresql.org/download/)
3. **Serverpod CLI**: Run the following in your terminal:
   ```bash
   dart pub global activate serverpod_cli
   ```

---

### Step 2: Configure the Database
1. Open pgAdmin or your terminal and ensure a database named `found_it` exists:
   ```sql
   CREATE DATABASE found_it;
   ```
2. Open `found_it_server/config/development.yaml` and set your PostgreSQL password:
   ```yaml
   database:
     host: localhost
     port: 5432
     name: found_it
     user: postgres
     password: your_postgres_password  # e.g. ajay10
   ```

---

### Step 3: Start the Backend Server
Open a terminal inside the project directory:
```bash
cd found_it_server
dart pub get
dart run bin/main.dart --apply-migrations
```
*Your Serverpod server will start on port `8080` (API) and `8082` (Web).*

---

### Step 4: Run the Flutter App
Open a second terminal window:

#### Running on Web (Chrome):
```bash
cd found_it_flutter
flutter run -d chrome
```

#### Running on Mobile (Android / iOS):
1. Find your computer's local IP address (`ipconfig` on Windows or `ifconfig` on Mac/Linux).
2. Edit `found_it_flutter/assets/config.json`:
   ```json
   {
     "apiUrl": "http://192.168.1.XX:8080/"
   }
   ```
3. Run:
   ```bash
   cd found_it_flutter
   flutter run
   ```

---

## 🧪 3-Minute Demo Walkthrough

Want to see the entire app in action? Follow this simple flow:

1. **Open the App:** You will see the **Sign In / Create Account** screen.
2. **Log In as Alice:** Under *"Demo Accounts (1-Tap Login)"*, click **Alice (Lost Backpack)**.
3. **Seed Demo Data:** On the Home Screen, click the **⚡ Bolt icon** in the top navigation bar. This seeds a realistic campus scenario (Alice lost her Wildcraft backpack at the Central Library; Bob found it near the cafe).
4. **Inspect Top Cards:**
   - Look at **Lost Reported**: Shows `1` (Alice's lost backpack). Click it to see your lost report.
   - Look at **Found Posted**: Shows found items posted in your current campus. Click it to view the Public Board.
5. **View the AI Match:** Tap **AI Matched** or the purple **"Potential Match Discovered"** banner. You'll see a **94% Confidence Match** with full signal explanations.
6. **Switch to Bob:** Tap the user avatar in the top-right, choose **Bob Martinez**, and see the perspective of the person who found the item!

---

## ❓ Frequently Asked Questions (FAQ)

#### Q: Do I need to pay for an OpenAI or Google Gemini API key?
**No.** Found It uses a deterministic, locally executed NLP and spatial engine that runs on your Serverpod backend at zero cost.

#### Q: Do I need a Google Maps billing account?
**No.** We use OpenStreetMap tiles and free Nominatim geocoding. No credit card or Google Cloud account is needed.

#### Q: How is privacy protected?
Exact GPS coordinates are stored securely in PostgreSQL and used only by the backend distance algorithm. The public board displays only high-level venue names (e.g. *"IIT Delhi — Central Library"*), never private coordinates.

---

## 📄 License
This project is open-source under the [MIT License](LICENSE).
