import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:found_it_flutter/screens/home_screen.dart';
import 'package:found_it_flutter/state/app_state.dart';
import 'package:found_it_flutter/ui/ui.dart';

// Create a mock app wrapper for the test
class TestAppWrapper extends StatelessWidget {
  final Widget child;
  final ThemeMode themeMode;
  final double textScale;

  const TestAppWrapper({
    super.key,
    required this.child,
    this.themeMode = ThemeMode.light,
    this.textScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FoundItTheme.light,
      darkTheme: FoundItTheme.dark,
      themeMode: themeMode,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: childWidget!,
        );
      },
      home: child,
    );
  }
}

void main() {
  setUpAll(() async {
    // Initialize AppState for testing
    // In a real app we'd mock the client, but for widget test layout we just need AppState initialized
    await AppState.instance.initialize();
  });

  final sizes = [
    const Size(320, 568),
    const Size(360, 640),
    const Size(390, 844),
    const Size(820, 1180),
    const Size(844, 390), // Landscape
  ];

  final scales = [1.0, 1.3, 2.0];
  final themes = [ThemeMode.light, ThemeMode.dark];

  for (final size in sizes) {
    for (final scale in scales) {
      for (final theme in themes) {
        testWidgets(
          'HomeScreen layout at ${size.width}x${size.height}, scale $scale, theme ${theme.name}',
          (WidgetTester tester) async {
            // Set logical size
            tester.view.physicalSize = Size(
              size.width * 3.0,
              size.height * 3.0,
            );
            tester.view.devicePixelRatio = 3.0;

            await tester.pumpWidget(
              TestAppWrapper(
                themeMode: theme,
                textScale: scale,
                child: const HomeScreen(),
              ),
            );

            await tester.pumpAndSettle();

            // If there is any overflow, takeException() will return the FlutterError
            final exception = tester.takeException();
            expect(
              exception,
              isNull,
              reason:
                  'Layout overflowed at ${size.width}x${size.height}, scale $scale, theme ${theme.name}',
            );

            // Reset view
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          },
        );
      }
    }
  }
}
