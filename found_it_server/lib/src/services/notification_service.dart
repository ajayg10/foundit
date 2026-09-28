import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for generating notifications and streaming them in real time to users.
class NotificationService {
  /// Sends a notification to a specific user and broadcasts it on their personal real-time channel.
  static Future<AppNotification> sendNotification({
    required Session session,
    required String userId,
    required String type,
    required String title,
    required String body,
    int? relatedMatchId,
    int? relatedReportId,
  }) async {
    final notification = AppNotification(
      userId: userId,
      type: type,
      title: title,
      body: body,
      relatedMatchId: relatedMatchId,
      relatedReportId: relatedReportId,
      isRead: false,
      createdAt: DateTime.now(),
    );

    final inserted = await AppNotification.db.insertRow(session, notification);

    // Broadcast in real-time to active user streams
    try {
      await session.messages.postMessage(
        'user_notifications_$userId',
        inserted,
      );
    } catch (e) {
      session.log('Real-time postMessage error: $e', level: LogLevel.warning);
    }

    return inserted;
  }
}
