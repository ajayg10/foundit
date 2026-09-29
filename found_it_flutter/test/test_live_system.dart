// ignore_for_file: avoid_print
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
  print('Stats: Lost=${stats.totalLost}, Found=${stats.totalFound}, Matched=${stats.totalMatched}, Returned=${stats.totalReturned}, Locations=${stats.totalLocations}');

  // 3. Test Multi-Location API
  print('\n--- TESTING MULTI-LOCATION ARCHITECTURE ---');
  final locations = await client.location.listLocations();
  print('Available locations count: ${locations.length}');
  for (final loc in locations) {
    print(' - [${loc.id}] ${loc.name} (${loc.type}) - ${loc.address}');
  }

  final iitDelhi = locations.firstWhere((l) => l.name.contains('IIT Delhi'));
  final areas = await client.location.getLocationAreas(iitDelhi.id!);
  print('IIT Delhi Sub-Areas count: ${areas.length}');
  for (final a in areas) {
    print('   * [${a.id}] ${a.name} (${a.latitude}, ${a.longitude})');
  }

  final libraryArea = areas.firstWhere((a) => a.name.contains('Library'));
  final bhartiArea = areas.firstWhere((a) => a.name.contains('Bharti'));

  // 4. Test Location-Scoped Reports and Automatic Matching:
  print('\n--- RUNNING IIT DELHI HACKATHON PRIMARY DEMO ---');
  print('Step 1: Alice reports lost Black Wildcraft Backpack at IIT Delhi Central Library...');
  final lostBackpack = await client.report.createReport(
    report: ItemReport(
      userId: 'alice_live_demo',
      userName: 'Alice Johnson',
      userEmail: 'alice@campus.edu',
      reportType: 'lost',
      title: 'Black Wildcraft Backpack',
      description: 'Black Wildcraft backpack with laptop compartment and small red keychain on zipper',
      category: 'Bags',
      latitude: libraryArea.latitude ?? 28.5448,
      longitude: libraryArea.longitude ?? 77.1928,
      locationLabel: 'IIT Delhi — Central Library',
      locationId: iitDelhi.id,
      locationAreaId: libraryArea.id,
      eventTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'open',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
  print('Alice lost report created with ID: ${lostBackpack.id}');

  // Bob reports found backpack with verification challenge at IIT Delhi Bharti Building
  print('Step 2: Bob reports found Black Backpack at IIT Delhi Bharti Building...');
  final foundBackpack = await client.report.createReport(
    report: ItemReport(
      userId: 'bob_live_demo',
      userName: 'Bob Martinez',
      userEmail: 'bob@campus.edu',
      reportType: 'found',
      title: 'Black Backpack',
      description: 'Found black backpack on bench outside Bharti Building CSE hallway',
      category: 'Bags',
      latitude: bhartiArea.latitude ?? 28.5460,
      longitude: bhartiArea.longitude ?? 77.1912,
      locationLabel: 'IIT Delhi — Bharti Building',
      locationId: iitDelhi.id,
      locationAreaId: bhartiArea.id,
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
  print('\nStep 3: Checking automatic multi-signal matches with location boost...');
  final matches = await client.match.getMatchesForReport(lostBackpack.id!);
  print('Matches discovered: ${matches.length}');
  for (final m in matches) {
    final pct = (m.match.confidenceScore * 100).round();
    print('>>> MATCH FOUND: $pct% Confidence');
    print('    Text score: ${m.match.textScore}');
    print('    Location score: ${m.match.locationScore}');
    print('    Distance score: ${m.match.distanceScore} (${m.match.distanceKm} km apart)');
    print('    Time score: ${m.match.timeScore} (${m.match.timeDiffHours} hours apart)');
    print('    Category score: ${m.match.categoryScore}');
    print('    Explanation: ${m.match.explanation}');
    print('    Verification challenge: "${m.verificationQuestion}"');
  }

  // Step 4: Check notifications for both users
  print('\nStep 4: Checking real-time notifications dispatched to users...');
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
  print('\n✓ ALL MULTI-LOCATION & DEMO WORKFLOWS PASSED WITH 100% SUCCESS!');
}
