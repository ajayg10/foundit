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
import 'package:serverpod/serverpod.dart' as _is;

abstract class VerificationAttemptResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  VerificationAttemptResult._({
    required this.success,
    required this.message,
    required this.attemptsRemaining,
    required this.isLocked,
  });

  factory VerificationAttemptResult({
    required bool success,
    required String message,
    required int attemptsRemaining,
    required bool isLocked,
  }) = _VerificationAttemptResultImpl;

  factory VerificationAttemptResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VerificationAttemptResult(
      success: _is.BoolJsonExtension.fromJson(jsonSerialization['success']),
      message: jsonSerialization['message'] as String,
      attemptsRemaining: jsonSerialization['attemptsRemaining'] as int,
      isLocked: _is.BoolJsonExtension.fromJson(jsonSerialization['isLocked']),
    );
  }

  bool success;

  String message;

  int attemptsRemaining;

  bool isLocked;

  /// Returns a shallow copy of this [VerificationAttemptResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VerificationAttemptResult copyWith({
    bool? success,
    String? message,
    int? attemptsRemaining,
    bool? isLocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationAttemptResult',
      'success': success,
      'message': message,
      'attemptsRemaining': attemptsRemaining,
      'isLocked': isLocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VerificationAttemptResult',
      'success': success,
      'message': message,
      'attemptsRemaining': attemptsRemaining,
      'isLocked': isLocked,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _VerificationAttemptResultImpl extends VerificationAttemptResult {
  _VerificationAttemptResultImpl({
    required bool success,
    required String message,
    required int attemptsRemaining,
    required bool isLocked,
  }) : super._(
         success: success,
         message: message,
         attemptsRemaining: attemptsRemaining,
         isLocked: isLocked,
       );

  /// Returns a shallow copy of this [VerificationAttemptResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VerificationAttemptResult copyWith({
    bool? success,
    String? message,
    int? attemptsRemaining,
    bool? isLocked,
  }) {
    return VerificationAttemptResult(
      success: success ?? this.success,
      message: message ?? this.message,
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
