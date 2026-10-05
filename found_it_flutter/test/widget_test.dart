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
import 'package:found_it_flutter/screens/home_screen.dart';
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

  testWidgets('Bottom navigation bar stays pinned across all tabs', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FoundItTheme.light,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Initial state: on Home tab, bottom navigation bar is present
    expect(find.byType(AppBottomNav), findsOneWidget);

    // 2. Tap "Public Board" tab
    await tester.tap(find.text('Public Board').first);
    await tester.pumpAndSettle();
    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(find.byType(PublicBoardScreen), findsOneWidget);

    // 3. Tap "Matches" tab
    await tester.tap(find.text('Matches').first);
    await tester.pumpAndSettle();
    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(find.byType(MatchesScreen), findsOneWidget);

    // 4. Tap "My Activity" tab
    await tester.tap(find.text('My Activity').first);
    await tester.pumpAndSettle();
    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(find.byType(DashboardScreen), findsOneWidget);

    // 5. Tap "Home" tab
    await tester.tap(find.text('Home').first);
    await tester.pumpAndSettle();
    expect(find.byType(AppBottomNav), findsOneWidget);
  });
}
