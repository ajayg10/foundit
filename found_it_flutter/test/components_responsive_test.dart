import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:found_it_flutter/ui/ui.dart';

void main() {
  final sizes = {
    'iPhone SE': const Size(320.0, 568.0),
    'Phone': const Size(390.0, 844.0),
    'iPad': const Size(820.0, 1180.0),
  };

  final scales = {
    'normal': 1.0,
    'large text': 2.0,
  };

  Widget wrap(Widget child, Size size, double textScale) {
    return MaterialApp(
      theme: FoundItTheme.light,
      home: Theme(
        data: FoundItTheme.light,
        child: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  group('Responsive component tests', () {
    for (final sizeEntry in sizes.entries) {
      for (final scaleEntry in scales.entries) {
        final desc = '${sizeEntry.key} at ${scaleEntry.key}';

        testWidgets('AppButton responsive - $desc', (
          WidgetTester tester,
        ) async {
          tester.view.physicalSize = sizeEntry.value;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            wrap(
              AppButton(
                onPressed: () {},
                label: 'Test Button',
                icon: Icons.check,
              ),
              sizeEntry.value,
              scaleEntry.value,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          addTearDown(tester.view.resetPhysicalSize);
        });

        testWidgets('AppChip responsive - $desc', (WidgetTester tester) async {
          tester.view.physicalSize = sizeEntry.value;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            wrap(
              AppChip(
                label: 'Test Chip',
                selected: false,
                onSelected: (v) {},
              ),
              sizeEntry.value,
              scaleEntry.value,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          addTearDown(tester.view.resetPhysicalSize);
        });

        testWidgets('BrandHeader responsive - $desc', (
          WidgetTester tester,
        ) async {
          tester.view.physicalSize = sizeEntry.value;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            wrap(
              BrandHeader(
                onUserSwitch: () {},
                onDemoSeed: () {},
                onLocationChanged: () {},
              ),
              sizeEntry.value,
              scaleEntry.value,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          addTearDown(tester.view.resetPhysicalSize);
        });

        testWidgets('TicketHero responsive - $desc', (
          WidgetTester tester,
        ) async {
          tester.view.physicalSize = sizeEntry.value;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            wrap(
              TicketHero(
                onLostTap: () {},
                onFoundTap: () {},
              ),
              sizeEntry.value,
              scaleEntry.value,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          addTearDown(tester.view.resetPhysicalSize);
        });

        testWidgets('StatBento responsive - $desc', (
          WidgetTester tester,
        ) async {
          tester.view.physicalSize = sizeEntry.value;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            wrap(
              StatBento(
                matchedCount: 10,
                lostCount: 5,
                foundCount: 5,
                returnedCount: 5,
                locationName: 'Test Location',
                onMatchesTap: () {},
                onLostTap: () {},
                onFoundTap: () {},
                onReturnedTap: () {},
              ),
              sizeEntry.value,
              scaleEntry.value,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          addTearDown(tester.view.resetPhysicalSize);
        });
      }
    }
  });
}
