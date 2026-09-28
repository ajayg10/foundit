import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/matching_service.dart';

/// Endpoint for querying matches, explanations, and triggering match recalculations.
class MatchEndpoint extends Endpoint {
  /// Fetches all matches for a specific report, populated with full report details.
  Future<List<MatchDetailsDto>> getMatchesForReport(
    Session session,
    int reportId,
  ) async {
    final matches = await ItemMatch.db.find(
      session,
      where: (t) => t.lostReportId.equals(reportId) | t.foundReportId.equals(reportId),
      orderBy: (t) => t.confidenceScore.desc(),
    );

    final results = <MatchDetailsDto>[];
    for (final match in matches) {
      final lostReport = await ItemReport.db.findById(session, match.lostReportId);
      final foundReport = await ItemReport.db.findById(session, match.foundReportId);

      if (lostReport != null && foundReport != null) {
        final verification = await Verification.db.findFirstRow(
          session,
          where: (t) => t.reportId.equals(foundReport.id!),
        );

        results.add(
          MatchDetailsDto(
            match: match,
            lostReport: lostReport,
            foundReport: foundReport,
            verificationQuestion: verification?.question,
            isClaimPending: foundReport.status == 'claimPending',
            isVerified: verification?.isVerified ?? false,
          ),
        );
      }
    }

    return results;
  }

  /// Fetches all matches involving any reports created by a user.
  Future<List<MatchDetailsDto>> getUserMatches(
    Session session,
    String userId,
  ) async {
    // 1. Get user reports
    final userReports = await ItemReport.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (userReports.isEmpty) return [];

    final reportIds = userReports.map((r) => r.id!).toSet();

    // 2. Fetch matches matching any of these report IDs
    final allMatches = await ItemMatch.db.find(
      session,
      orderBy: (t) => t.confidenceScore.desc(),
    );

    final relevantMatches = allMatches.where((m) {
      return reportIds.contains(m.lostReportId) || reportIds.contains(m.foundReportId);
    }).toList();

    final results = <MatchDetailsDto>[];
    for (final match in relevantMatches) {
      final lostReport = await ItemReport.db.findById(session, match.lostReportId);
      final foundReport = await ItemReport.db.findById(session, match.foundReportId);

      if (lostReport != null && foundReport != null) {
        final verification = await Verification.db.findFirstRow(
          session,
          where: (t) => t.reportId.equals(foundReport.id!),
        );

        results.add(
          MatchDetailsDto(
            match: match,
            lostReport: lostReport,
            foundReport: foundReport,
            verificationQuestion: verification?.question,
            isClaimPending: foundReport.status == 'claimPending',
            isVerified: verification?.isVerified ?? false,
          ),
        );
      }
    }

    return results;
  }

  /// Fetches details for a single match.
  Future<MatchDetailsDto?> getMatchDetails(
    Session session,
    int matchId,
  ) async {
    final match = await ItemMatch.db.findById(session, matchId);
    if (match == null) return null;

    final lostReport = await ItemReport.db.findById(session, match.lostReportId);
    final foundReport = await ItemReport.db.findById(session, match.foundReportId);

    if (lostReport == null || foundReport == null) return null;

    final verification = await Verification.db.findFirstRow(
      session,
      where: (t) => t.reportId.equals(foundReport.id!),
    );

    return MatchDetailsDto(
      match: match,
      lostReport: lostReport,
      foundReport: foundReport,
      verificationQuestion: verification?.question,
      isClaimPending: foundReport.status == 'claimPending',
      isVerified: verification?.isVerified ?? false,
    );
  }

  /// Triggers or recalculates matches for a specific report.
  Future<List<ItemMatch>> runMatchingForReport(
    Session session,
    int reportId,
  ) async {
    final report = await ItemReport.db.findById(session, reportId);
    if (report == null) return [];

    return await MatchingService.findAndProcessMatches(
      session: session,
      report: report,
    );
  }
}
