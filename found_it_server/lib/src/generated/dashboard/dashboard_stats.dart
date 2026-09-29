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

abstract class DashboardStats
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DashboardStats._({
    required this.totalLost,
    required this.totalFound,
    required this.totalMatched,
    required this.totalReturned,
    required this.totalLocations,
  });

  factory DashboardStats({
    required int totalLost,
    required int totalFound,
    required int totalMatched,
    required int totalReturned,
    required int totalLocations,
  }) = _DashboardStatsImpl;

  factory DashboardStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return DashboardStats(
      totalLost: jsonSerialization['totalLost'] as int,
      totalFound: jsonSerialization['totalFound'] as int,
      totalMatched: jsonSerialization['totalMatched'] as int,
      totalReturned: jsonSerialization['totalReturned'] as int,
      totalLocations: jsonSerialization['totalLocations'] as int,
    );
  }

  int totalLost;

  int totalFound;

  int totalMatched;

  int totalReturned;

  int totalLocations;

  /// Returns a shallow copy of this [DashboardStats]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DashboardStats copyWith({
    int? totalLost,
    int? totalFound,
    int? totalMatched,
    int? totalReturned,
    int? totalLocations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DashboardStats',
      'totalLost': totalLost,
      'totalFound': totalFound,
      'totalMatched': totalMatched,
      'totalReturned': totalReturned,
      'totalLocations': totalLocations,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DashboardStats',
      'totalLost': totalLost,
      'totalFound': totalFound,
      'totalMatched': totalMatched,
      'totalReturned': totalReturned,
      'totalLocations': totalLocations,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DashboardStatsImpl extends DashboardStats {
  _DashboardStatsImpl({
    required int totalLost,
    required int totalFound,
    required int totalMatched,
    required int totalReturned,
    required int totalLocations,
  }) : super._(
         totalLost: totalLost,
         totalFound: totalFound,
         totalMatched: totalMatched,
         totalReturned: totalReturned,
         totalLocations: totalLocations,
       );

  /// Returns a shallow copy of this [DashboardStats]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DashboardStats copyWith({
    int? totalLost,
    int? totalFound,
    int? totalMatched,
    int? totalReturned,
    int? totalLocations,
  }) {
    return DashboardStats(
      totalLost: totalLost ?? this.totalLost,
      totalFound: totalFound ?? this.totalFound,
      totalMatched: totalMatched ?? this.totalMatched,
      totalReturned: totalReturned ?? this.totalReturned,
      totalLocations: totalLocations ?? this.totalLocations,
    );
  }
}
