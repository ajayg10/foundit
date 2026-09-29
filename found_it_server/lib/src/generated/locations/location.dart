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

abstract class Location
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Location._({
    this.id,
    required this.name,
    required this.type,
    this.address,
    required this.latitude,
    required this.longitude,
    this.description,
    this.logoUrl,
    required this.isActive,
    required this.createdAt,
  });

  factory Location({
    int? id,
    required String name,
    required String type,
    String? address,
    required double latitude,
    required double longitude,
    String? description,
    String? logoUrl,
    required bool isActive,
    required DateTime createdAt,
  }) = _LocationImpl;

  factory Location.fromJson(Map<String, dynamic> jsonSerialization) {
    return Location(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      description: jsonSerialization['description'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = LocationTable();

  static const db = LocationRepository._();

  @override
  int? id;

  String name;

  String type;

  String? address;

  double latitude;

  double longitude;

  String? description;

  String? logoUrl;

  bool isActive;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Location copyWith({
    int? id,
    String? name,
    String? type,
    String? address,
    double? latitude,
    double? longitude,
    String? description,
    String? logoUrl,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Location',
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Location',
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  static LocationInclude include() {
    return LocationInclude._();
  }

  static LocationIncludeList includeList({
    _is.WhereExpressionBuilder<LocationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LocationTable>? orderBy,
    _is.OrderByListBuilder<LocationTable>? orderByList,
    LocationInclude? include,
  }) {
    return LocationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocationImpl extends Location {
  _LocationImpl({
    int? id,
    required String name,
    required String type,
    String? address,
    required double latitude,
    required double longitude,
    String? description,
    String? logoUrl,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         type: type,
         address: address,
         latitude: latitude,
         longitude: longitude,
         description: description,
         logoUrl: logoUrl,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Location copyWith({
    Object? id = _Undefined,
    String? name,
    String? type,
    Object? address = _Undefined,
    double? latitude,
    double? longitude,
    Object? description = _Undefined,
    Object? logoUrl = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Location(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address is String? ? address : this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description is String? ? description : this.description,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LocationUpdateTable extends _is.UpdateTable<LocationTable> {
  LocationUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> type(String value) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<String, String> address(String? value) => _is.ColumnValue(
    table.address,
    value,
  );

  _is.ColumnValue<double, double> latitude(double value) => _is.ColumnValue(
    table.latitude,
    value,
  );

  _is.ColumnValue<double, double> longitude(double value) => _is.ColumnValue(
    table.longitude,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> logoUrl(String? value) => _is.ColumnValue(
    table.logoUrl,
    value,
  );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class LocationTable extends _is.Table<int?> {
  LocationTable({super.tableRelation}) : super(tableName: 'location') {
    updateTable = LocationUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    type = _is.ColumnString(
      'type',
      this,
    );
    address = _is.ColumnString(
      'address',
      this,
    );
    latitude = _is.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _is.ColumnDouble(
      'longitude',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    logoUrl = _is.ColumnString(
      'logoUrl',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final LocationUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString type;

  late final _is.ColumnString address;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString description;

  late final _is.ColumnString logoUrl;

  late final _is.ColumnBool isActive;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    type,
    address,
    latitude,
    longitude,
    description,
    logoUrl,
    isActive,
    createdAt,
  ];
}

class LocationInclude extends _is.IncludeObject {
  LocationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Location.t;
}

class LocationIncludeList extends _is.IncludeList {
  LocationIncludeList._({
    _is.WhereExpressionBuilder<LocationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Location.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Location.t;
}

class LocationRepository {
  const LocationRepository._();

  /// Returns a list of [Location]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Location>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LocationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LocationTable>? orderBy,
    _is.OrderByListBuilder<LocationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Location>(
      where: where?.call(Location.t),
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Location] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Location?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LocationTable>? where,
    int? offset,
    _is.OrderByBuilder<LocationTable>? orderBy,
    _is.OrderByListBuilder<LocationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Location>(
      where: where?.call(Location.t),
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Location] by its [id] or null if no such row exists.
  Future<Location?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Location>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Location]s in the list and returns the inserted rows.
  ///
  /// The returned [Location]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Location>> insert(
    _is.DatabaseSession session,
    List<Location> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Location>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Location] and returns the inserted row.
  ///
  /// The returned [Location] will have its `id` field set.
  Future<Location> insertRow(
    _is.DatabaseSession session,
    Location row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Location>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Location]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Location]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Location>> upsert(
    _is.DatabaseSession session,
    List<Location> rows, {
    required _is.ColumnSelections<LocationTable> conflictColumns,
    _is.ColumnSelections<LocationTable>? updateColumns,
    _is.WhereExpressionBuilder<LocationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Location>(
      rows,
      conflictColumns: conflictColumns(Location.t),
      updateColumns: updateColumns?.call(Location.t),
      updateWhere: updateWhere?.call(Location.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Location] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Location] will have its `id` field set.
  Future<Location?> upsertRow(
    _is.DatabaseSession session,
    Location row, {
    required _is.ColumnSelections<LocationTable> conflictColumns,
    _is.ColumnSelections<LocationTable>? updateColumns,
    _is.WhereExpressionBuilder<LocationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Location>(
      row,
      conflictColumns: conflictColumns(Location.t),
      updateColumns: updateColumns?.call(Location.t),
      updateWhere: updateWhere?.call(Location.t),
      transaction: transaction,
    );
  }

  /// Updates all [Location]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Location>> update(
    _is.DatabaseSession session,
    List<Location> rows, {
    _is.ColumnSelections<LocationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Location>(
      rows,
      columns: columns?.call(Location.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Location]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Location> updateRow(
    _is.DatabaseSession session,
    Location row, {
    _is.ColumnSelections<LocationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Location>(
      row,
      columns: columns?.call(Location.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Location] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Location?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LocationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Location>(
      id,
      columnValues: columnValues(Location.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Location]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Location>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LocationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LocationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LocationTable>? orderBy,
    _is.OrderByListBuilder<LocationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Location>(
      columnValues: columnValues(Location.t.updateTable),
      where: where(Location.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Location]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Location>> delete(
    _is.DatabaseSession session,
    List<Location> rows, {
    _is.OrderByBuilder<LocationTable>? orderBy,
    _is.OrderByListBuilder<LocationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Location>(
      rows,
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Location].
  Future<Location> deleteRow(
    _is.DatabaseSession session,
    Location row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Location>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Location>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LocationTable> where,
    _is.OrderByBuilder<LocationTable>? orderBy,
    _is.OrderByListBuilder<LocationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Location>(
      where: where(Location.t),
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LocationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Location>(
      where: where?.call(Location.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Location] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LocationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Location>(
      where: where(Location.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
