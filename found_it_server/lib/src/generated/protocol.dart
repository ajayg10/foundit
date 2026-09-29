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
import 'package:found_it_server/src/generated/locations/location.dart'
    as _id9j6dcf;
import 'package:found_it_server/src/generated/locations/location_area.dart'
    as _in7zv6r5;
import 'package:found_it_server/src/generated/matching/item_match.dart'
    as _ismt7y3m;
import 'package:found_it_server/src/generated/matching/match_details_dto.dart'
    as _i7rmm1bc;
import 'package:found_it_server/src/generated/notifications/app_notification.dart'
    as _ilf1kb9l;
import 'package:found_it_server/src/generated/reports/item_report.dart'
    as _iy9iiki0;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'dashboard/dashboard_stats.dart' as _iesgf4cu;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'locations/location.dart' as _iwtwows4;
import 'locations/location_area.dart' as _i8bdiajv;
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
export 'locations/location.dart';
export 'locations/location_area.dart';
export 'matching/item_match.dart';
export 'matching/match_details_dto.dart';
export 'matching/match_explanation_details.dart';
export 'notifications/app_notification.dart';
export 'reports/item_report.dart';
export 'users/app_user.dart';
export 'verification/verification.dart';
export 'verification/verification_attempt_result.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'app_notification',
      dartName: 'AppNotification',
      schema: 'public',
      module: 'found_it',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'body',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'relatedMatchId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'relatedReportId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'isRead',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'app_notification_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'app_user',
      dartName: 'AppUser',
      schema: 'public',
      module: 'found_it',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'phoneNumber',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'app_user_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'app_user_user_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item_match',
      dartName: 'ItemMatch',
      schema: 'public',
      module: 'found_it',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'lostReportId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'foundReportId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'confidenceScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'textScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'locationScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'distanceScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'timeScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'categoryScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'explanation',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'distanceKm',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'timeDiffHours',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'item_match_lost_found_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lostReportId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'foundReportId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item_report',
      dartName: 'ItemReport',
      schema: 'public',
      module: 'found_it',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'userName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'userEmail',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'reportType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'locationLabel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'locationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'locationAreaId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'eventTime',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'imageUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'item_report_type_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'reportType',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_report_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_report_category_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'category',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_report_user_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_report_location_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'locationId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item_verification',
      dartName: 'Verification',
      schema: 'public',
      module: 'found_it',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'reportId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'question',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'answerHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'attemptCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'maxAttempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'isVerified',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedByUserId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'verification_report_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'reportId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'location',
      dartName: 'Location',
      schema: 'public',
      module: 'found_it',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'address',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'logoUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'location_name_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'name',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'location_type_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'type',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'location_area',
      dartName: 'LocationArea',
      schema: 'public',
      module: 'found_it',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'locationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'location_area_loc_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'locationId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _iwtwows4.Location) {
      return _iwtwows4.Location.fromJson(data) as T;
    }
    if (t == _i8bdiajv.LocationArea) {
      return _i8bdiajv.LocationArea.fromJson(data) as T;
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
    if (t == _is.getType<_iesgf4cu.DashboardStats?>()) {
      return (data != null ? _iesgf4cu.DashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwtwows4.Location?>()) {
      return (data != null ? _iwtwows4.Location.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8bdiajv.LocationArea?>()) {
      return (data != null ? _i8bdiajv.LocationArea.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixh8na7w.ItemMatch?>()) {
      return (data != null ? _ixh8na7w.ItemMatch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itwzvm52.MatchDetailsDto?>()) {
      return (data != null ? _itwzvm52.MatchDetailsDto.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ii6u1nbj.MatchExplanationDetails?>()) {
      return (data != null
              ? _ii6u1nbj.MatchExplanationDetails.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ih0s0cfq.AppNotification?>()) {
      return (data != null ? _ih0s0cfq.AppNotification.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_im21b726.ItemReport?>()) {
      return (data != null ? _im21b726.ItemReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iczy18ft.AppUser?>()) {
      return (data != null ? _iczy18ft.AppUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7jbm6rm.Verification?>()) {
      return (data != null ? _i7jbm6rm.Verification.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibtylbqq.VerificationAttemptResult?>()) {
      return (data != null
              ? _ibtylbqq.VerificationAttemptResult.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_id9j6dcf.Location>) {
      return (data as List)
              .map((e) => deserialize<_id9j6dcf.Location>(e))
              .toList()
          as T;
    }
    if (t == List<_in7zv6r5.LocationArea>) {
      return (data as List)
              .map((e) => deserialize<_in7zv6r5.LocationArea>(e))
              .toList()
          as T;
    }
    if (t == List<_i7rmm1bc.MatchDetailsDto>) {
      return (data as List)
              .map((e) => deserialize<_i7rmm1bc.MatchDetailsDto>(e))
              .toList()
          as T;
    }
    if (t == List<_ismt7y3m.ItemMatch>) {
      return (data as List)
              .map((e) => deserialize<_ismt7y3m.ItemMatch>(e))
              .toList()
          as T;
    }
    if (t == List<_ilf1kb9l.AppNotification>) {
      return (data as List)
              .map((e) => deserialize<_ilf1kb9l.AppNotification>(e))
              .toList()
          as T;
    }
    if (t == List<_iy9iiki0.ItemReport>) {
      return (data as List)
              .map((e) => deserialize<_iy9iiki0.ItemReport>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iesgf4cu.DashboardStats => 'DashboardStats',
      _izw8z7ou.Greeting => 'Greeting',
      _iwtwows4.Location => 'Location',
      _i8bdiajv.LocationArea => 'LocationArea',
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
      case _iwtwows4.Location():
        return 'Location';
      case _i8bdiajv.LocationArea():
        return 'LocationArea';
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
    if (dataClassName == 'Location') {
      return deserialize<_iwtwows4.Location>(data['data']);
    }
    if (dataClassName == 'LocationArea') {
      return deserialize<_i8bdiajv.LocationArea>(data['data']);
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
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('found_it', this);
    _iacs.Protocol().registerHostProtocol('found_it', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iwtwows4.Location:
        return _iwtwows4.Location.t;
      case _i8bdiajv.LocationArea:
        return _i8bdiajv.LocationArea.t;
      case _ixh8na7w.ItemMatch:
        return _ixh8na7w.ItemMatch.t;
      case _ih0s0cfq.AppNotification:
        return _ih0s0cfq.AppNotification.t;
      case _im21b726.ItemReport:
        return _im21b726.ItemReport.t;
      case _iczy18ft.AppUser:
        return _iczy18ft.AppUser.t;
      case _i7jbm6rm.Verification:
        return _i7jbm6rm.Verification.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
