/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class AppNotification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppNotification._({
    this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.relatedMatchId,
    this.relatedReportId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification({
    int? id,
    required String userId,
    required String type,
    required String title,
    required String body,
    int? relatedMatchId,
    int? relatedReportId,
    required bool isRead,
    required DateTime createdAt,
  }) = _AppNotificationImpl;

  factory AppNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppNotification(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      type: jsonSerialization['type'] as String,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      relatedMatchId: jsonSerialization['relatedMatchId'] as int?,
      relatedReportId: jsonSerialization['relatedReportId'] as int?,
      isRead: _isc.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  String type;

  String title;

  String body;

  int? relatedMatchId;

  int? relatedReportId;

  bool isRead;

  DateTime createdAt;

  /// Returns a shallow copy of this [AppNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppNotification copyWith({
    int? id,
    String? userId,
    String? type,
    String? title,
    String? body,
    int? relatedMatchId,
    int? relatedReportId,
    bool? isRead,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppNotification',
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      if (relatedMatchId != null) 'relatedMatchId': relatedMatchId,
      if (relatedReportId != null) 'relatedReportId': relatedReportId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppNotification',
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      if (relatedMatchId != null) 'relatedMatchId': relatedMatchId,
      if (relatedReportId != null) 'relatedReportId': relatedReportId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppNotificationImpl extends AppNotification {
  _AppNotificationImpl({
    int? id,
    required String userId,
    required String type,
    required String title,
    required String body,
    int? relatedMatchId,
    int? relatedReportId,
    required bool isRead,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         type: type,
         title: title,
         body: body,
         relatedMatchId: relatedMatchId,
         relatedReportId: relatedReportId,
         isRead: isRead,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AppNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppNotification copyWith({
    Object? id = _Undefined,
    String? userId,
    String? type,
    String? title,
    String? body,
    Object? relatedMatchId = _Undefined,
    Object? relatedReportId = _Undefined,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      relatedMatchId: relatedMatchId is int?
          ? relatedMatchId
          : this.relatedMatchId,
      relatedReportId: relatedReportId is int?
          ? relatedReportId
          : this.relatedReportId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
