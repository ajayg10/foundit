import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing user profiles and sessions.
class UserEndpoint extends Endpoint {
  /// Fetches an existing user or creates a new profile.
  Future<AppUser> getOrCreateUser(
    Session session, {
    required String userId,
    required String name,
    required String email,
    String? phone,
  }) async {
    final existing = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) | t.email.equals(email),
    );

    if (existing != null) {
      existing.name = name;
      if (phone != null) existing.phoneNumber = phone;
      return await AppUser.db.updateRow(session, existing);
    }

    final newUser = AppUser(
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phone,
      createdAt: DateTime.now(),
    );

    return await AppUser.db.insertRow(session, newUser);
  }

  /// Gets a user by unique ID.
  Future<AppUser?> getUser(Session session, String userId) async {
    return await AppUser.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }
}
