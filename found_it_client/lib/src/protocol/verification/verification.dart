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

abstract class Verification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Verification._({
    this.id,
    required this.reportId,
    required this.question,
    required this.answerHash,
    required this.attemptCount,
    required this.maxAttempts,
    required this.isVerified,
    this.verifiedByUserId,
    this.verifiedAt,
    required this.createdAt,
  });

  factory Verification({
    int? id,
    required int reportId,
    required String question,
    required String answerHash,
    required int attemptCount,
    required int maxAttempts,
    required bool isVerified,
    String? verifiedByUserId,
    DateTime? verifiedAt,
    required DateTime createdAt,
  }) = _VerificationImpl;

  factory Verification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Verification(
      id: jsonSerialization['id'] as int?,
      reportId: jsonSerialization['reportId'] as int,
      question: jsonSerialization['question'] as String,
      answerHash: jsonSerialization['answerHash'] as String,
      attemptCount: jsonSerialization['attemptCount'] as int,
      maxAttempts: jsonSerialization['maxAttempts'] as int,
      isVerified: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isVerified'],
      ),
      verifiedByUserId: jsonSerialization['verifiedByUserId'] as String?,
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['verifiedAt'],
            ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int reportId;

  String question;

  String answerHash;

  int attemptCount;

  int maxAttempts;

  bool isVerified;

  String? verifiedByUserId;

  DateTime? verifiedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [Verification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Verification copyWith({
    int? id,
    int? reportId,
    String? question,
    String? answerHash,
    int? attemptCount,
    int? maxAttempts,
    bool? isVerified,
    String? verifiedByUserId,
    DateTime? verifiedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Verification',
      if (id != null) 'id': id,
      'reportId': reportId,
      'question': question,
      'answerHash': answerHash,
      'attemptCount': attemptCount,
      'maxAttempts': maxAttempts,
      'isVerified': isVerified,
      if (verifiedByUserId != null) 'verifiedByUserId': verifiedByUserId,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Verification',
      if (id != null) 'id': id,
      'reportId': reportId,
      'question': question,
      'answerHash': answerHash,
      'attemptCount': attemptCount,
      'maxAttempts': maxAttempts,
      'isVerified': isVerified,
      if (verifiedByUserId != null) 'verifiedByUserId': verifiedByUserId,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationImpl extends Verification {
  _VerificationImpl({
    int? id,
    required int reportId,
    required String question,
    required String answerHash,
    required int attemptCount,
    required int maxAttempts,
    required bool isVerified,
    String? verifiedByUserId,
    DateTime? verifiedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         reportId: reportId,
         question: question,
         answerHash: answerHash,
         attemptCount: attemptCount,
         maxAttempts: maxAttempts,
         isVerified: isVerified,
         verifiedByUserId: verifiedByUserId,
         verifiedAt: verifiedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Verification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Verification copyWith({
    Object? id = _Undefined,
    int? reportId,
    String? question,
    String? answerHash,
    int? attemptCount,
    int? maxAttempts,
    bool? isVerified,
    Object? verifiedByUserId = _Undefined,
    Object? verifiedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Verification(
      id: id is int? ? id : this.id,
      reportId: reportId ?? this.reportId,
      question: question ?? this.question,
      answerHash: answerHash ?? this.answerHash,
      attemptCount: attemptCount ?? this.attemptCount,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      isVerified: isVerified ?? this.isVerified,
      verifiedByUserId: verifiedByUserId is String?
          ? verifiedByUserId
          : this.verifiedByUserId,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
