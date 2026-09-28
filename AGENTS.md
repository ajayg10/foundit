# Flutter & Serverpod project

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `found_it_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `found_it_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

## About Found It — AI-Powered Lost & Found

**Found It** is an AI-powered lost and found platform built for college campuses and office buildings. When users report lost or found items, the Serverpod backend automatically matches reports using a multi-signal scoring engine, provides explainable match confidence, dispatches real-time streaming notifications, and enables secure item recovery through private ownership verification challenges.

### System Architecture
- **Backend**: Serverpod 4 (`found_it_server`) on Dart 3.13 / PostgreSQL 18.3 (`pg_trgm`).
  - Web Server (`http://localhost:8082`): Serves API routes and hosts the compiled Flutter Web application (`web/app`).
  - Insights / API Server (`http://localhost:8080`).
- **Client**: Generated Serverpod client (`found_it_client`).
- **Frontend**: Flutter Web & Mobile (`found_it_flutter`) using Google Fonts (Inter), custom dark/light theme, and `AppState` ChangeNotifier.

### Core Data Models (`.spy.yaml`)
- `AppUser`: User account (`id`, `name`, `email`, `role`, `phoneNumber`, `created`).
- `ItemReport`: Item lost/found report (`type`: lost|found, `category`, `title`, `description`, `locationName`, `latitude`, `longitude`, `eventTime`, `status`, `userId`).
- `ItemMatch`: Scored pair (`lostReportId`, `foundReportId`, `confidence`, `status`, `explanationJson`, `created`).
- `MatchDetailsDto` & `MatchExplanationDetails`: DTO with text, distance, time, and category breakdowns.
- `Verification`: Private ownership challenge (`foundReportId`, `question`, `expectedAnswerHash`, `salt`, `attemptsLeft`, `status`).
- `VerificationAttemptResult`: Verification feedback (`success`, `status`, `attemptsRemaining`, `message`).
- `AppNotification`: In-app notification record (`userId`, `title`, `message`, `type`, `relatedId`, `read`, `created`).
- `DashboardStats`: Aggregate system metrics (`totalLost`, `totalFound`, `totalMatched`, `totalReturned`, `activeMatches`).

### Serverpod Services (`lib/src/services/`)
- `MatchingService`: Orchestrates scoring between reports across 4 weighted signals:
  - Text Similarity (40%): Trigram overlap (`pg_trgm`), Token Jaccard, title keyword containment.
  - Spatial Closeness (25%): Haversine distance with non-linear decay curve (1.0 for <100m, 0.0 for >5km).
  - Temporal Closeness (20%): Time difference in hours with non-linear decay (1.0 for <3h, 0.0 for >7 days).
  - Category Match (15%): Exact match = 1.0, general "other" match = 0.5, mismatch = 0.0.
- `SimilarityService`: Pure Dart trigram and token similarity computation with pluggable `EmbeddingProvider` interface.
- `DistanceService`: Great-circle Haversine formula calculation.
- `TimeService`: Absolute hour difference & score decay.
- `VerificationService`: SHA-256 with cryptographically generated 32-byte salt; brute-force lockout after 5 failed attempts; automatic status transition to `VERIFIED` and `RETURNED`.
- `NotificationService`: Persists notifications and publishes real-time broadcasts via Serverpod `session.messages.postMessage`.
- `SeedDataService`: Populates sample campus locations and items.

### Endpoints (`lib/src/`)
- `UserEndpoint`: User profile queries, user lookup, and switching.
- `ReportEndpoint`: Lost & Found reporting, public found items board (with privacy-preserving approximate locations), and report history.
- `MatchEndpoint`: Match discovery, top matches for reports, and detailed signal explanations.
- `VerificationEndpoint`: Challenge creation (hashed answer only), secret question retrieval for claimants, answer submission with rate-limiting, and item return handover.
- `NotificationEndpoint`: User notification queries, read status updates, and real-time streaming via `watchNotifications(userId)`.
- `DashboardEndpoint`: Real-time system statistics for metrics cards.

### Hackathon Demo Scenario
1. **Alice (Lost Item)**: Loses a "Black Wildcraft Backpack" at the Main Library at 10:00 AM.
2. **Bob (Found Item)**: Finds a "Black Backpack" near the Engineering Block at 12:00 PM (0.8 km away).
   - Bob creates a verification challenge: *"What is attached to the front zipper?"* with answer *"Red keychain"*.
3. **Automated Match**: Serverpod matching engine generates high confidence (~91%), sends notifications to both Alice and Bob.
4. **Verification**: Alice views match details, reads Bob's question, submits *"Red keychain"*, and item transitions to `RETURNED`.
