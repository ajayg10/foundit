/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:found_it_client/src/protocol/matching/item_match.dart'
    as _ik1j6p4l;
import 'package:found_it_client/src/protocol/matching/match_details_dto.dart'
    as _ipha0ngu;
import 'package:found_it_client/src/protocol/notifications/app_notification.dart'
    as _i0k0rxep;
import 'package:found_it_client/src/protocol/reports/item_report.dart'
    as _ii8kv2u4;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'dashboard/dashboard_stats.dart' as _iesgf4cu;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'matching/item_match.dart' as _ixh8na7w;
import 'matching/match_details_dto.dart' as _itwzvm52;
import 'matching/match_explanation_details.dart' as _ii6u1nbj;
import 'notifications/app_notification.dart' as _ih0s0cfq;
import 'reports/item_report.dart' as _im21b726;
import 'users/app_user.dart' as _iczy18ft;
import 'verification/verification.dart' as _i7jbm6rm;
import 'verification/verification_attempt_result.dart' as _ibtylbqq;
export 'dashboard/dashboard_stats.dart';
export 'greetings/greeting.dart';
export 'matching/item_match.dart';
export 'matching/match_details_dto.dart';
export 'matching/match_explanation_details.dart';
export 'notifications/app_notification.dart';
export 'reports/item_report.dart';
export 'users/app_user.dart';
export 'verification/verification.dart';
export 'verification/verification_attempt_result.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iesgf4cu.DashboardStats) {
      return _iesgf4cu.DashboardStats.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _ixh8na7w.ItemMatch) {
      return _ixh8na7w.ItemMatch.fromJson(data) as T;
    }
    if (t == _itwzvm52.MatchDetailsDto) {
      return _itwzvm52.MatchDetailsDto.fromJson(data) as T;
    }
    if (t == _ii6u1nbj.MatchExplanationDetails) {
      return _ii6u1nbj.MatchExplanationDetails.fromJson(data) as T;
    }
    if (t == _ih0s0cfq.AppNotification) {
      return _ih0s0cfq.AppNotification.fromJson(data) as T;
    }
    if (t == _im21b726.ItemReport) {
      return _im21b726.ItemReport.fromJson(data) as T;
    }
    if (t == _iczy18ft.AppUser) {
      return _iczy18ft.AppUser.fromJson(data) as T;
    }
    if (t == _i7jbm6rm.Verification) {
      return _i7jbm6rm.Verification.fromJson(data) as T;
    }
    if (t == _ibtylbqq.VerificationAttemptResult) {
      return _ibtylbqq.VerificationAttemptResult.fromJson(data) as T;
    }
    if (t == _isc.getType<_iesgf4cu.DashboardStats?>()) {
      return (data != null ? _iesgf4cu.DashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixh8na7w.ItemMatch?>()) {
      return (data != null ? _ixh8na7w.ItemMatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itwzvm52.MatchDetailsDto?>()) {
      return (data != null ? _itwzvm52.MatchDetailsDto.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ii6u1nbj.MatchExplanationDetails?>()) {
      return (data != null
              ? _ii6u1nbj.MatchExplanationDetails.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ih0s0cfq.AppNotification?>()) {
      return (data != null ? _ih0s0cfq.AppNotification.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_im21b726.ItemReport?>()) {
      return (data != null ? _im21b726.ItemReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iczy18ft.AppUser?>()) {
      return (data != null ? _iczy18ft.AppUser.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7jbm6rm.Verification?>()) {
      return (data != null ? _i7jbm6rm.Verification.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibtylbqq.VerificationAttemptResult?>()) {
      return (data != null
              ? _ibtylbqq.VerificationAttemptResult.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_ipha0ngu.MatchDetailsDto>) {
      return (data as List)
              .map((e) => deserialize<_ipha0ngu.MatchDetailsDto>(e))
              .toList()
          as T;
    }
    if (t == List<_ik1j6p4l.ItemMatch>) {
      return (data as List)
              .map((e) => deserialize<_ik1j6p4l.ItemMatch>(e))
              .toList()
          as T;
    }
    if (t == List<_i0k0rxep.AppNotification>) {
      return (data as List)
              .map((e) => deserialize<_i0k0rxep.AppNotification>(e))
              .toList()
          as T;
    }
    if (t == List<_ii8kv2u4.ItemReport>) {
      return (data as List)
              .map((e) => deserialize<_ii8kv2u4.ItemReport>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iesgf4cu.DashboardStats => 'DashboardStats',
      _izw8z7ou.Greeting => 'Greeting',
      _ixh8na7w.ItemMatch => 'ItemMatch',
      _itwzvm52.MatchDetailsDto => 'MatchDetailsDto',
      _ii6u1nbj.MatchExplanationDetails => 'MatchExplanationDetails',
      _ih0s0cfq.AppNotification => 'AppNotification',
      _im21b726.ItemReport => 'ItemReport',
      _iczy18ft.AppUser => 'AppUser',
      _i7jbm6rm.Verification => 'Verification',
      _ibtylbqq.VerificationAttemptResult => 'VerificationAttemptResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('found_it.', '');
    }

    switch (data) {
      case _iesgf4cu.DashboardStats():
        return 'DashboardStats';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _ixh8na7w.ItemMatch():
        return 'ItemMatch';
      case _itwzvm52.MatchDetailsDto():
        return 'MatchDetailsDto';
      case _ii6u1nbj.MatchExplanationDetails():
        return 'MatchExplanationDetails';
      case _ih0s0cfq.AppNotification():
        return 'AppNotification';
      case _im21b726.ItemReport():
        return 'ItemReport';
      case _iczy18ft.AppUser():
        return 'AppUser';
      case _i7jbm6rm.Verification():
        return 'Verification';
      case _ibtylbqq.VerificationAttemptResult():
        return 'VerificationAttemptResult';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DashboardStats') {
      return deserialize<_iesgf4cu.DashboardStats>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'ItemMatch') {
      return deserialize<_ixh8na7w.ItemMatch>(data['data']);
    }
    if (dataClassName == 'MatchDetailsDto') {
      return deserialize<_itwzvm52.MatchDetailsDto>(data['data']);
    }
    if (dataClassName == 'MatchExplanationDetails') {
      return deserialize<_ii6u1nbj.MatchExplanationDetails>(data['data']);
    }
    if (dataClassName == 'AppNotification') {
      return deserialize<_ih0s0cfq.AppNotification>(data['data']);
    }
    if (dataClassName == 'ItemReport') {
      return deserialize<_im21b726.ItemReport>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_iczy18ft.AppUser>(data['data']);
    }
    if (dataClassName == 'Verification') {
      return deserialize<_i7jbm6rm.Verification>(data['data']);
    }
    if (dataClassName == 'VerificationAttemptResult') {
      return deserialize<_ibtylbqq.VerificationAttemptResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('found_it', this);
    _iacc.Protocol().registerHostProtocol('found_it', this);
  }

  @override
  String getModuleName() => 'found_it';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
