import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/notification_service.dart';
import '../services/verification_service.dart';

/// Endpoint managing verification challenges and final item returns.
class VerificationEndpoint extends Endpoint {
  /// Fetches ONLY the public question for verification.
  /// IMPORTANT: The expected answer is NEVER sent to the client.
  Future<String?> getVerificationQuestion(
    Session session,
    int reportId,
  ) async {
    final verification = await Verification.db.findFirstRow(
      session,
      where: (t) => t.reportId.equals(reportId),
    );
    return verification?.question;
  }

  /// Submits an answer attempt for server-side verification.
  Future<VerificationAttemptResult> submitVerificationAnswer(
    Session session, {
    required int reportId,
    required String claimantUserId,
    required String answer,
  }) async {
    final result = await VerificationService.verifyClaimantAnswer(
      session: session,
      reportId: reportId,
      claimantUserId: claimantUserId,
      submittedAnswer: answer,
    );

    final report = await ItemReport.db.findById(session, reportId);

    if (result.success && report != null) {
      // Notify finder of successful verification
      await NotificationService.sendNotification(
        session: session,
        userId: report.userId,
        type: 'verificationSuccess',
        title: '✅ Item Claim Verified!',
        body:
            'A claimant successfully answered your verification question for "${report.title}". You can now proceed with the handover.',
        relatedReportId: report.id,
      );

      // Notify claimant
      await NotificationService.sendNotification(
        session: session,
        userId: claimantUserId,
        type: 'verificationSuccess',
        title: '✅ Verification Successful!',
        body:
            'Your answer for "${report.title}" was verified. Please arrange safe handover with the finder.',
        relatedReportId: report.id,
      );
    } else if (report != null && !result.success) {
      // Notify claimant of failed attempt
      await NotificationService.sendNotification(
        session: session,
        userId: claimantUserId,
        type: 'verificationFailed',
        title: '❌ Verification Failed',
        body: result.message,
        relatedReportId: report.id,
      );
    }

    return result;
  }

  /// Marks an item as handed over / returned, completing the full lifecycle.
  Future<bool> markItemReturned(
    Session session, {
    required int reportId,
    required String userId,
  }) async {
    final report = await ItemReport.db.findById(session, reportId);
    if (report == null) return false;

    final now = DateTime.now();
    report.status = 'returned';
    report.updatedAt = now;
    await ItemReport.db.updateRow(session, report);

    // Also update any related match
    final match = await ItemMatch.db.findFirstRow(
      session,
      where: (t) =>
          t.foundReportId.equals(reportId) | t.lostReportId.equals(reportId),
    );

    if (match != null) {
      match.status = 'verified';
      await ItemMatch.db.updateRow(session, match);

      final otherReportId = match.foundReportId == reportId
          ? match.lostReportId
          : match.foundReportId;
      final otherReport = await ItemReport.db.findById(session, otherReportId);
      if (otherReport != null) {
        otherReport.status = 'returned';
        otherReport.updatedAt = now;
        await ItemReport.db.updateRow(session, otherReport);

        await NotificationService.sendNotification(
          session: session,
          userId: otherReport.userId,
          type: 'itemReturned',
          title: '🎉 Item Returned & Case Closed!',
          body:
              'Your report for "${otherReport.title}" has been successfully returned and closed.',
          relatedMatchId: match.id,
          relatedReportId: otherReport.id,
        );
      }
    }

    await NotificationService.sendNotification(
      session: session,
      userId: report.userId,
      type: 'itemReturned',
      title: '🎉 Item Returned & Case Closed!',
      body: 'Your report for "${report.title}" has been marked as returned.',
      relatedReportId: report.id,
    );

    return true;
  }
}
