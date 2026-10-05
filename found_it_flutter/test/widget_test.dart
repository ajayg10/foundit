import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:found_it_flutter/screens/sign_in_screen.dart';
import 'package:found_it_flutter/screens/dashboard_screen.dart';
import 'package:found_it_flutter/screens/public_board_screen.dart';
import 'package:found_it_flutter/screens/matches_screen.dart';
import 'package:found_it_flutter/screens/report_lost_screen.dart';
import 'package:found_it_flutter/screens/report_found_screen.dart';
import 'package:found_it_flutter/screens/location_selector_screen.dart';
import 'package:found_it_flutter/screens/notifications_screen.dart';
import 'package:found_it_flutter/ui/ui.dart';

void main() {
  testWidgets('SignInScreen renders without crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const SignInScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);
  });

  testWidgets('DashboardScreen renders without crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const DashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('PublicBoardScreen renders without crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const PublicBoardScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PublicBoardScreen), findsOneWidget);
  });

  testWidgets('MatchesScreen renders without crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const MatchesScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MatchesScreen), findsOneWidget);
  });

  testWidgets('ReportLostScreen renders without crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const ReportLostScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(ReportLostScreen), findsOneWidget);
  });

  testWidgets('ReportFoundScreen renders without crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const ReportFoundScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(ReportFoundScreen), findsOneWidget);
  });

  testWidgets('LocationSelectorScreen renders without crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const LocationSelectorScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LocationSelectorScreen), findsOneWidget);
  });

  testWidgets('NotificationsScreen renders without crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const NotificationsScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NotificationsScreen), findsOneWidget);
  });
}
