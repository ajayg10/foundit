# UI Audit — Found It Flutter App

> Generated as Phase 0 of the premium UI redesign. No code was changed during this phase.

---

## 1. Screen Inventory

| Screen | File | Route / How Opened |
|--------|------|--------------------|
| **Sign In / Sign Up** | `lib/screens/sign_in_screen.dart` | Root when `!isAuthenticated` |
| **Home** | `lib/screens/home_screen.dart` | Root when `isAuthenticated` |
| **Public Board** | `lib/screens/public_board_screen.dart` | `Navigator.push` from Home nav bar tab 1 |
| **Matches** | `lib/screens/matches_screen.dart` | `Navigator.push` from Home nav bar tab 2 |
| **Dashboard (My Activity)** | `lib/screens/dashboard_screen.dart` | `Navigator.push` from Home nav bar tab 3 (or metric card tap) |
| **Report Lost** | `lib/screens/report_lost_screen.dart` | `Navigator.push` from Home hero card |
| **Report Found** | `lib/screens/report_found_screen.dart` | `Navigator.push` from Home hero card |
| **Notifications** | `lib/screens/notifications_screen.dart` | `Navigator.push` from notification bell icon |
| **Location Selector** | `lib/screens/location_selector_screen.dart` | `Navigator.push` from location pill |
| **My Reports** | `lib/screens/my_reports_screen.dart` | Not wired to nav — unused screen |
| **Greetings (dev)** | `lib/screens/greetings_screen.dart` | Not reachable from production UI — dev scaffold only |

### Dialogs & Sheets

| Surface | Location | Trigger |
|---------|----------|---------|
| **User Switcher Bottom Sheet** | `home_screen.dart` `_showUserSwitcherSheet()` | Tap user identity pill in app bar |
| **Item Detail Bottom Sheet** | `public_board_screen.dart` `_showItemDetails()` | Tap `ItemCard` on Public Board |
| **Report Success Bottom Sheet** | `report_lost_screen.dart` `_submitReport()` | Successful lost report submit |
| **Report Success Bottom Sheet** | `report_found_screen.dart` `_submitReport()` | Successful found report submit |
| **Verification Dialog** | `widgets/verification_dialog.dart` | Tap "Verify Ownership" on Public Board / MatchCard |

### Empty / Loading / Error States

| Screen | Loading | Empty | Error |
|--------|---------|-------|-------|
| Home (recent found items) | `CircularProgressIndicator` in center | Plain text container | `debugPrint` only, no UI |
| Public Board | `CircularProgressIndicator` | Column with icon + text | `debugPrint` only |
| Matches | — (reads from `AppState`) | Column with icon + text + seed button | — |
| Dashboard (tabs) | `CircularProgressIndicator` | `_emptyState()` method | `debugPrint` only |
| Notifications | — (reads from `AppState`) | Column with icon + text | — |
| My Reports | `CircularProgressIndicator` | Column with icon + text | `debugPrint` only |

---

## 2. Hardcoded Colors, Font Sizes, Paddings and Radii

### Hardcoded Colors (outside the theme class)

| File | Value | Line(s) |
|------|-------|---------|
| `main.dart` | `Color(0xFFFEF2F2)`, `Colors.red`, `Color(0xFF991B1B)`, `Color(0xFF7F1D1D)` | 20, 30, 46, 55 |
| `home_screen.dart` | `Colors.white`, `Color(0xFFEEF2FF)`, `Color(0xFFC7D2FE)`, `Color(0xFF4F46E5)`, `Color(0xFF4338CA)`, `Color(0xFF6366F1)`, `Color(0xFFF1F5F9)`, `Color(0xFF0D9488)` | ~85, 271–363, 840 |
| `dashboard_screen.dart` | `Color(0xFF4F46E5)`, `Colors.white`, `Colors.blue`, `Colors.orange`, `Colors.purple`, `Colors.teal` | 151, 233, 259, 323–326 |
| `sign_in_screen.dart` | `Color(0xFF0F172A)`, `Colors.white`, `Color(0xFF6366F1)`, `Color(0xFFF1F5F9)`, `Colors.white60`, `Color(0xFFF8FAFC)`, `Color(0xFFE2E8F0)` | 109, 134, 196, 212, 564 |
| `notifications_screen.dart` | `Color(0xFFF1F5F9)`, `Colors.white`, `Color(0xFFF0FDF4)`, `Color(0xFFA7F3D0)` | 71, 123–129 |
| `public_board_screen.dart` | `Colors.white`, `Color(0xFFEEF2FF)`, `Color(0xFFC7D2FE)`, `Color(0xFF4F46E5)`, `Color(0xFF4338CA)`, `Color(0xFF6366F1)`, `Color(0xFFF8FAFC)`, `Color(0xFFF0FDF4)`, `Color(0xFFBBF7D0)`, `Color(0xFF16A34A)`, `Color(0xFF15803D)`, `Color(0xFFF1F5F9)` | many |
| `item_card.dart` | `Colors.white`, `Color(0xFF64748B)` | 139, 42 |
| `match_card.dart` | `Colors.white`, `Color(0xFF059669)`, `Color(0xFF2563EB)`, `Color(0xFFD97706)`, `Color(0xFFFFF1F2)`, `Color(0xFFECFDF5)`, `Color(0xFFFECDD3)`, `Color(0xFFA7F3D0)`, `Color(0xFF6366F1)`, `Color(0xFF0D9488)`, `Color(0xFF8B5CF6)` | many |
| `verification_dialog.dart` | `Colors.white`, `Color(0xFFECFDF5)`, `Color(0xFFA7F3D0)`, `Color(0xFF065F46)`, `Color(0xFFF8FAFC)`, `Color(0xFFF1F5F9)` | many |
| `report_lost_screen.dart` | `Colors.white`, `Color(0xFFF1F5F9)` | 123, 381 |
| `metric_card.dart` | `Colors.white`, `Colors.transparent` | 28, 109 |

**Total hardcoded font-size usages outside theme:** ~60+ instances (GoogleFonts calls with explicit fontSize in every file).

**Hardcoded EdgeInsets/SizedBox:** Pervasive — almost every file uses raw `EdgeInsets.all(16)`, `SizedBox(height: 12)`, etc. without a spacing constant.

**Hardcoded BorderRadius:** `BorderRadius.circular(12)`, `.circular(16)`, `.circular(20)`, `.circular(24)` scattered across all files with no central token.

---

## 3. Overflow Risks

| Location | Risk | Description |
|----------|------|-------------|
| **Home AppBar actions row** | 🔴 **Active overflow** | The app bar `actions` list contains 5 children (location pill, user pill with ConstrainedBox(maxWidth:80), notifications badge, seed button, SizedBox). At 320px device width or 200% text scale, the two pills + bell + lightning icon overflow by ~65px. Confirmed by the prompt. |
| **Dashboard `SliverAppBar` + `TabBar`** | 🔴 **Active overlap** | `SliverAppBar` has `bottom: TabBar(...)`. The tab bar is part of the sliver header but the `flexibleSpace` background (`_buildStatsHeader`) has `padding: const EdgeInsets.fromLTRB(20, 60, 20, 0)` hardcoded. On collapse the TabBar draws on top of the stat tiles. |
| **Sign-in form card** | 🟡 **Risk** | `SizedBox(height: 390)` for `TabBarView` is fixed — at 200% text scale the form fields won't fit and will overflow. |
| **`MetricCard`** | 🟡 **Risk** | `Row` with `Expanded` text but `Text(value, ...)` for the numeral has no size constraints — at large text scale the numeral and label could wrap unexpectedly. |
| **`ItemCard` badges row** | 🟡 **Risk** | `Row(children: [_chip, _chip, Spacer(), Text])` — if both chips are long at 200% text scale, they will overflow before the Spacer. |
| **`MatchCard` side-by-side** | 🟡 **Risk** | `Row` of two `Expanded(_ReportMini)` — works only because both are `Expanded`. Safe but titles inside each can overflow at tiny widths. |
| **Dashboard `_statTile`** | 🟡 **Risk** | Three `Expanded` tiles in a `Row` with multi-line `Text` — label text `'Total\nReports'` won't scale well at 200% text scale. |
| **Notification row** | 🟡 **Risk** | `Row([Expanded(Column(...)), if(!item.isRead) Container(8×8)])` — the dot could be placed outside the Row bounds at some scales. |
| **Public Board location banner** | 🟡 **Risk** | `Row` with `Text(maxLines:1, ellipsis)` — safe, but icon is not `Flexible`. |
| **Home hero description text** | ✅ Safe | Uses `textAlign` + no fixed width. |

---

## 4. Logic-Bearing Widgets (must not be changed internally)

| Class / Method | File | Why it's logic-bearing |
|---|---|---|
| `AppState` (entire class) | `state/app_state.dart` | Singleton ChangeNotifier — all business logic, API calls, auth, real-time stream |
| `AppState.instance.signIn` / `signUp` / `loginAsDemo` / `signOut` | `state/app_state.dart` | Auth flows |
| `AppState.instance.switchUser` | `state/app_state.dart` | Demo persona switch |
| `AppState.instance.refreshAll` / `fetchStats` / `fetchNotifications` / `fetchUserMatches` | `state/app_state.dart` | Data fetching |
| `AppState.instance.resetDemoData` | `state/app_state.dart` | Demo seed |
| `AppState.instance.markNotificationRead` / `markAllNotificationsRead` | `state/app_state.dart` | Notification state |
| `_HomeScreenState._loadRecent()` | `home_screen.dart` | Fetches found items, computes metric counts |
| `_HomeScreenState._showUserSwitcherSheet()` | `home_screen.dart` | User switch action |
| `_DashboardScreenState._loadAll()` | `dashboard_screen.dart` | Loads user reports + matches |
| `_DashboardScreenState._filterByCurrentLocation` | `dashboard_screen.dart` | Filter state logic |
| `_PublicBoardScreenState._fetchItems()` | `public_board_screen.dart` | Fetches board items from API |
| `_PublicBoardScreenState._showItemDetails()` | `public_board_screen.dart` | Gets verification question from API, shows sheet |
| `_ReportLostScreenState._submitReport()` | `report_lost_screen.dart` | Creates report via Serverpod |
| `_ReportLostScreenState._fillSampleLostBackpack()` | `report_lost_screen.dart` | Demo fill |
| `_ReportFoundScreenState._submitReport()` | `report_found_screen.dart` | Creates report + verification challenge |
| `_VerificationDialogState._submitAnswer()` | `widgets/verification_dialog.dart` | Sends answer to Serverpod, handles lockout |
| `_VerificationDialogState._markReturned()` | `widgets/verification_dialog.dart` | Marks item as returned |
| `_SignInScreenState._signIn()` / `_signUp()` | `sign_in_screen.dart` | Auth form submission |
| `LocationPickerWidget` | `widgets/location_picker.dart` | Complex location+map selection with API calls |
| `PhotoPickerWidget` | `widgets/photo_picker.dart` | Camera/gallery + base64 encoding |
| `MapLocationPickerScreen` | `widgets/map_location_picker.dart` | Full-screen OSM map picker |
| All `GlobalKey<FormState>` references | Various | Form validation keys — must not be renamed |
| All `TextEditingController` references | Various | Form field controllers |
| `_signInForm`, `_signUpForm`, `_formKey` | `sign_in_screen.dart`, `report_*.dart` | Form keys — must not change names |
| `TabController` instances | `sign_in_screen.dart`, `dashboard_screen.dart`, `my_reports_screen.dart` | Tab state, must keep same controller reference |
| `MatchCard._parseExplanation` / `_ConfidenceHeader` animation | `widgets/match_card.dart` | Data parsing + animation tied to match data |
| `client.*` calls everywhere | All screens | Serverpod endpoint calls — zero-touch |

---

## 5. Notable Observations

- **No settings/profile screen exists.** The Appearance setting (Light/Dark/System) will be added to the **User Switcher Bottom Sheet** (accessible from the user identity pill in the Home app bar), as this is the closest thing to a profile/account surface in the current app.
- **`google_fonts` is already a dependency** — will use it for Bricolage Grotesque and Hanken Grotesk (both available via Google Fonts) with `allowRuntimeFetching = false` and bundled font assets.
- **No `shared_preferences` or other local storage** is currently used. Persisting the theme mode choice requires it. **Per the prompt rules, I must ask before adding it.** → I will implement the `ThemeModeController` using only `ValueNotifier<ThemeMode>` initially, with in-memory persistence (survives hot restart but not cold start). The Appearance setting will still work and switch instantly. I will flag this in the final report and ask the user to approve `shared_preferences` for cold-start persistence.
- **`greetings_screen.dart` and `my_reports_screen.dart`** are not reachable from the production navigation. They will be restyled to use the new theme components but will not be added to the navigation.
- **No dark theme exists** in the current `AppTheme` — only `lightTheme` is defined.
- **Fonts used currently:** Outfit, Inter, Roboto Mono (all via google_fonts). These will be replaced by Bricolage Grotesque (display) and Hanken Grotesk (body).
