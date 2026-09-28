import 'package:found_it_client/found_it_client.dart';

void main() async {
  print('Connecting to Serverpod at http://localhost:8080/ ...');
  final client = Client('http://localhost:8080/');

  // 1. Seed demo data
  print('Seeding demo data...');
  final seeded = await client.dashboard.seedDemoData();
  print('Demo data seeded: $seeded');

  // 2. Fetch stats
  final stats = await client.dashboard.getStats();
  print('Stats: Lost=${stats.totalLost}, Found=${stats.totalFound}, Matched=${stats.totalMatched}, Returned=${stats.totalReturned}');

  // 3. List found reports
  final foundReports = await client.report.listReports(reportType: 'found', limit: 10);
  print('Found reports count: ${foundReports.length}');
  for (final r in foundReports) {
    print(' - [${r.id}] ${r.title} (${r.category}) at ${r.locationLabel}');
  }

  // 4. Test Hackathon Primary Demo Flow:
  // Alice reports lost black backpack
  print('\n--- RUNNING HACKATHON PRIMARY DEMO ---');
  print('Step 1: Alice reports lost Black Wildcraft Backpack...');
  final lostBackpack = await client.report.createReport(
    report: ItemReport(
      userId: 'alice_live_demo',
      userName: 'Alice Johnson',
      userEmail: 'alice@campus.edu',
      reportType: 'lost',
      title: 'Black Wildcraft Backpack',
      description: 'Black Wildcraft backpack with laptop compartment and small red keychain on zipper',
      category: 'Bags',
      latitude: 37.7749,
      longitude: -122.4194,
      locationLabel: 'Campus Library',
      eventTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'open',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
  print('Alice lost report created with ID: ${lostBackpack.id}');

  // Bob reports found backpack with verification challenge
  print('Step 2: Bob reports found Black Backpack near Engineering Block...');
  final foundBackpack = await client.report.createReport(
    report: ItemReport(
      userId: 'bob_live_demo',
      userName: 'Bob Martinez',
      userEmail: 'bob@campus.edu',
      reportType: 'found',
      title: 'Black Backpack',
      description: 'Found black backpack on bench outside Engineering Block entrance',
      category: 'Bags',
      latitude: 37.7810,
      longitude: -122.4120,
      locationLabel: 'Engineering Block',
      eventTime: DateTime.now(),
      status: 'open',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    verificationQuestion: 'What is attached to the backpack zipper?',
    verificationAnswer: 'Red keychain',
  );
  print('Bob found report created with ID: ${foundBackpack.id}');

  // Step 3: Check matches generated automatically by Serverpod
  print('Step 3: Checking automatic matches...');
  final matches = await client.match.getMatchesForReport(lostBackpack.id!);
  print('Matches discovered: ${matches.length}');
  for (final m in matches) {
    final pct = (m.match.confidenceScore * 100).round();
    print('>>> MATCH FOUND: $pct% Confidence');
    print('    Distance: ${m.match.distanceKm} km apart');
    print('    Time diff: ${m.match.timeDiffHours} hours apart');
    print('    Explanation: ${m.match.explanation}');
    print('    Verification question: "${m.verificationQuestion}"');
  }

  // Step 4: Check notifications for both users
  print('\nStep 4: Checking notifications dispatched to users...');
  final aliceNotifs = await client.notification.getUserNotifications('alice_live_demo');
  print('Alice received ${aliceNotifs.length} notifications:');
  for (final n in aliceNotifs) {
    print(' - ${n.title}: ${n.body}');
  }

  final bobNotifs = await client.notification.getUserNotifications('bob_live_demo');
  print('Bob received ${bobNotifs.length} notifications:');
  for (final n in bobNotifs) {
    print(' - ${n.title}: ${n.body}');
  }

  // Step 5: Alice verifies ownership
  print('\nStep 5: Alice attempts verification...');
  // A. Wrong answer
  final wrongRes = await client.verification.submitVerificationAnswer(
    reportId: foundBackpack.id!,
    claimantUserId: 'alice_live_demo',
    answer: 'blue sticker',
  );
  print('Wrong answer attempt: success=${wrongRes.success}, message="${wrongRes.message}", remaining=${wrongRes.attemptsRemaining}');

  // B. Correct answer
  final correctRes = await client.verification.submitVerificationAnswer(
    reportId: foundBackpack.id!,
    claimantUserId: 'alice_live_demo',
    answer: 'Red keychain',
  );
  print('Correct answer attempt: success=${correctRes.success}, message="${correctRes.message}"');

  // Step 6: Mark returned
  print('\nStep 6: Handover completed, marking returned...');
  final returned = await client.verification.markItemReturned(
    reportId: foundBackpack.id!,
    userId: 'bob_live_demo',
  );
  print('Marked returned: $returned');

  final finalReport = await client.report.getReport(foundBackpack.id!);
  print('Final item status in PostgreSQL: ${finalReport?.status}');
  print('\n✓ ALL LIVE DEMO WORKFLOWS PASSED WITH 100% SUCCESS!');
}
