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

abstract class MatchExplanationDetails
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MatchExplanationDetails._({
    required this.title,
    required this.confidencePercentage,
    required this.textSimilaritySummary,
    required this.distanceSummary,
    required this.timeSummary,
    required this.categorySummary,
    required this.overallVerdict,
  });

  factory MatchExplanationDetails({
    required String title,
    required int confidencePercentage,
    required String textSimilaritySummary,
    required String distanceSummary,
    required String timeSummary,
    required String categorySummary,
    required String overallVerdict,
  }) = _MatchExplanationDetailsImpl;

  factory MatchExplanationDetails.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MatchExplanationDetails(
      title: jsonSerialization['title'] as String,
      confidencePercentage: jsonSerialization['confidencePercentage'] as int,
      textSimilaritySummary:
          jsonSerialization['textSimilaritySummary'] as String,
      distanceSummary: jsonSerialization['distanceSummary'] as String,
      timeSummary: jsonSerialization['timeSummary'] as String,
      categorySummary: jsonSerialization['categorySummary'] as String,
      overallVerdict: jsonSerialization['overallVerdict'] as String,
    );
  }

  String title;

  int confidencePercentage;

  String textSimilaritySummary;

  String distanceSummary;

  String timeSummary;

  String categorySummary;

  String overallVerdict;

  /// Returns a shallow copy of this [MatchExplanationDetails]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MatchExplanationDetails copyWith({
    String? title,
    int? confidencePercentage,
    String? textSimilaritySummary,
    String? distanceSummary,
    String? timeSummary,
    String? categorySummary,
    String? overallVerdict,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MatchExplanationDetails',
      'title': title,
      'confidencePercentage': confidencePercentage,
      'textSimilaritySummary': textSimilaritySummary,
      'distanceSummary': distanceSummary,
      'timeSummary': timeSummary,
      'categorySummary': categorySummary,
      'overallVerdict': overallVerdict,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MatchExplanationDetails',
      'title': title,
      'confidencePercentage': confidencePercentage,
      'textSimilaritySummary': textSimilaritySummary,
      'distanceSummary': distanceSummary,
      'timeSummary': timeSummary,
      'categorySummary': categorySummary,
      'overallVerdict': overallVerdict,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MatchExplanationDetailsImpl extends MatchExplanationDetails {
  _MatchExplanationDetailsImpl({
    required String title,
    required int confidencePercentage,
    required String textSimilaritySummary,
    required String distanceSummary,
    required String timeSummary,
    required String categorySummary,
    required String overallVerdict,
  }) : super._(
         title: title,
         confidencePercentage: confidencePercentage,
         textSimilaritySummary: textSimilaritySummary,
         distanceSummary: distanceSummary,
         timeSummary: timeSummary,
         categorySummary: categorySummary,
         overallVerdict: overallVerdict,
       );

  /// Returns a shallow copy of this [MatchExplanationDetails]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MatchExplanationDetails copyWith({
    String? title,
    int? confidencePercentage,
    String? textSimilaritySummary,
    String? distanceSummary,
    String? timeSummary,
    String? categorySummary,
    String? overallVerdict,
  }) {
    return MatchExplanationDetails(
      title: title ?? this.title,
      confidencePercentage: confidencePercentage ?? this.confidencePercentage,
      textSimilaritySummary:
          textSimilaritySummary ?? this.textSimilaritySummary,
      distanceSummary: distanceSummary ?? this.distanceSummary,
      timeSummary: timeSummary ?? this.timeSummary,
      categorySummary: categorySummary ?? this.categorySummary,
      overallVerdict: overallVerdict ?? this.overallVerdict,
    );
  }
}
