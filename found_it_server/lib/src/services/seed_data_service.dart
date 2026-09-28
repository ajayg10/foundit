import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'verification_service.dart';

/// Seeds realistic demo data for the Serverpod hackathon presentation.
class SeedDataService {
  static Future<void> seedDemoData(Session session) async {
    // Check if demo data already seeded
    final existingUsers = await AppUser.db.find(session, limit: 1);
    if (existingUsers.isNotEmpty) {
      session.log('Database already has data. Resetting demo data...', level: LogLevel.info);
      // Clean up previous demo rows
      await AppNotification.db.deleteWhere(session, where: (t) => t.id.notEquals(-1));
      await ItemMatch.db.deleteWhere(session, where: (t) => t.id.notEquals(-1));
      await Verification.db.deleteWhere(session, where: (t) => t.id.notEquals(-1));
      await ItemReport.db.deleteWhere(session, where: (t) => t.id.notEquals(-1));
      await AppUser.db.deleteWhere(session, where: (t) => t.id.notEquals(-1));
    }

    final now = DateTime.now();

    // 1. Seed Demo Users
    final userAlice = AppUser(
      userId: 'user_alice_demo',
      name: 'Alice Johnson',
      email: 'alice@campus.edu',
      phoneNumber: '+1 555-0101',
      createdAt: now.subtract(const Duration(days: 3)),
    );
    await AppUser.db.insertRow(session, userAlice);

    final userBob = AppUser(
      userId: 'user_bob_demo',
      name: 'Bob Martinez',
      email: 'bob@campus.edu',
      phoneNumber: '+1 555-0102',
      createdAt: now.subtract(const Duration(days: 2)),
    );
    await AppUser.db.insertRow(session, userBob);

    final userCharlie = AppUser(
      userId: 'user_charlie_demo',
      name: 'Charlie Davis',
      email: 'charlie@office.com',
      phoneNumber: '+1 555-0103',
      createdAt: now.subtract(const Duration(days: 1)),
    );
    await AppUser.db.insertRow(session, userCharlie);

    // 2. Report A: Alice's Lost Backpack (the primary hackathon demo anchor)
    // Library coordinates: 37.7749, -122.4194
    final lostBackpack = ItemReport(
      userId: userAlice.userId,
      userName: userAlice.name,
      userEmail: userAlice.email,
      reportType: 'lost',
      title: 'Black Wildcraft Backpack',
      description:
          'Black Wildcraft backpack with a laptop compartment, water bottle side mesh, and a small red keychain attached to the front zipper.',
      category: 'Bags',
      latitude: 37.7749,
      longitude: -122.4194,
      locationLabel: 'Campus Library, 2nd Floor',
      eventTime: now.subtract(const Duration(hours: 3)),
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80',
      status: 'open',
      createdAt: now.subtract(const Duration(hours: 3)),
      updatedAt: now.subtract(const Duration(hours: 3)),
    );
    final savedLostBackpack = await ItemReport.db.insertRow(session, lostBackpack);

    // 3. Additional Public Found Items for the Board
    // AirPods Pro at Cafeteria
    final foundAirPods = ItemReport(
      userId: userCharlie.userId,
      userName: userCharlie.name,
      userEmail: userCharlie.email,
      reportType: 'found',
      title: 'AirPods Pro with White Case',
      description:
          'Found wireless earbuds in charging case on the table near the salad bar. Has a distinctive sticker.',
      category: 'Electronics',
      latitude: 37.7760,
      longitude: -122.4180,
      locationLabel: 'Student Union Cafeteria',
      eventTime: now.subtract(const Duration(hours: 6)),
      imageUrl: 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600&auto=format&fit=crop&q=80',
      status: 'open',
      createdAt: now.subtract(const Duration(hours: 6)),
      updatedAt: now.subtract(const Duration(hours: 6)),
    );
    final savedAirPods = await ItemReport.db.insertRow(session, foundAirPods);

    final airPodsVerification = Verification(
      reportId: savedAirPods.id!,
      question: 'What cartoon sticker is on the back of the case?',
      answerHash: VerificationService.hashAnswer('pikachu'),
      attemptCount: 0,
      maxAttempts: 5,
      isVerified: false,
      createdAt: now.subtract(const Duration(hours: 6)),
    );
    await Verification.db.insertRow(session, airPodsVerification);

    // Silver Keyring with Car Key
    final foundKeys = ItemReport(
      userId: userCharlie.userId,
      userName: userCharlie.name,
      userEmail: userCharlie.email,
      reportType: 'found',
      title: 'Set of Keys with Honda Fob',
      description: 'Found a bunch of 4 keys including a Honda remote key fob on the pathway.',
      category: 'Keys',
      latitude: 37.7735,
      longitude: -122.4210,
      locationLabel: 'Parking Structure B, North Exit',
      eventTime: now.subtract(const Duration(hours: 18)),
      imageUrl: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600&auto=format&fit=crop&q=80',
      status: 'open',
      createdAt: now.subtract(const Duration(hours: 18)),
      updatedAt: now.subtract(const Duration(hours: 18)),
    );
    final savedKeys = await ItemReport.db.insertRow(session, foundKeys);

    final keysVerification = Verification(
      reportId: savedKeys.id!,
      question: 'What color is the lanyard attached to the keys?',
      answerHash: VerificationService.hashAnswer('blue'),
      attemptCount: 0,
      maxAttempts: 5,
      isVerified: false,
      createdAt: now.subtract(const Duration(hours: 18)),
    );
    await Verification.db.insertRow(session, keysVerification);

    // Leather Wallet
    final foundWallet = ItemReport(
      userId: userBob.userId,
      userName: userBob.name,
      userEmail: userBob.email,
      reportType: 'found',
      title: 'Brown Leather Bi-fold Wallet',
      description: 'Brown leather wallet found under bench. Cash and cards intact.',
      category: 'Wallets & Purses',
      latitude: 37.7755,
      longitude: -122.4205,
      locationLabel: 'Central Courtyard Fountain',
      eventTime: now.subtract(const Duration(days: 1, hours: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop&q=80',
      status: 'open',
      createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
    );
    final savedWallet = await ItemReport.db.insertRow(session, foundWallet);

    final walletVerification = Verification(
      reportId: savedWallet.id!,
      question: 'What initials are embossed on the inside corner?',
      answerHash: VerificationService.hashAnswer('mk'),
      attemptCount: 0,
      maxAttempts: 5,
      isVerified: false,
      createdAt: now.subtract(const Duration(days: 1, hours: 2)),
    );
    await Verification.db.insertRow(session, walletVerification);

    session.log(
      'Demo seed data created: 3 users, 1 demo lost backpack (ID: ${savedLostBackpack.id}), 3 public found items.',
      level: LogLevel.info,
    );
  }
}
