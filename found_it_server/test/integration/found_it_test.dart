import 'package:test/test.dart';
import 'package:found_it_server/src/generated/protocol.dart';
import 'package:found_it_server/src/services/distance_service.dart';
import 'package:found_it_server/src/services/matching_service.dart';
import 'package:found_it_server/src/services/similarity_service.dart';
import 'package:found_it_server/src/services/time_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  group('Unit Tests: Matching Engine Signals', () {
    final similarity = SimilarityService();

    test('Identical descriptions have high text similarity', () {
      final sim = similarity.calculateTextSimilarity(
        title1: 'Black Wildcraft Backpack',
        description1: 'Black backpack with laptop compartment and red keychain',
        title2: 'Black Wildcraft Backpack',
        description2: 'Black backpack with laptop compartment and red keychain',
      );
      expect(sim, greaterThan(0.90));
    });

    test('Completely different descriptions have low text similarity', () {
      final sim = similarity.calculateTextSimilarity(
        title1: 'Black Wildcraft Backpack',
        description1: 'Black backpack with laptop compartment and red keychain',
        title2: 'Silver Honda Car Keys',
        description2: 'Set of 4 keys with remote key fob and blue lanyard',
      );
      expect(sim, lessThan(0.20));
    });

    test('Nearby locations have high distance score, distant locations have low score', () {
      // Library to Engineering Block (~0.8 km)
      final d1 = DistanceService.calculateDistanceKm(
        lat1: 37.7749,
        lon1: -122.4194,
        lat2: 37.7810,
        lon2: -122.4120,
      );
      final score1 = DistanceService.calculateDistanceScore(d1);
      expect(d1, lessThan(1.5));
      expect(score1, greaterThan(0.70));

      // Campus to distant city (~50 km)
      final d2 = DistanceService.calculateDistanceKm(
        lat1: 37.7749,
        lon1: -122.4194,
        lat2: 37.3382,
        lon2: -121.8863,
      );
      final score2 = DistanceService.calculateDistanceScore(d2);
      expect(d2, greaterThan(40.0));
      expect(score2, lessThan(0.10));
    });

    test('Close timestamps have higher time score than distant timestamps', () {
      final now = DateTime.now();
      final diff2Hours = TimeService.calculateDifferenceHours(
        now,
        now.subtract(const Duration(hours: 2)),
      );
      final score2Hours = TimeService.calculateTimeScore(diff2Hours);

      final diff30Days = TimeService.calculateDifferenceHours(
        now,
        now.subtract(const Duration(days: 30)),
      );
      final score30Days = TimeService.calculateTimeScore(diff30Days);

      expect(score2Hours, greaterThan(0.95));
      expect(score30Days, lessThan(0.15));
      expect(score2Hours, greaterThan(score30Days));
    });

    test('Same category yields higher match score than different category', () {
      final now = DateTime.now();
      final lost = ItemReport(
        userId: 'u1',
        userName: 'Alice',
        userEmail: 'alice@test.com',
        reportType: 'lost',
        title: 'Black Backpack',
        description: 'Black backpack found near library',
        category: 'Bags',
        latitude: 37.7749,
        longitude: -122.4194,
        locationLabel: 'Library',
        eventTime: now,
        status: 'open',
        createdAt: now,
        updatedAt: now,
      );

      final foundSameCategory = ItemReport(
        userId: 'u2',
        userName: 'Bob',
        userEmail: 'bob@test.com',
        reportType: 'found',
        title: 'Black Backpack',
        description: 'Black backpack near engineering',
        category: 'Bags',
        latitude: 37.7750,
        longitude: -122.4195,
        eventTime: now.subtract(const Duration(hours: 1)),
        locationLabel: 'Engineering Block',
        status: 'open',
        createdAt: now,
        updatedAt: now,
      );

      final foundDiffCategory = foundSameCategory.copyWith(category: 'Clothing');

      final evalSame = MatchingService.evaluateMatch(
        lostReport: lost,
        foundReport: foundSameCategory,
      );
      final evalDiff = MatchingService.evaluateMatch(
        lostReport: lost,
        foundReport: foundDiffCategory,
      );

      expect(evalSame.confidenceScore, greaterThan(evalDiff.confidenceScore));
      expect(evalSame.explanation, contains('Bags'));
    });
  });

  withServerpod('Found It Integration Tests', (sessionBuilder, endpoints) {
    test('End-to-End: Report creation triggers matching and notifications', () async {
      final now = DateTime.now();

      // 1. Alice reports lost backpack
      final lostReport = await endpoints.report.createReport(
        sessionBuilder,
        report: ItemReport(
          userId: 'alice_integration_test',
          userName: 'Alice Test',
          userEmail: 'alice@integration.test',
          reportType: 'lost',
          title: 'Black Wildcraft Backpack',
          description: 'Black backpack with laptop sleeve and small red keychain',
          category: 'Bags',
          latitude: 37.7749,
          longitude: -122.4194,
          locationLabel: 'Campus Library',
          eventTime: now.subtract(const Duration(hours: 2)),
          status: 'open',
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect(lostReport.id, isNotNull);

      // 2. Bob reports found backpack with verification challenge
      final foundReport = await endpoints.report.createReport(
        sessionBuilder,
        report: ItemReport(
          userId: 'bob_integration_test',
          userName: 'Bob Test',
          userEmail: 'bob@integration.test',
          reportType: 'found',
          title: 'Black Wildcraft Backpack',
          description: 'Found black Wildcraft backpack near library entrance',
          category: 'Bags',
          latitude: 37.7755,
          longitude: -122.4190,
          locationLabel: 'Library Entrance',
          eventTime: now.subtract(const Duration(hours: 1)),
          status: 'open',
          createdAt: now,
          updatedAt: now,
        ),
        verificationQuestion: 'What color is the keychain attached to the zipper?',
        verificationAnswer: 'red',
      );

      expect(foundReport.id, isNotNull);

      // 3. Verify matches were generated automatically
      final matches = await endpoints.match.getMatchesForReport(
        sessionBuilder,
        lostReport.id!,
      );

      expect(matches, isNotEmpty);
      final topMatch = matches.first;
      expect(topMatch.match.confidenceScore, greaterThan(0.60));
      expect(topMatch.lostReport.title, contains('Backpack'));
      expect(topMatch.foundReport.title, contains('Backpack'));
      expect(topMatch.verificationQuestion, isNotNull);

      // 4. Verify notifications generated for both users
      final aliceNotifs = await endpoints.notification.getUserNotifications(
        sessionBuilder,
        'alice_integration_test',
      );
      final bobNotifs = await endpoints.notification.getUserNotifications(
        sessionBuilder,
        'bob_integration_test',
      );

      expect(aliceNotifs, isNotEmpty);
      expect(bobNotifs, isNotEmpty);

      // 5. Verification tests
      // A. Public question access (does NOT return the answer)
      final question = await endpoints.verification.getVerificationQuestion(
        sessionBuilder,
        foundReport.id!,
      );
      expect(question, 'What color is the keychain attached to the zipper?');

      // B. Incorrect answer verification
      final wrongAttempt = await endpoints.verification.submitVerificationAnswer(
        sessionBuilder,
        reportId: foundReport.id!,
        claimantUserId: 'alice_integration_test',
        answer: 'blue',
      );
      expect(wrongAttempt.success, isFalse);
      expect(wrongAttempt.attemptsRemaining, 4);
      expect(wrongAttempt.isLocked, isFalse);

      // C. Correct answer verification
      final correctAttempt = await endpoints.verification.submitVerificationAnswer(
        sessionBuilder,
        reportId: foundReport.id!,
        claimantUserId: 'alice_integration_test',
        answer: 'Red', // test case-insensitivity & whitespace trimming
      );
      expect(correctAttempt.success, isTrue);
      expect(correctAttempt.message, contains('successful'));

      // D. Mark item returned and lifecycle complete
      final returned = await endpoints.verification.markItemReturned(
        sessionBuilder,
        reportId: foundReport.id!,
        userId: 'bob_integration_test',
      );
      expect(returned, isTrue);

      final updatedFound = await endpoints.report.getReport(
        sessionBuilder,
        foundReport.id!,
      );
      expect(updatedFound?.status, 'returned');
    });

    test('Brute force defense: Repeated incorrect answers lock verification', () async {
      final now = DateTime.now();

      final foundReport = await endpoints.report.createReport(
        sessionBuilder,
        report: ItemReport(
          userId: 'finder_lock_test',
          userName: 'Finder',
          userEmail: 'finder@lock.test',
          reportType: 'found',
          title: 'Car Key Fob',
          description: 'Found Honda key fob',
          category: 'Keys',
          latitude: 37.77,
          longitude: -122.41,
          locationLabel: 'Parking',
          eventTime: now,
          status: 'open',
          createdAt: now,
          updatedAt: now,
        ),
        verificationQuestion: 'What logo is on the back?',
        verificationAnswer: 'secret_code_123',
      );

      // Submit 5 incorrect attempts
      for (var i = 1; i <= 4; i++) {
        final attempt = await endpoints.verification.submitVerificationAnswer(
          sessionBuilder,
          reportId: foundReport.id!,
          claimantUserId: 'attacker',
          answer: 'wrong_$i',
        );
        expect(attempt.success, isFalse);
        expect(attempt.isLocked, isFalse);
      }

      // 5th attempt should lock
      final fifthAttempt = await endpoints.verification.submitVerificationAnswer(
        sessionBuilder,
        reportId: foundReport.id!,
        claimantUserId: 'attacker',
        answer: 'wrong_5',
      );
      expect(fifthAttempt.success, isFalse);
      expect(fifthAttempt.isLocked, isTrue);

      // Subsequent attempt even with correct answer must be rejected because it is locked
      final lateAttempt = await endpoints.verification.submitVerificationAnswer(
        sessionBuilder,
        reportId: foundReport.id!,
        claimantUserId: 'attacker',
        answer: 'secret_code_123',
      );
      expect(lateAttempt.success, isFalse);
      expect(lateAttempt.isLocked, isTrue);
    });

    test('Authorization: User cannot modify another user\'s report', () async {
      final now = DateTime.now();

      final report = await endpoints.report.createReport(
        sessionBuilder,
        report: ItemReport(
          userId: 'owner_user',
          userName: 'Owner',
          userEmail: 'owner@test.com',
          reportType: 'lost',
          title: 'My Laptop',
          description: 'Dell XPS 15',
          category: 'Electronics',
          latitude: 37.77,
          longitude: -122.41,
          locationLabel: 'Study Hall',
          eventTime: now,
          status: 'open',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Impostor attempts to update owner's report
      expect(
        () async => await endpoints.report.updateReportStatus(
          sessionBuilder,
          reportId: report.id!,
          status: 'returned',
          userId: 'impostor_user',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
