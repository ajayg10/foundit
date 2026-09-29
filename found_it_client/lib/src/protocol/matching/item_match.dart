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

abstract class ItemMatch
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ItemMatch._({
    this.id,
    required this.lostReportId,
    required this.foundReportId,
    required this.confidenceScore,
    required this.textScore,
    required this.locationScore,
    required this.distanceScore,
    required this.timeScore,
    required this.categoryScore,
    required this.explanation,
    required this.distanceKm,
    required this.timeDiffHours,
    required this.status,
    required this.createdAt,
  });

  factory ItemMatch({
    int? id,
    required int lostReportId,
    required int foundReportId,
    required double confidenceScore,
    required double textScore,
    required double locationScore,
    required double distanceScore,
    required double timeScore,
    required double categoryScore,
    required String explanation,
    required double distanceKm,
    required double timeDiffHours,
    required String status,
    required DateTime createdAt,
  }) = _ItemMatchImpl;

  factory ItemMatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemMatch(
      id: jsonSerialization['id'] as int?,
      lostReportId: jsonSerialization['lostReportId'] as int,
      foundReportId: jsonSerialization['foundReportId'] as int,
      confidenceScore: (jsonSerialization['confidenceScore'] as num).toDouble(),
      textScore: (jsonSerialization['textScore'] as num).toDouble(),
      locationScore: (jsonSerialization['locationScore'] as num).toDouble(),
      distanceScore: (jsonSerialization['distanceScore'] as num).toDouble(),
      timeScore: (jsonSerialization['timeScore'] as num).toDouble(),
      categoryScore: (jsonSerialization['categoryScore'] as num).toDouble(),
      explanation: jsonSerialization['explanation'] as String,
      distanceKm: (jsonSerialization['distanceKm'] as num).toDouble(),
      timeDiffHours: (jsonSerialization['timeDiffHours'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int lostReportId;

  int foundReportId;

  double confidenceScore;

  double textScore;

  double locationScore;

  double distanceScore;

  double timeScore;

  double categoryScore;

  String explanation;

  double distanceKm;

  double timeDiffHours;

  String status;

  DateTime createdAt;

  /// Returns a shallow copy of this [ItemMatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ItemMatch copyWith({
    int? id,
    int? lostReportId,
    int? foundReportId,
    double? confidenceScore,
    double? textScore,
    double? locationScore,
    double? distanceScore,
    double? timeScore,
    double? categoryScore,
    String? explanation,
    double? distanceKm,
    double? timeDiffHours,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemMatch',
      if (id != null) 'id': id,
      'lostReportId': lostReportId,
      'foundReportId': foundReportId,
      'confidenceScore': confidenceScore,
      'textScore': textScore,
      'locationScore': locationScore,
      'distanceScore': distanceScore,
      'timeScore': timeScore,
      'categoryScore': categoryScore,
      'explanation': explanation,
      'distanceKm': distanceKm,
      'timeDiffHours': timeDiffHours,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemMatch',
      if (id != null) 'id': id,
      'lostReportId': lostReportId,
      'foundReportId': foundReportId,
      'confidenceScore': confidenceScore,
      'textScore': textScore,
      'locationScore': locationScore,
      'distanceScore': distanceScore,
      'timeScore': timeScore,
      'categoryScore': categoryScore,
      'explanation': explanation,
      'distanceKm': distanceKm,
      'timeDiffHours': timeDiffHours,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemMatchImpl extends ItemMatch {
  _ItemMatchImpl({
    int? id,
    required int lostReportId,
    required int foundReportId,
    required double confidenceScore,
    required double textScore,
    required double locationScore,
    required double distanceScore,
    required double timeScore,
    required double categoryScore,
    required String explanation,
    required double distanceKm,
    required double timeDiffHours,
    required String status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         lostReportId: lostReportId,
         foundReportId: foundReportId,
         confidenceScore: confidenceScore,
         textScore: textScore,
         locationScore: locationScore,
         distanceScore: distanceScore,
         timeScore: timeScore,
         categoryScore: categoryScore,
         explanation: explanation,
         distanceKm: distanceKm,
         timeDiffHours: timeDiffHours,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ItemMatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ItemMatch copyWith({
    Object? id = _Undefined,
    int? lostReportId,
    int? foundReportId,
    double? confidenceScore,
    double? textScore,
    double? locationScore,
    double? distanceScore,
    double? timeScore,
    double? categoryScore,
    String? explanation,
    double? distanceKm,
    double? timeDiffHours,
    String? status,
    DateTime? createdAt,
  }) {
    return ItemMatch(
      id: id is int? ? id : this.id,
      lostReportId: lostReportId ?? this.lostReportId,
      foundReportId: foundReportId ?? this.foundReportId,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      textScore: textScore ?? this.textScore,
      locationScore: locationScore ?? this.locationScore,
      distanceScore: distanceScore ?? this.distanceScore,
      timeScore: timeScore ?? this.timeScore,
      categoryScore: categoryScore ?? this.categoryScore,
      explanation: explanation ?? this.explanation,
      distanceKm: distanceKm ?? this.distanceKm,
      timeDiffHours: timeDiffHours ?? this.timeDiffHours,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
