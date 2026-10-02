import 'dart:async';
import 'package:flutter/material.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../client.dart';

/// App-wide state management for user session, real-time alerts, and demo mode.
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal();

  // Preset demo identities for hackathon presentation
  static final AppUser demoAlice = AppUser(
    userId: 'user_alice_demo',
    name: 'Alice Johnson (Lost Item)',
    email: 'alice@campus.edu',
    phoneNumber: '+1 555-0101',
    createdAt: DateTime.now(),
  );

  static final AppUser demoBob = AppUser(
    userId: 'user_bob_demo',
    name: 'Bob Martinez (Found Item)',
    email: 'bob@campus.edu',
    phoneNumber: '+1 555-0102',
    createdAt: DateTime.now(),
  );

  // Active current user
  AppUser _currentUser = demoAlice;
  AppUser get currentUser => _currentUser;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // Locations state
  Location? _currentLocation;
  Location? get currentLocation => _currentLocation;

  List<Location> _locations = [];
  List<Location> get locations => _locations;

  List<LocationArea> _currentLocationAreas = [];
  List<LocationArea> get currentLocationAreas => _currentLocationAreas;

  // Platform statistics
  DashboardStats? _stats;
  DashboardStats? get stats => _stats;

  // Notifications
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;
  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  // User matches
  List<MatchDetailsDto> _userMatches = [];
  List<MatchDetailsDto> get userMatches => _userMatches;

  // Stream subscription for real-time Serverpod notifications
  StreamSubscription<AppNotification>? _notificationSubscription;
  Timer? _pollingTimer;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Initializes state, syncs user with server, loads locations, and connects real-time notification stream.
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (client.auth.isAuthenticated) {
        _isAuthenticated = true;
      }
      await _syncUserWithServer();
      await fetchLocations();
      await refreshAll();
      _startNotificationListener();
    } catch (e) {
      debugPrint('AppState init error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final cleanName = email.split('@').first;
      final userId =
          'user_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase()}';
      final appUser = await client.user.getOrCreateUser(
        userId: userId,
        name: cleanName,
        email: email.trim(),
      );
      _currentUser = appUser;
      _isAuthenticated = true;
      await refreshAll();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userId =
          'user_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase()}';
      final appUser = await client.user.getOrCreateUser(
        userId: userId,
        name: name.trim(),
        email: email.trim(),
      );
      _currentUser = appUser;
      _isAuthenticated = true;
      await refreshAll();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginAsDemo(AppUser demoUser) async {
    _currentUser = demoUser;
    _isAuthenticated = true;
    notifyListeners();
    await _syncUserWithServer();
    await refreshAll();
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOutDevice();
    } catch (_) {}
    _currentUser = demoAlice;
    _isAuthenticated = false;
    _notificationSubscription?.cancel();
    _notificationSubscription = null;
    notifyListeners();
  }

  /// Fetches available locations and defaults to IIT Delhi if none selected.
  Future<void> fetchLocations({String? query, String? type}) async {
    try {
      final locs = await client.location.listLocations(
        query: query,
        type: type,
      );
      _locations = locs;

      if (_currentLocation == null && _locations.isNotEmpty) {
        // Try to pick IIT Delhi first as default demo campus
        final defaultLoc = _locations.firstWhere(
          (l) => l.name.toLowerCase().contains('iit delhi'),
          orElse: () => _locations.first,
        );
        await selectLocation(defaultLoc);
      } else if (_currentLocation != null) {
        // Refresh current location areas
        await fetchLocationAreas(_currentLocation!.id!);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Fetch locations error: $e');
    }
  }

  /// Selects active location and loads its sub-areas.
  Future<void> selectLocation(Location location) async {
    _currentLocation = location;
    notifyListeners();
    if (location.id != null) {
      await fetchLocationAreas(location.id!);
    } else {
      _currentLocationAreas = [];
      notifyListeners();
    }
  }

  /// Fetches sub-areas for a given location.
  Future<void> fetchLocationAreas(int locationId) async {
    try {
      final areas = await client.location.getLocationAreas(locationId);
      _currentLocationAreas = areas;
      notifyListeners();
    } catch (e) {
      debugPrint('Fetch location areas error: $e');
    }
  }

  /// Creates a new location and selects it.
  Future<Location> createLocation(Location location) async {
    final created = await client.location.createLocation(location);
    _locations.insert(0, created);
    await selectLocation(created);
    notifyListeners();
    return created;
  }

  /// Adds a new area to a location.
  Future<LocationArea> createLocationArea(LocationArea area) async {
    final created = await client.location.createLocationArea(area);
    _currentLocationAreas.add(created);
    notifyListeners();
    return created;
  }

  /// Switches active demo user (e.g. Alice -> Bob for 2-user demo).
  Future<void> switchUser(AppUser newUser) async {
    _currentUser = newUser;
    _notificationSubscription?.cancel();
    _notificationSubscription = null;

    notifyListeners();

    await _syncUserWithServer();
    await refreshAll();
    _startNotificationListener();
  }

  /// Syncs user profile in Serverpod database.
  Future<void> _syncUserWithServer() async {
    try {
      final user = await client.user.getOrCreateUser(
        userId: _currentUser.userId,
        name: _currentUser.name,
        email: _currentUser.email,
        phone: _currentUser.phoneNumber,
      );
      _currentUser = user;
    } catch (e) {
      debugPrint('Sync user error: $e');
    }
  }

  /// Refreshes platform stats, notifications, and user matches.
  Future<void> refreshAll() async {
    await Future.wait([
      fetchStats(),
      fetchNotifications(),
      fetchUserMatches(),
    ]);
  }

  Future<void> fetchStats() async {
    try {
      _stats = await client.dashboard.getStats();
      notifyListeners();
    } catch (e) {
      debugPrint('Fetch stats error: $e');
    }
  }

  Future<void> fetchNotifications() async {
    try {
      _notifications = await client.notification.getUserNotifications(
        _currentUser.userId,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Fetch notifications error: $e');
    }
  }

  Future<void> fetchUserMatches() async {
    try {
      _userMatches = await client.match.getUserMatches(_currentUser.userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Fetch user matches error: $e');
    }
  }

  Future<void> markNotificationRead(int id) async {
    try {
      await client.notification.markAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].isRead = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Mark notification read error: $e');
    }
  }

  Future<void> markAllNotificationsRead() async {
    try {
      await client.notification.markAllAsRead(_currentUser.userId);
      for (final n in _notifications) {
        n.isRead = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Mark all read error: $e');
    }
  }

  /// One-click hackathon demo reset.
  Future<void> resetDemoData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await client.dashboard.seedDemoData();
      await refreshAll();
    } catch (e) {
      debugPrint('Reset demo data error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Subscribes to Serverpod 4 real-time notification stream.
  void _startNotificationListener() {
    _notificationSubscription?.cancel();
    _pollingTimer?.cancel();

    try {
      // 1. Listen to real-time streaming endpoint method
      final stream = client.notification.watchNotifications(
        _currentUser.userId,
      );
      _notificationSubscription = stream.listen(
        (notification) {
          _notifications.insert(0, notification);
          fetchStats();
          fetchUserMatches();
          notifyListeners();
        },
        onError: (err) {
          debugPrint('Notification stream error, using fallback: $err');
          _startFallbackPolling();
        },
        onDone: () {
          debugPrint('Notification stream closed, restarting...');
          _startFallbackPolling();
        },
      );
    } catch (e) {
      debugPrint('Could not connect real-time notification stream: $e');
      _startFallbackPolling();
    }

    // Also run a subtle 10s background poll as fallback guarantee
    _startFallbackPolling();
  }

  void _startFallbackPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      fetchNotifications();
      fetchUserMatches();
      fetchStats();
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _pollingTimer?.cancel();
    super.dispose();
  }
}
