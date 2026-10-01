import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service responsible for secure question/answer verification and brute-force protection.
class VerificationService {
  static const String _hashSalt = 'found_it_verification_salt_2026';

  /// Hashes a normalized expected answer.
  static String hashAnswer(String answer) {
    final normalized = answer.trim().toLowerCase();
    final bytes = utf8.encode('$_hashSalt::$normalized');
    return sha256.convert(bytes).toString();
  }

  /// Verifies a claimant's submitted answer against the stored hash.
  /// Enforces attempt limits and updates report status on success.
  static Future<VerificationAttemptResult> verifyClaimantAnswer({
    required Session session,
    required int reportId,
    required String claimantUserId,
    required String submittedAnswer,
  }) async {
    // 1. Fetch verification record for the found item
    final verification = await Verification.db.findFirstRow(
      session,
      where: (t) => t.reportId.equals(reportId),
    );

    if (verification == null) {
      return VerificationAttemptResult(
        success: false,
        message: 'No verification question found for this report.',
        attemptsRemaining: 0,
        isLocked: true,
      );
    }

    if (verification.isVerified) {
      return VerificationAttemptResult(
        success: true,
        message: 'This item has already been successfully verified!',
        attemptsRemaining: 0,
        isLocked: false,
      );
    }

    // 2. Check if attempts exceeded
    if (verification.attemptCount >= verification.maxAttempts) {
      return VerificationAttemptResult(
        success: false,
        message:
            'Verification locked: maximum attempts (${verification.maxAttempts}) exceeded. Please contact the campus/office administration.',
        attemptsRemaining: 0,
        isLocked: true,
      );
    }

    // 3. Compare hashes
    final submittedHash = hashAnswer(submittedAnswer);
    final isMatch = submittedHash == verification.answerHash;

    if (isMatch) {
      // Mark verified
      verification.isVerified = true;
      verification.verifiedByUserId = claimantUserId;
      verification.verifiedAt = DateTime.now();
      await Verification.db.updateRow(session, verification);

      // Update both reports if matched
      final foundReport = await ItemReport.db.findById(session, reportId);
      if (foundReport != null) {
        foundReport.status = 'verified';
        foundReport.updatedAt = DateTime.now();
        await ItemReport.db.updateRow(session, foundReport);
      }

      // Check for related match
      final match = await ItemMatch.db.findFirstRow(
        session,
        where: (t) => t.foundReportId.equals(reportId),
      );
      if (match != null) {
        match.status = 'verified';
        await ItemMatch.db.updateRow(session, match);

        final lostReport = await ItemReport.db.findById(
          session,
          match.lostReportId,
        );
        if (lostReport != null) {
          lostReport.status = 'verified';
          lostReport.updatedAt = DateTime.now();
          await ItemReport.db.updateRow(session, lostReport);
        }
      }

      return VerificationAttemptResult(
        success: true,
        message: 'Verification successful! You can now arrange the handover.',
        attemptsRemaining: verification.maxAttempts - verification.attemptCount,
        isLocked: false,
      );
    } else {
      // Increment attempt counter
      verification.attemptCount += 1;
      await Verification.db.updateRow(session, verification);

      final remaining = verification.maxAttempts - verification.attemptCount;
      final isLocked = remaining <= 0;

      return VerificationAttemptResult(
        success: false,
        message: isLocked
            ? 'Verification locked: maximum attempts exceeded.'
            : 'Incorrect answer. $remaining attempt${remaining == 1 ? '' : 's'} remaining.',
        attemptsRemaining: remaining,
        isLocked: isLocked,
      );
    }
  }
}
