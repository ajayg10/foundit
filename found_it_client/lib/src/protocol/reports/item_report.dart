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

abstract class ItemReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ItemReport._({
    this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.reportType,
    required this.title,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.locationLabel,
    this.locationId,
    this.locationAreaId,
    required this.eventTime,
    this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemReport({
    int? id,
    required String userId,
    required String userName,
    required String userEmail,
    required String reportType,
    required String title,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    required String locationLabel,
    int? locationId,
    int? locationAreaId,
    required DateTime eventTime,
    String? imageUrl,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ItemReportImpl;

  factory ItemReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemReport(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      userName: jsonSerialization['userName'] as String,
      userEmail: jsonSerialization['userEmail'] as String,
      reportType: jsonSerialization['reportType'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      locationLabel: jsonSerialization['locationLabel'] as String,
      locationId: jsonSerialization['locationId'] as int?,
      locationAreaId: jsonSerialization['locationAreaId'] as int?,
      eventTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['eventTime'],
      ),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      status: jsonSerialization['status'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  String userName;

  String userEmail;

  String reportType;

  String title;

  String description;

  String category;

  double latitude;

  double longitude;

  String locationLabel;

  int? locationId;

  int? locationAreaId;

  DateTime eventTime;

  String? imageUrl;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ItemReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ItemReport copyWith({
    int? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? reportType,
    String? title,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    String? locationLabel,
    int? locationId,
    int? locationAreaId,
    DateTime? eventTime,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemReport',
      if (id != null) 'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'reportType': reportType,
      'title': title,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'locationLabel': locationLabel,
      if (locationId != null) 'locationId': locationId,
      if (locationAreaId != null) 'locationAreaId': locationAreaId,
      'eventTime': eventTime.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemReport',
      if (id != null) 'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'reportType': reportType,
      'title': title,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'locationLabel': locationLabel,
      if (locationId != null) 'locationId': locationId,
      if (locationAreaId != null) 'locationAreaId': locationAreaId,
      'eventTime': eventTime.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemReportImpl extends ItemReport {
  _ItemReportImpl({
    int? id,
    required String userId,
    required String userName,
    required String userEmail,
    required String reportType,
    required String title,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    required String locationLabel,
    int? locationId,
    int? locationAreaId,
    required DateTime eventTime,
    String? imageUrl,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         userName: userName,
         userEmail: userEmail,
         reportType: reportType,
         title: title,
         description: description,
         category: category,
         latitude: latitude,
         longitude: longitude,
         locationLabel: locationLabel,
         locationId: locationId,
         locationAreaId: locationAreaId,
         eventTime: eventTime,
         imageUrl: imageUrl,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ItemReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ItemReport copyWith({
    Object? id = _Undefined,
    String? userId,
    String? userName,
    String? userEmail,
    String? reportType,
    String? title,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    String? locationLabel,
    Object? locationId = _Undefined,
    Object? locationAreaId = _Undefined,
    DateTime? eventTime,
    Object? imageUrl = _Undefined,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemReport(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      reportType: reportType ?? this.reportType,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationLabel: locationLabel ?? this.locationLabel,
      locationId: locationId is int? ? locationId : this.locationId,
      locationAreaId: locationAreaId is int?
          ? locationAreaId
          : this.locationAreaId,
      eventTime: eventTime ?? this.eventTime,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
