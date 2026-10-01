import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'verification_service.dart';

/// Seeds realistic demo data for the Serverpod hackathon presentation.
class SeedDataService {
  static Future<void> seedDemoData(Session session) async {
    // Check if demo data already seeded
    final existingUsers = await AppUser.db.find(session, limit: 1);
    if (existingUsers.isNotEmpty) {
      session.log(
        'Database already has data. Resetting demo data...',
        level: LogLevel.info,
      );
      // Clean up previous demo rows
      await AppNotification.db.deleteWhere(
        session,
        where: (t) => t.id.notEquals(-1),
      );
      await ItemMatch.db.deleteWhere(session, where: (t) => t.id.notEquals(-1));
      await Verification.db.deleteWhere(
        session,
        where: (t) => t.id.notEquals(-1),
      );
      await ItemReport.db.deleteWhere(
        session,
        where: (t) => t.id.notEquals(-1),
      );
      await LocationArea.db.deleteWhere(
        session,
        where: (t) => t.id.notEquals(-1),
      );
      await Location.db.deleteWhere(session, where: (t) => t.id.notEquals(-1));
      await AppUser.db.deleteWhere(session, where: (t) => t.id.notEquals(-1));
    }

    final now = DateTime.now();

    // 1. Seed Locations
    final iitDelhi = await Location.db.insertRow(
      session,
      Location(
        name: 'IIT Delhi',
        type: 'campus',
        address: 'Hauz Khas, New Delhi 110016',
        latitude: 28.5456,
        longitude: 77.1926,
        description: 'Indian Institute of Technology Delhi Main Campus',
        logoUrl:
            'https://images.unsplash.com/photo-1562774053-701939374585?w=200&auto=format&fit=crop&q=80',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
    );

    final delAirport = await Location.db.insertRow(
      session,
      Location(
        name: 'Delhi Airport (IGI T3)',
        type: 'airport',
        address: 'Terminal 3, New Delhi 110037',
        latitude: 28.5562,
        longitude: 77.1000,
        description: 'Indira Gandhi International Airport Terminal 3',
        logoUrl:
            'https://images.unsplash.com/photo-1542296332-2e4473faf563?w=200&auto=format&fit=crop&q=80',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
    );

    final msftGurgaon = await Location.db.insertRow(
      session,
      Location(
        name: 'Microsoft Cyber City',
        type: 'office',
        address: 'DLF Cyber City, Building 10, Gurugram 122002',
        latitude: 28.4986,
        longitude: 77.0878,
        description: 'Microsoft India Development Center Gurugram Campus',
        logoUrl:
            'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=200&auto=format&fit=crop&q=80',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
    );

    // 2. Seed Location Areas for IIT Delhi
    final areaLibrary = await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: iitDelhi.id!,
        name: 'Central Library',
        latitude: 28.5448,
        longitude: 77.1928,
        description: 'Reading halls, reference section, and 2nd floor stack',
        isActive: true,
      ),
    );

    final areaBharti = await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: iitDelhi.id!,
        name: 'Bharti Building (CSE / EE)',
        latitude: 28.5460,
        longitude: 77.1912,
        description: 'Computer Science labs, auditorium, and faculty offices',
        isActive: true,
      ),
    );

    final areaSac = await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: iitDelhi.id!,
        name: 'Student Activity Center (SAC)',
        latitude: 28.5435,
        longitude: 77.1930,
        description: 'Sports grounds, indoor complex, and club rooms',
        isActive: true,
      ),
    );

    await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: iitDelhi.id!,
        name: 'Nilgiri Hostel',
        latitude: 28.5475,
        longitude: 77.1895,
        description: 'Student residential block and common lounge',
        isActive: true,
      ),
    );

    final areaCanteen = await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: iitDelhi.id!,
        name: 'Main Canteen & Cafe',
        latitude: 28.5450,
        longitude: 77.1920,
        description: 'Central cafeteria and outdoor seating lawn',
        isActive: true,
      ),
    );

    // Areas for Airport
    await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: delAirport.id!,
        name: 'T3 Arrivals Hall (Gate 4)',
        latitude: 28.5560,
        longitude: 77.1002,
        description: 'Public meeting area and taxi pick-up',
        isActive: true,
      ),
    );
    await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: delAirport.id!,
        name: 'Security Check Pier B',
        latitude: 28.5565,
        longitude: 77.0998,
        description: 'Domestic departures security checkpoint',
        isActive: true,
      ),
    );

    // Areas for Microsoft
    await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: msftGurgaon.id!,
        name: 'Tower B Ground Lobby',
        latitude: 28.4985,
        longitude: 77.0877,
        description: 'Security reception and visitor badge desk',
        isActive: true,
      ),
    );
    await LocationArea.db.insertRow(
      session,
      LocationArea(
        locationId: msftGurgaon.id!,
        name: '5th Floor Dining Hub',
        latitude: 28.4988,
        longitude: 77.0880,
        description: 'Employee cafeteria and coffee bar',
        isActive: true,
      ),
    );

    // 3. Seed Demo Users
    final userAlice = AppUser(
      userId: 'user_alice_demo',
      name: 'Alice Johnson',
      email: 'alice@campus.edu',
      phoneNumber: '+91 98765 43210',
      createdAt: now.subtract(const Duration(days: 3)),
    );
    await AppUser.db.insertRow(session, userAlice);

    final userBob = AppUser(
      userId: 'user_bob_demo',
      name: 'Bob Martinez',
      email: 'bob@campus.edu',
      phoneNumber: '+91 98765 43211',
      createdAt: now.subtract(const Duration(days: 2)),
    );
    await AppUser.db.insertRow(session, userBob);

    final userCharlie = AppUser(
      userId: 'user_charlie_demo',
      name: 'Charlie Davis',
      email: 'charlie@office.com',
      phoneNumber: '+91 98765 43212',
      createdAt: now.subtract(const Duration(days: 1)),
    );
    await AppUser.db.insertRow(session, userCharlie);

    // 4. Report A: Alice's Lost Backpack (the primary hackathon demo anchor at IIT Delhi Library)
    final lostBackpack = ItemReport(
      userId: userAlice.userId,
      userName: userAlice.name,
      userEmail: userAlice.email,
      reportType: 'lost',
      title: 'Black Wildcraft Backpack',
      description:
          'Black Wildcraft backpack with a laptop compartment, water bottle side mesh, and a small red keychain attached to the front zipper.',
      category: 'Bags',
      latitude: 28.5448,
      longitude: 77.1928,
      locationLabel: 'IIT Delhi — Central Library, 2nd Floor',
      locationId: iitDelhi.id,
      locationAreaId: areaLibrary.id,
      eventTime: now.subtract(const Duration(hours: 3)),
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80',
      status: 'open',
      createdAt: now.subtract(const Duration(hours: 3)),
      updatedAt: now.subtract(const Duration(hours: 3)),
    );
    final savedLostBackpack = await ItemReport.db.insertRow(
      session,
      lostBackpack,
    );

    // 5. Additional Public Found Items for the Board at IIT Delhi
    // AirPods Pro at Main Canteen
    final foundAirPods = ItemReport(
      userId: userCharlie.userId,
      userName: userCharlie.name,
      userEmail: userCharlie.email,
      reportType: 'found',
      title: 'AirPods Pro with White Case',
      description:
          'Found wireless earbuds in charging case on the table near the juice counter. Has a distinctive sticker.',
      category: 'Electronics',
      latitude: 28.5450,
      longitude: 77.1920,
      locationLabel: 'IIT Delhi — Main Canteen',
      locationId: iitDelhi.id,
      locationAreaId: areaCanteen.id,
      eventTime: now.subtract(const Duration(hours: 6)),
      imageUrl:
          'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600&auto=format&fit=crop&q=80',
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

    // Silver Keyring with Car Key at SAC
    final foundKeys = ItemReport(
      userId: userCharlie.userId,
      userName: userCharlie.name,
      userEmail: userCharlie.email,
      reportType: 'found',
      title: 'Set of Keys with Honda Fob',
      description:
          'Found a bunch of 4 keys including a Honda remote key fob on the walkway near SAC.',
      category: 'Keys',
      latitude: 28.5435,
      longitude: 77.1930,
      locationLabel: 'IIT Delhi — SAC Complex Pathway',
      locationId: iitDelhi.id,
      locationAreaId: areaSac.id,
      eventTime: now.subtract(const Duration(hours: 18)),
      imageUrl:
          'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600&auto=format&fit=crop&q=80',
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

    // Leather Wallet at Bharti Building
    final foundWallet = ItemReport(
      userId: userBob.userId,
      userName: userBob.name,
      userEmail: userBob.email,
      reportType: 'found',
      title: 'Brown Leather Bi-fold Wallet',
      description:
          'Brown leather wallet found under bench near Bharti auditorium. Cards intact.',
      category: 'Wallets & Purses',
      latitude: 28.5460,
      longitude: 77.1912,
      locationLabel: 'IIT Delhi — Bharti Building Atrium',
      locationId: iitDelhi.id,
      locationAreaId: areaBharti.id,
      eventTime: now.subtract(const Duration(days: 1, hours: 2)),
      imageUrl:
          'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop&q=80',
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
      'Demo seed data created: 3 locations (IIT Delhi, Delhi Airport, Microsoft Gurgaon), 3 users, 1 demo lost backpack (ID: ${savedLostBackpack.id}), 3 public found items.',
      level: LogLevel.info,
    );
  }
}
