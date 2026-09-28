import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint providing real-time notification streaming and query management.
class NotificationEndpoint extends Endpoint {
  /// Fetches recent notifications for a user.
  Future<List<AppNotification>> getUserNotifications(
    Session session,
    String userId,
  ) async {
    return await AppNotification.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt.desc(),
      limit: 50,
    );
  }

  /// Marks a notification as read.
  Future<bool> markAsRead(
    Session session,
    int notificationId,
  ) async {
    final notification = await AppNotification.db.findById(session, notificationId);
    if (notification != null) {
      notification.isRead = true;
      await AppNotification.db.updateRow(session, notification);
      return true;
    }
    return false;
  }

  /// Marks all notifications for a user as read.
  Future<bool> markAllAsRead(
    Session session,
    String userId,
  ) async {
    final notifications = await AppNotification.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isRead.equals(false),
    );
    for (final n in notifications) {
      n.isRead = true;
      await AppNotification.db.updateRow(session, n);
    }
    return true;
  }

  /// Idiomatic Serverpod 4 real-time streaming method.
  /// Clients subscribe to this stream to receive instant live alerts.
  Stream<AppNotification> watchNotifications(
    Session session,
    String userId,
  ) async* {
    final stream = session.messages.createStream<AppNotification>(
      'user_notifications_$userId',
    );
    await for (final notification in stream) {
      yield notification;
    }
  }
}
