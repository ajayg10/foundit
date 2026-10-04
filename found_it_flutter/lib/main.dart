import 'package:flutter/material.dart';
import 'client.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'state/app_state.dart';
import 'ui/ui.dart'; // new design-system

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeModeController.instance.init();

  // Global error handler to catch and display any render errors clearly
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FLUTTER_ERROR: ${details.exceptionAsString()}');
    debugPrint('FLUTTER_STACK: ${details.stack}');
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Builder(
      builder: (context) {
        final ext = Theme.of(context).extension<AppSemantic>();
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final colors = ext ?? (isDark ? AppSemantic.dark : AppSemantic.light);

        return Material(
          color: colors.errorSoft,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error_outline, color: colors.error, size: 28),
                      AppSpacing.hGap8,
                      Text(
                        'Render Error Encountered',
                        style: AppText.h3(colors.error),
                      ),
                    ],
                  ),
                  AppSpacing.gap12,
                  SelectableText(
                    details.exceptionAsString(),
                    style: AppText.body(colors.error).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.gap12,
                  SelectableText(
                    details.stack?.toString() ?? 'No stack trace available',
                    style: AppText.caption(colors.error).copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    // Listen to both AppState (auth changes) and ThemeModeController (mode).
    return ListenableBuilder(
      listenable: Listenable.merge([
        AppState.instance,
        ThemeModeController.instance,
      ]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Found It — AI-Powered Lost & Found',
          debugShowCheckedModeBanner: false,
          theme: FoundItTheme.light,
          darkTheme: FoundItTheme.dark,
          themeMode: ThemeModeController.instance.mode,
          home: AppState.instance.isAuthenticated
              ? const HomeScreen()
              : const SignInScreen(),
        );
      },
    );
  }
}
