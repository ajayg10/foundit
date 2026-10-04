import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:found_it_client/found_it_client.dart';
import 'package:found_it_flutter/screens/my_reports_screen.dart';
import 'package:found_it_flutter/ui/ui.dart';
import 'package:found_it_flutter/state/app_state.dart';

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
  setUpAll(() {
    try {
      AppState.instance.initialize();
    } catch (_) {}
  });

  group('MyReportsScreen responsive checks', () {
    final viewports = [
      const Size(320, 568),
      const Size(390, 844),
      const Size(844, 390),
      const Size(820, 1180),
    ];
    final textScales = [1.0, 2.0];
    final themes = [ThemeMode.light, ThemeMode.dark];

    for (final size in viewports) {
      for (final scale in textScales) {
        for (final theme in themes) {
          testWidgets(
              'MyReportsScreen at ${size.width}x${size.height}, scale=$scale, theme=${theme.name}',
              (tester) async {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1.0;

            await tester.pumpWidget(
              TestAppWrapper(
                themeMode: theme,
                textScale: scale,
                child: const MyReportsScreen(),
              ),
            );

            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  });
}
