import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/seed_data_service.dart';

/// Endpoint providing platform-level analytics and demo seeding.
class DashboardEndpoint extends Endpoint {
  /// Fetches platform statistics for the home screen and metrics counter.
  Future<DashboardStats> getStats(Session session) async {
    final lostCount = await ItemReport.db.count(
      session,
      where: (t) => t.reportType.equals('lost'),
    );

    final foundCount = await ItemReport.db.count(
      session,
      where: (t) => t.reportType.equals('found'),
    );

    final matchedCount = await ItemMatch.db.count(session);

    final returnedCount = await ItemReport.db.count(
      session,
      where: (t) => t.status.equals('returned'),
    );

    return DashboardStats(
      totalLost: lostCount,
      totalFound: foundCount,
      totalMatched: matchedCount,
      totalReturned: returnedCount,
    );
  }

  /// One-click reset and initialization of realistic hackathon demo data.
  Future<bool> seedDemoData(Session session) async {
    await SeedDataService.seedDemoData(session);
    return true;
  }
}
