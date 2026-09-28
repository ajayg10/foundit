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
import 'package:found_it_server/src/generated/protocol.dart' as _i8vlejh0;
import 'package:serverpod/serverpod.dart' as _is;
import '../matching/item_match.dart' as _ih5on70d;
import '../reports/item_report.dart' as _igimip56;

abstract class MatchDetailsDto
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MatchDetailsDto._({
    required this.match,
    required this.lostReport,
    required this.foundReport,
    this.verificationQuestion,
    required this.isClaimPending,
    required this.isVerified,
  });

  factory MatchDetailsDto({
    required _ih5on70d.ItemMatch match,
    required _igimip56.ItemReport lostReport,
    required _igimip56.ItemReport foundReport,
    String? verificationQuestion,
    required bool isClaimPending,
    required bool isVerified,
  }) = _MatchDetailsDtoImpl;

  factory MatchDetailsDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return MatchDetailsDto(
      match: _i8vlejh0.Protocol().deserialize<_ih5on70d.ItemMatch>(
        jsonSerialization['match'],
      ),
      lostReport: _i8vlejh0.Protocol().deserialize<_igimip56.ItemReport>(
        jsonSerialization['lostReport'],
      ),
      foundReport: _i8vlejh0.Protocol().deserialize<_igimip56.ItemReport>(
        jsonSerialization['foundReport'],
      ),
      verificationQuestion:
          jsonSerialization['verificationQuestion'] as String?,
      isClaimPending: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isClaimPending'],
      ),
      isVerified: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isVerified'],
      ),
    );
  }

  _ih5on70d.ItemMatch match;

  _igimip56.ItemReport lostReport;

  _igimip56.ItemReport foundReport;

  String? verificationQuestion;

  bool isClaimPending;

  bool isVerified;

  /// Returns a shallow copy of this [MatchDetailsDto]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MatchDetailsDto copyWith({
    _ih5on70d.ItemMatch? match,
    _igimip56.ItemReport? lostReport,
    _igimip56.ItemReport? foundReport,
    String? verificationQuestion,
    bool? isClaimPending,
    bool? isVerified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MatchDetailsDto',
      'match': match.toJson(),
      'lostReport': lostReport.toJson(),
      'foundReport': foundReport.toJson(),
      if (verificationQuestion != null)
        'verificationQuestion': verificationQuestion,
      'isClaimPending': isClaimPending,
      'isVerified': isVerified,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MatchDetailsDto',
      'match': match.toJsonForProtocol(),
      'lostReport': lostReport.toJsonForProtocol(),
      'foundReport': foundReport.toJsonForProtocol(),
      if (verificationQuestion != null)
        'verificationQuestion': verificationQuestion,
      'isClaimPending': isClaimPending,
      'isVerified': isVerified,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MatchDetailsDtoImpl extends MatchDetailsDto {
  _MatchDetailsDtoImpl({
    required _ih5on70d.ItemMatch match,
    required _igimip56.ItemReport lostReport,
    required _igimip56.ItemReport foundReport,
    String? verificationQuestion,
    required bool isClaimPending,
    required bool isVerified,
  }) : super._(
         match: match,
         lostReport: lostReport,
         foundReport: foundReport,
         verificationQuestion: verificationQuestion,
         isClaimPending: isClaimPending,
         isVerified: isVerified,
       );

  /// Returns a shallow copy of this [MatchDetailsDto]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MatchDetailsDto copyWith({
    _ih5on70d.ItemMatch? match,
    _igimip56.ItemReport? lostReport,
    _igimip56.ItemReport? foundReport,
    Object? verificationQuestion = _Undefined,
    bool? isClaimPending,
    bool? isVerified,
  }) {
    return MatchDetailsDto(
      match: match ?? this.match.copyWith(),
      lostReport: lostReport ?? this.lostReport.copyWith(),
      foundReport: foundReport ?? this.foundReport.copyWith(),
      verificationQuestion: verificationQuestion is String?
          ? verificationQuestion
          : this.verificationQuestion,
      isClaimPending: isClaimPending ?? this.isClaimPending,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
