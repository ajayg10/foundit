import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// When you are running the app on a physical device, you need to set the
// server URL to the IP address of your computer. You can find the IP
// address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
//
// You can set the variable when running or building your app like this:
// E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`
//
// Otherwise, the server URL is fetched from the assets/config.json file or
// defaults to http://localhost:8080/ if not found.
final serverUrl = getServerUrl();

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
late final Client client;

/// Google Maps / Places API key loaded from assets/config.json.
/// Set your actual key in assets/config.json (field: "googleMapsApiKey").
String googleMapsApiKey = '';

Future<void> initializeClient() async {
  // Load config
  try {
    final configStr = await rootBundle.loadString('assets/config.json');
    final config = json.decode(configStr) as Map<String, dynamic>;
    googleMapsApiKey =
        const String.fromEnvironment('GOOGLE_MAPS_API_KEY').isNotEmpty
        ? const String.fromEnvironment('GOOGLE_MAPS_API_KEY')
        : (config['googleMapsApiKey'] as String? ?? '');
  } catch (_) {
    googleMapsApiKey = '';
  }

  client = Client(await serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  unawaited(client.auth.initialize());
}
