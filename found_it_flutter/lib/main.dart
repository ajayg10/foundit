import 'package:flutter/material.dart';
import 'client.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handler to catch and display any render errors clearly
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FLUTTER_ERROR: ${details.exceptionAsString()}');
    debugPrint('FLUTTER_STACK: ${details.stack}');
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: const Color(0xFFFEF2F2),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Render Error Encountered',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SelectableText(
                details.exceptionAsString(),
                style: const TextStyle(
                  color: Color(0xFF991B1B),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              SelectableText(
                details.stack?.toString() ?? 'No stack trace available',
                style: const TextStyle(
                  color: Color(0xFF7F1D1D),
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  };

  await initializeClient();
  await AppState.instance.initialize();
  runApp(const FoundItApp());
}

class FoundItApp extends StatelessWidget {
  const FoundItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Found It — AI-Powered Lost & Found',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: AppState.instance.isAuthenticated
              ? const HomeScreen()
              : const SignInScreen(),
        );
      },
    );
  }
}
