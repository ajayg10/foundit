import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:found_it_flutter/screens/dashboard_screen.dart';
import 'package:found_it_flutter/state/app_state.dart';
import 'package:found_it_flutter/ui/ui.dart';

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
    await AppState.instance.initialize();
  });

  final sizes = [
    const Size(320, 568),
    const Size(390, 844),
    const Size(820, 1180),
    const Size(844, 390),
  ];

  final scales = [1.0, 2.0];
  final themes = [ThemeMode.light, ThemeMode.dark];

  group('Dashboard layout responsive checks', () {
    for (var size in sizes) {
      for (var scale in scales) {
        for (var theme in themes) {
          testWidgets(
            'Dashboard at ${size.width}x${size.height}, scale=$scale, theme=${theme.name}',
            (tester) async {
              tester.view.physicalSize = size;
              tester.view.devicePixelRatio = 1.0;
              addTearDown(() => tester.view.resetPhysicalSize());

              await tester.pumpWidget(
                TestAppWrapper(
                  themeMode: theme,
                  textScale: scale,
                  child: const DashboardScreen(),
                ),
              );

              // Let the future complete (it will throw but we catch it)
              await tester.pumpAndSettle();

              expect(tester.takeException(), isNull);

              // Find SummaryPanel and AppTabBar to check overlap
              final summaryPanel = find.byType(SummaryPanel);
              final tabBar = find.byType(AppTabBar);

              if (summaryPanel.evaluate().isNotEmpty &&
                  tabBar.evaluate().isNotEmpty) {
                final summaryRect = tester.getRect(summaryPanel);
                final tabBarRect = tester.getRect(tabBar);

                // Assert tab bar top is at or below summary panel bottom
                expect(
                  tabBarRect.top >= summaryRect.bottom - 1,
                  isTrue,
                  reason: 'TabBar overlaps SummaryPanel',
                );
              }
            },
          );
        }
      }
    }
  });
}
