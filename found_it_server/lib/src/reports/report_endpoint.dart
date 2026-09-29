import 'dart:convert';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/matching_service.dart';
import '../services/verification_service.dart';

/// Endpoint handling Lost & Found item reporting, browsing, and image uploads.
class ReportEndpoint extends Endpoint {
  /// Creates a lost or found report, stores optional verification questions,
  /// and automatically triggers Serverpod matching engine.
  Future<ItemReport> createReport(
    Session session, {
    required ItemReport report,
    String? verificationQuestion,
    String? verificationAnswer,
  }) async {
    final now = DateTime.now();
    final toInsert = report.copyWith(
      createdAt: now,
      updatedAt: now,
      status: 'open',
    );

    final inserted = await ItemReport.db.insertRow(session, toInsert);

    // If it's a found report and includes a verification question & answer, securely store it
    if (inserted.reportType.toLowerCase() == 'found' &&
        verificationQuestion != null &&
        verificationQuestion.trim().isNotEmpty &&
        verificationAnswer != null &&
        verificationAnswer.trim().isNotEmpty) {
      final verification = Verification(
        reportId: inserted.id!,
        question: verificationQuestion.trim(),
        answerHash: VerificationService.hashAnswer(verificationAnswer),
        attemptCount: 0,
        maxAttempts: 5,
        isVerified: false,
        createdAt: now,
      );
      await Verification.db.insertRow(session, verification);
    }

    // Trigger Serverpod matching engine automatically!
    try {
      await MatchingService.findAndProcessMatches(
        session: session,
        report: inserted,
      );
    } catch (e, stack) {
      session.log('Matching engine error: $e\n$stack', level: LogLevel.error);
    }

    // Refresh and return report
    final refreshed = await ItemReport.db.findById(session, inserted.id!);
    return refreshed ?? inserted;
  }

  /// Fetches a single report by ID.
  Future<ItemReport?> getReport(Session session, int reportId) async {
    return await ItemReport.db.findById(session, reportId);
  }

  /// Lists reports with optional filters for the public board and exploration.
  Future<List<ItemReport>> listReports(
    Session session, {
    int? locationId,
    String? reportType,
    String? category,
    String? status,
    String? searchQuery,
    int limit = 50,
  }) async {
    final reports = await ItemReport.db.find(
      session,
      limit: limit,
      orderBy: (t) => t.createdAt.desc(),
      where: (t) {
        Expression filter = Constant.bool(true);

        if (locationId != null) {
          filter = filter & t.locationId.equals(locationId);
        }

        if (reportType != null && reportType.isNotEmpty) {
          filter = filter & t.reportType.equals(reportType);
        }

        if (category != null && category.isNotEmpty && category != 'All') {
          filter = filter & t.category.equals(category);
        }

        if (status != null && status.isNotEmpty) {
          filter = filter & t.status.equals(status);
        } else {
          // By default on public board, exclude returned items
          filter = filter & t.status.notEquals('returned');
        }

        return filter;
      },
    );

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      return reports.where((r) {
        return r.title.toLowerCase().contains(q) ||
            r.description.toLowerCase().contains(q) ||
            r.locationLabel.toLowerCase().contains(q) ||
            r.category.toLowerCase().contains(q);
      }).toList();
    }

    return reports;
  }

  /// Fetches all reports submitted by a specific user.
  Future<List<ItemReport>> listUserReports(
    Session session,
    String userId,
  ) async {
    return await ItemReport.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  /// Updates report status with authorization check.
  Future<ItemReport> updateReportStatus(
    Session session, {
    required int reportId,
    required String status,
    required String userId,
  }) async {
    final report = await ItemReport.db.findById(session, reportId);
    if (report == null) {
      throw StateError('Report not found');
    }

    if (report.userId != userId) {
      throw StateError('Unauthorized: You can only edit your own reports.');
    }

    report.status = status;
    report.updatedAt = DateTime.now();
    return await ItemReport.db.updateRow(session, report);
  }

  /// Direct photo upload handler using Serverpod database storage.
  /// Converts base64 bytes and stores in Serverpod cloud storage.
  Future<String> uploadPhoto(
    Session session, {
    required String filename,
    required String base64Data,
  }) async {
    try {
      final bytes = base64Decode(base64Data);
      final byteData = ByteData.sublistView(Uint8List.fromList(bytes));
      final cleanName = filename.replaceAll(RegExp(r'[^a-zA-Z0-9_\.-]'), '_');
      final uniquePath = 'uploads/${DateTime.now().millisecondsSinceEpoch}_$cleanName';

      await session.storage.storeFile(
        storageId: 'public',
        path: uniquePath,
        byteData: byteData,
      );

      final publicUrl = await session.storage.publicDownloadUrl(
        storageId: 'public',
        path: uniquePath,
      );

      return publicUrl.toString();
    } catch (e) {
      session.log('Photo upload error: $e, falling back to data URL', level: LogLevel.warning);
      return 'data:image/jpeg;base64,$base64Data';
    }
  }
}
