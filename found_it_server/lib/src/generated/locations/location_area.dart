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

abstract class LocationArea
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LocationArea._({
    this.id,
    required this.locationId,
    required this.name,
    this.latitude,
    this.longitude,
    this.description,
    required this.isActive,
  });

  factory LocationArea({
    int? id,
    required int locationId,
    required String name,
    double? latitude,
    double? longitude,
    String? description,
    required bool isActive,
  }) = _LocationAreaImpl;

  factory LocationArea.fromJson(Map<String, dynamic> jsonSerialization) {
    return LocationArea(
      id: jsonSerialization['id'] as int?,
      locationId: jsonSerialization['locationId'] as int,
      name: jsonSerialization['name'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      description: jsonSerialization['description'] as String?,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  static final t = LocationAreaTable();

  static const db = LocationAreaRepository._();

  @override
  int? id;

  int locationId;

  String name;

  double? latitude;

  double? longitude;

  String? description;

  bool isActive;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LocationArea]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LocationArea copyWith({
    int? id,
    int? locationId,
    String? name,
    double? latitude,
    double? longitude,
    String? description,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LocationArea',
      if (id != null) 'id': id,
      'locationId': locationId,
      'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LocationArea',
      if (id != null) 'id': id,
      'locationId': locationId,
      'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      'isActive': isActive,
    };
  }

  static LocationAreaInclude include() {
    return LocationAreaInclude._();
  }

  static LocationAreaIncludeList includeList({
    _is.WhereExpressionBuilder<LocationAreaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LocationAreaTable>? orderBy,
    _is.OrderByListBuilder<LocationAreaTable>? orderByList,
    LocationAreaInclude? include,
  }) {
    return LocationAreaIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LocationArea.t),
      orderByList: orderByList?.call(LocationArea.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocationAreaImpl extends LocationArea {
  _LocationAreaImpl({
    int? id,
    required int locationId,
    required String name,
    double? latitude,
    double? longitude,
    String? description,
    required bool isActive,
  }) : super._(
         id: id,
         locationId: locationId,
         name: name,
         latitude: latitude,
         longitude: longitude,
         description: description,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [LocationArea]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LocationArea copyWith({
    Object? id = _Undefined,
    int? locationId,
    String? name,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? description = _Undefined,
    bool? isActive,
  }) {
    return LocationArea(
      id: id is int? ? id : this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}

class LocationAreaUpdateTable extends _is.UpdateTable<LocationAreaTable> {
  LocationAreaUpdateTable(super.table);

  _is.ColumnValue<int, int> locationId(int value) => _is.ColumnValue(
    table.locationId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<double, double> latitude(double? value) => _is.ColumnValue(
    table.latitude,
    value,
  );

  _is.ColumnValue<double, double> longitude(double? value) => _is.ColumnValue(
    table.longitude,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );
}

class LocationAreaTable extends _is.Table<int?> {
  LocationAreaTable({super.tableRelation}) : super(tableName: 'location_area') {
    updateTable = LocationAreaUpdateTable(this);
    locationId = _is.ColumnInt(
      'locationId',
      this,
    );
    name = _is.ColumnString(
      'name',
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
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
  }

  late final LocationAreaUpdateTable updateTable;

  late final _is.ColumnInt locationId;

  late final _is.ColumnString name;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString description;

  late final _is.ColumnBool isActive;

  @override
  List<_is.Column> get columns => [
    id,
    locationId,
    name,
    latitude,
    longitude,
    description,
    isActive,
  ];
}

class LocationAreaInclude extends _is.IncludeObject {
  LocationAreaInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LocationArea.t;
}

class LocationAreaIncludeList extends _is.IncludeList {
  LocationAreaIncludeList._({
    _is.WhereExpressionBuilder<LocationAreaTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LocationArea.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LocationArea.t;
}

class LocationAreaRepository {
  const LocationAreaRepository._();

  /// Returns a list of [LocationArea]s matching the given query parameters.
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
  Future<List<LocationArea>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LocationAreaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LocationAreaTable>? orderBy,
    _is.OrderByListBuilder<LocationAreaTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LocationArea>(
      where: where?.call(LocationArea.t),
      orderBy: orderBy?.call(LocationArea.t),
      orderByList: orderByList?.call(LocationArea.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LocationArea] matching the given query parameters.
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
  Future<LocationArea?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LocationAreaTable>? where,
    int? offset,
    _is.OrderByBuilder<LocationAreaTable>? orderBy,
    _is.OrderByListBuilder<LocationAreaTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LocationArea>(
      where: where?.call(LocationArea.t),
      orderBy: orderBy?.call(LocationArea.t),
      orderByList: orderByList?.call(LocationArea.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LocationArea] by its [id] or null if no such row exists.
  Future<LocationArea?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LocationArea>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LocationArea]s in the list and returns the inserted rows.
  ///
  /// The returned [LocationArea]s will have their `id` fields set.
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
  Future<List<LocationArea>> insert(
    _is.DatabaseSession session,
    List<LocationArea> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LocationArea>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LocationArea] and returns the inserted row.
  ///
  /// The returned [LocationArea] will have its `id` field set.
  Future<LocationArea> insertRow(
    _is.DatabaseSession session,
    LocationArea row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LocationArea>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LocationArea]s in the list and returns the resulting rows.
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
  /// The returned [LocationArea]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocationArea>> upsert(
    _is.DatabaseSession session,
    List<LocationArea> rows, {
    required _is.ColumnSelections<LocationAreaTable> conflictColumns,
    _is.ColumnSelections<LocationAreaTable>? updateColumns,
    _is.WhereExpressionBuilder<LocationAreaTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LocationArea>(
      rows,
      conflictColumns: conflictColumns(LocationArea.t),
      updateColumns: updateColumns?.call(LocationArea.t),
      updateWhere: updateWhere?.call(LocationArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LocationArea] and returns the resulting row.
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
  /// The returned [LocationArea] will have its `id` field set.
  Future<LocationArea?> upsertRow(
    _is.DatabaseSession session,
    LocationArea row, {
    required _is.ColumnSelections<LocationAreaTable> conflictColumns,
    _is.ColumnSelections<LocationAreaTable>? updateColumns,
    _is.WhereExpressionBuilder<LocationAreaTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LocationArea>(
      row,
      conflictColumns: conflictColumns(LocationArea.t),
      updateColumns: updateColumns?.call(LocationArea.t),
      updateWhere: updateWhere?.call(LocationArea.t),
      transaction: transaction,
    );
  }

  /// Updates all [LocationArea]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocationArea>> update(
    _is.DatabaseSession session,
    List<LocationArea> rows, {
    _is.ColumnSelections<LocationAreaTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LocationArea>(
      rows,
      columns: columns?.call(LocationArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LocationArea]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LocationArea> updateRow(
    _is.DatabaseSession session,
    LocationArea row, {
    _is.ColumnSelections<LocationAreaTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LocationArea>(
      row,
      columns: columns?.call(LocationArea.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LocationArea] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LocationArea?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LocationAreaUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LocationArea>(
      id,
      columnValues: columnValues(LocationArea.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LocationArea]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocationArea>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LocationAreaUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LocationAreaTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LocationAreaTable>? orderBy,
    _is.OrderByListBuilder<LocationAreaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LocationArea>(
      columnValues: columnValues(LocationArea.t.updateTable),
      where: where(LocationArea.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LocationArea.t),
      orderByList: orderByList?.call(LocationArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LocationArea]s in the list and returns the deleted rows.
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
  Future<List<LocationArea>> delete(
    _is.DatabaseSession session,
    List<LocationArea> rows, {
    _is.OrderByBuilder<LocationAreaTable>? orderBy,
    _is.OrderByListBuilder<LocationAreaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LocationArea>(
      rows,
      orderBy: orderBy?.call(LocationArea.t),
      orderByList: orderByList?.call(LocationArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LocationArea].
  Future<LocationArea> deleteRow(
    _is.DatabaseSession session,
    LocationArea row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LocationArea>(
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
  Future<List<LocationArea>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LocationAreaTable> where,
    _is.OrderByBuilder<LocationAreaTable>? orderBy,
    _is.OrderByListBuilder<LocationAreaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LocationArea>(
      where: where(LocationArea.t),
      orderBy: orderBy?.call(LocationArea.t),
      orderByList: orderByList?.call(LocationArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LocationAreaTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LocationArea>(
      where: where?.call(LocationArea.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LocationArea] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LocationAreaTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LocationArea>(
      where: where(LocationArea.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
