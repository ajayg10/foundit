# 🔍 Found It — AI-Powered Lost & Found Platform

> Reuniting people with their lost belongings using smart matching, venue-based location, and secure verification.

---

## ✨ What It Does

**Found It** is a mobile-first lost & found app built for campuses, airports, offices, and malls.

When someone reports a lost item, the system **automatically matches** it against all open found items using:

| Signal | Weight | Example |
|---|---|---|
| 📝 Text Similarity | 35% | "Black backpack" ↔ "Dark rucksack" |
| 🗺️ Location Match | 10% | Same campus/terminal |
| 📍 Geographic Distance | 20% | 200m apart → 1.0 score |
| ⏱️ Time Proximity | 20% | Lost & found within 3h |
| 🏷️ Category | 15% | Both "Bags" |

A **confidence score** (0–100%) is shown with emoji tags: 🔥 High / ✅ Strong / 🔍 Possible

---

## 🏗️ Architecture

```
found_it_flutter/     ← Flutter mobile app (Android/iOS)
found_it_server/      ← Serverpod backend
found_it_client/      ← Generated Dart client (shared types)
```

**Stack:**
- **Frontend:** Flutter 3.44 + Google Fonts + flutter_map (OpenStreetMap)
- **Backend:** Serverpod 4.0 (Dart) on port 8080
- **Database:** PostgreSQL (via Serverpod ORM)
- **Maps:** OpenStreetMap + Nominatim (free, no API key)

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.44+
- Dart 3.12+
- PostgreSQL 15+
- Serverpod CLI: `dart pub global activate serverpod_cli`

### 1. Clone
```bash
git clone https://github.com/ajayg10/foundit.git
cd foundit
```

### 2. Setup PostgreSQL
Create a database and update `found_it_server/config/development.yaml`:
```yaml
database:
  host: localhost
  port: 5432
  name: found_it
  user: postgres
  password: your_password
```

### 3. Run the Server
```bash
cd found_it_server
dart pub get
dart run bin/main.dart --apply-migrations
```

### 4. Find Your Machine's LAN IP
```bash
# Windows
ipconfig  # look for IPv4 Address

# Mac/Linux
ifconfig  # look for inet on en0/wlan0
```

Update `found_it_flutter/assets/config.json`:
```json
{
  "apiUrl": "http://192.168.x.x:8080"
}
```

### 5. Run the Flutter App
```bash
cd found_it_flutter
flutter pub get
flutter run
```

---

## 📱 App Screens

| Screen | Description |
|---|---|
| **Sign In / Sign Up** | Branded auth screen, tabbed |
| **Home** | Recent found items, quick report buttons |
| **Public Board** | All found items with search + category filter |
| **Report Lost** | Form with photo (camera/gallery), map location picker |
| **Report Found** | Same, with verification question setup |
| **Matches** | Auto-generated match list with animated confidence cards |
| **Dashboard** | My Lost / Found / Matches / Claims / Returned (5 tabs) |
| **Location Picker** | OSM map with Nominatim search + GPS location |
| **Notifications** | Real-time match + claim alerts |

---

## 🗺️ Maps (Free — No API Key Required)

We use **OpenStreetMap** via `flutter_map` and **Nominatim** for geocoding:

- 🔍 Search airports, colleges, malls, offices by name
- 📍 Tap map to drop a pin
- 📡 "Use my current location" button (GPS)
- 🔁 Reverse geocoding: tap → address shown automatically
- Privacy: only venue name shown publicly; exact GPS stored securely for matching only

---

## 🔐 Privacy Model

| Data | Public Board | Matching Engine | Storage |
|---|---|---|---|
| Venue name / zone | ✅ Shown | ✅ Used | PostgreSQL |
| Exact GPS coords | ❌ Hidden | ✅ Used for distance | PostgreSQL (server-side only) |
| User email | ❌ Never shown | — | Serverpod auth |

---

## 🧪 Demo Flow

1. Open app → Sign up with any email + password
2. Tap ⚡ (bolt icon) on home screen to seed demo data
3. Go to **Matches** tab — see auto-generated matches with confidence scores
4. Tap **"Verify Ownership to Claim"** on a match
5. Answer the verification question (hint shown for demo)
6. Item status updates: `open → matched → claimPending → verified → returned`

---

## 🛣️ Roadmap

- [ ] Push notifications (FCM)
- [ ] Admin portal for location management
- [ ] Duplicate detection using cosine similarity
- [ ] Natural language search ("I lost my phone near the canteen")
- [ ] QR code for safe handoff confirmation
- [ ] Moderation flagging for inappropriate reports

---

## 📄 License

MIT License — see [LICENSE](LICENSE)
