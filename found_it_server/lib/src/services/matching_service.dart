import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'distance_service.dart';
import 'notification_service.dart';
import 'similarity_service.dart';
import 'time_service.dart';

/// The core intelligence engine of Found It.
/// Evaluates candidate opposite reports, calculates transparent multi-signal match scores,
/// generates human-readable explanations, and dispatches real-time alerts.
class MatchingService {
  static final SimilarityService _similarityService = SimilarityService();

  /// Minimum confidence required to record a potential match (40%).
  static const double matchConfidenceThreshold = 0.40;

  /// Evaluates and processes all potential matches for a freshly created or updated report.
  static Future<List<ItemMatch>> findAndProcessMatches({
    required Session session,
    required ItemReport report,
  }) async {
    final reportId = report.id;
    if (reportId == null) return [];

    final isLost = report.reportType.toLowerCase() == 'lost';
    final oppositeType = isLost ? 'found' : 'lost';

    // 1. Fetch eligible opposite candidates
    final candidates = await ItemReport.db.find(
      session,
      where: (t) =>
          t.reportType.equals(oppositeType) &
          (t.status.equals('open') |
              t.status.equals('matched') |
              t.status.equals('claimPending')),
    );

    // Prefer same-location candidates first
    candidates.sort((a, b) {
      final aSameLoc =
          (report.locationId != null && a.locationId == report.locationId)
          ? 1
          : 0;
      final bSameLoc =
          (report.locationId != null && b.locationId == report.locationId)
          ? 1
          : 0;
      return bSameLoc.compareTo(aSameLoc);
    });

    final generatedMatches = <ItemMatch>[];

    for (final candidate in candidates) {
      final candidateId = candidate.id;
      if (candidateId == null) continue;

      // Avoid matching items from the same user
      if (candidate.userId == report.userId) continue;

      final lostReport = isLost ? report : candidate;
      final foundReport = isLost ? candidate : report;

      // Check if match already exists
      final existingMatch = await ItemMatch.db.findFirstRow(
        session,
        where: (t) =>
            t.lostReportId.equals(lostReport.id!) &
            t.foundReportId.equals(foundReport.id!),
      );

      final evaluation = evaluateMatch(
        lostReport: lostReport,
        foundReport: foundReport,
      );

      if (evaluation.confidenceScore >= matchConfidenceThreshold) {
        if (existingMatch != null) {
          // Update existing match score & explanation
          existingMatch.confidenceScore = evaluation.confidenceScore;
          existingMatch.textScore = evaluation.textScore;
          existingMatch.distanceScore = evaluation.distanceScore;
          existingMatch.timeScore = evaluation.timeScore;
          existingMatch.categoryScore = evaluation.categoryScore;
          existingMatch.explanation = evaluation.explanation;
          existingMatch.distanceKm = evaluation.distanceKm;
          existingMatch.timeDiffHours = evaluation.timeDiffHours;
          await ItemMatch.db.updateRow(session, existingMatch);
          generatedMatches.add(existingMatch);
        } else {
          // Create new match record
          final newMatch = ItemMatch(
            lostReportId: lostReport.id!,
            foundReportId: foundReport.id!,
            confidenceScore: evaluation.confidenceScore,
            textScore: evaluation.textScore,
            locationScore: evaluation.locationScore,
            distanceScore: evaluation.distanceScore,
            timeScore: evaluation.timeScore,
            categoryScore: evaluation.categoryScore,
            explanation: evaluation.explanation,
            distanceKm: evaluation.distanceKm,
            timeDiffHours: evaluation.timeDiffHours,
            status: 'potential',
            createdAt: DateTime.now(),
          );

          final savedMatch = await ItemMatch.db.insertRow(session, newMatch);
          generatedMatches.add(savedMatch);

          // Update report statuses to 'matched' if currently 'open'
          if (lostReport.status == 'open') {
            lostReport.status = 'matched';
            lostReport.updatedAt = DateTime.now();
            await ItemReport.db.updateRow(session, lostReport);
          }
          if (foundReport.status == 'open') {
            foundReport.status = 'matched';
            foundReport.updatedAt = DateTime.now();
            await ItemReport.db.updateRow(session, foundReport);
          }

          // Real-time notifications for both users
          final percent = (evaluation.confidenceScore * 100).round();

          // Notification to owner of lost item
          await NotificationService.sendNotification(
            session: session,
            userId: lostReport.userId,
            type: 'matchFound',
            title: '🔔 Possible Match Found ($percent% Confidence)',
            body:
                'We found a matching item for "${lostReport.title}" (${foundReport.title} at ${foundReport.locationLabel}).',
            relatedMatchId: savedMatch.id,
            relatedReportId: lostReport.id,
          );

          // Notification to finder
          await NotificationService.sendNotification(
            session: session,
            userId: foundReport.userId,
            type: 'matchFound',
            title: '🔔 Someone May Have Lost Your Found Item! ($percent%)',
            body:
                'A report matching your found "${foundReport.title}" was submitted: "${lostReport.title}".',
            relatedMatchId: savedMatch.id,
            relatedReportId: foundReport.id,
          );
        }
      }
    }

    return generatedMatches;
  }

  /// Calculates the multi-signal match score and produces transparent explanations.
  static MatchEvaluationResult evaluateMatch({
    required ItemReport lostReport,
    required ItemReport foundReport,
  }) {
    // 1. Category similarity (Weight: 15%)
    final isCategoryMatch =
        lostReport.category.trim().toLowerCase() ==
        foundReport.category.trim().toLowerCase();
    final categoryScore = isCategoryMatch ? 1.0 : 0.0;

    // 2. Text similarity (Weight: 35%)
    final textScore = _similarityService.calculateTextSimilarity(
      title1: lostReport.title,
      description1: lostReport.description,
      title2: foundReport.title,
      description2: foundReport.description,
    );

    // 3. Location entity similarity (Weight: 10%)
    double locationScore = 0.0;
    if (lostReport.locationId != null && foundReport.locationId != null) {
      if (lostReport.locationId == foundReport.locationId) {
        locationScore = 1.0;
      } else {
        locationScore = 0.0;
      }
    } else {
      // If locationId not set, infer based on geographic distance
      final inferredDist = DistanceService.calculateDistanceKm(
        lat1: lostReport.latitude,
        lon1: lostReport.longitude,
        lat2: foundReport.latitude,
        lon2: foundReport.longitude,
      );
      locationScore = inferredDist <= 0.5 ? 0.8 : 0.0;
    }

    // 4. Geographic distance (Weight: 20%)
    final distanceKm = DistanceService.calculateDistanceKm(
      lat1: lostReport.latitude,
      lon1: lostReport.longitude,
      lat2: foundReport.latitude,
      lon2: foundReport.longitude,
    );
    final distanceScore = DistanceService.calculateDistanceScore(distanceKm);

    // 5. Temporal similarity (Weight: 20%)
    final timeDiffHours = TimeService.calculateDifferenceHours(
      lostReport.eventTime,
      foundReport.eventTime,
    );
    final timeScore = TimeService.calculateTimeScore(timeDiffHours);

    // Overall weighted confidence score (0.0 to 1.0)
    final overallConfidence =
        (textScore * 0.35) +
        (locationScore * 0.10) +
        (distanceScore * 0.20) +
        (timeScore * 0.20) +
        (categoryScore * 0.15);

    // Generate explainable details
    final explanationJson = generateExplanation(
      lostReport: lostReport,
      foundReport: foundReport,
      confidenceScore: overallConfidence,
      textScore: textScore,
      locationScore: locationScore,
      distanceKm: distanceKm,
      timeDiffHours: timeDiffHours,
      isCategoryMatch: isCategoryMatch,
    );

    return MatchEvaluationResult(
      confidenceScore: double.parse(overallConfidence.toStringAsFixed(3)),
      textScore: double.parse(textScore.toStringAsFixed(3)),
      locationScore: double.parse(locationScore.toStringAsFixed(3)),
      distanceScore: double.parse(distanceScore.toStringAsFixed(3)),
      timeScore: double.parse(timeScore.toStringAsFixed(3)),
      categoryScore: double.parse(categoryScore.toStringAsFixed(3)),
      explanation: explanationJson,
      distanceKm: double.parse(distanceKm.toStringAsFixed(2)),
      timeDiffHours: double.parse(timeDiffHours.toStringAsFixed(1)),
    );
  }

  /// Produces clear human-readable explanation bullets based on actual matching signals.
  static String generateExplanation({
    required ItemReport lostReport,
    required ItemReport foundReport,
    required double confidenceScore,
    required double textScore,
    required double locationScore,
    required double distanceKm,
    required double timeDiffHours,
    required bool isCategoryMatch,
  }) {
    final sharedWords = SimilarityService.extractSharedKeywords(
      '${lostReport.title} ${lostReport.description}',
      '${foundReport.title} ${foundReport.description}',
    );

    String textSummary;
    if (sharedWords.isNotEmpty) {
      final sample = sharedWords.take(3).join(', ');
      textSummary = 'Both mention key terms: "$sample"';
    } else if (textScore > 0.6) {
      textSummary = 'Very strong semantic phrasing and item details match';
    } else {
      textSummary = 'Moderately similar item characteristics';
    }

    String locationSummary;
    if (lostReport.locationId != null &&
        foundReport.locationId != null &&
        lostReport.locationId == foundReport.locationId) {
      if (lostReport.locationAreaId != null &&
          foundReport.locationAreaId != null &&
          lostReport.locationAreaId == foundReport.locationAreaId) {
        locationSummary =
            'Both reported in the same location and area (${lostReport.locationLabel})';
      } else {
        locationSummary =
            'Both reported at the same primary location (${lostReport.locationLabel})';
      }
    } else if (locationScore >= 0.7) {
      locationSummary = 'Reported within the same campus or facility zone';
    } else {
      locationSummary =
          'Different locations (${lostReport.locationLabel} vs ${foundReport.locationLabel})';
    }

    String distSummary;
    if (distanceKm < 0.1) {
      distSummary = 'Same exact spot (less than 100 meters apart)';
    } else if (distanceKm < 1.0) {
      distSummary =
          'Reports are ${(distanceKm * 1000).round()}m apart between ${lostReport.locationLabel} and ${foundReport.locationLabel}';
    } else {
      distSummary =
          'Reports are ${distanceKm.toStringAsFixed(1)} km apart (${lostReport.locationLabel} to ${foundReport.locationLabel})';
    }

    String timeSummary;
    if (timeDiffHours < 1.0) {
      timeSummary =
          'Within ${(timeDiffHours * 60).round()} minutes of each other';
    } else if (timeDiffHours < 24.0) {
      timeSummary =
          'Reports are ${timeDiffHours.toStringAsFixed(1)} hours apart';
    } else {
      final days = (timeDiffHours / 24.0).toStringAsFixed(1);
      timeSummary = 'Reports are ~$days days apart';
    }

    final categorySummary = isCategoryMatch
        ? 'Both are categorized as "${lostReport.category}"'
        : 'Different categories ("${lostReport.category}" vs "${foundReport.category}")';

    final percent = (confidenceScore * 100).round();
    final verdict = confidenceScore >= 0.85
        ? 'High probability of being the same item'
        : (confidenceScore >= 0.65
              ? 'Strong potential match with shared signals'
              : 'Moderate similarity warranting review');

    final map = {
      'percent': percent,
      'textSummary': textSummary,
      'locationSummary': locationSummary,
      'distanceSummary': distSummary,
      'timeSummary': timeSummary,
      'categorySummary': categorySummary,
      'verdict': verdict,
    };

    return jsonEncode(map);
  }
}

/// Helper container for match evaluation computations.
class MatchEvaluationResult {
  final double confidenceScore;
  final double textScore;
  final double locationScore;
  final double distanceScore;
  final double timeScore;
  final double categoryScore;
  final String explanation;
  final double distanceKm;
  final double timeDiffHours;

  MatchEvaluationResult({
    required this.confidenceScore,
    required this.textScore,
    required this.locationScore,
    required this.distanceScore,
    required this.timeScore,
    required this.categoryScore,
    required this.explanation,
    required this.distanceKm,
    required this.timeDiffHours,
  });
}
