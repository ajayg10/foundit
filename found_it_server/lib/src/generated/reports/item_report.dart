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

abstract class ItemReport
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ItemReport._({
    this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.reportType,
    required this.title,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.locationLabel,
    this.locationId,
    this.locationAreaId,
    required this.eventTime,
    this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemReport({
    int? id,
    required String userId,
    required String userName,
    required String userEmail,
    required String reportType,
    required String title,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    required String locationLabel,
    int? locationId,
    int? locationAreaId,
    required DateTime eventTime,
    String? imageUrl,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ItemReportImpl;

  factory ItemReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemReport(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      userName: jsonSerialization['userName'] as String,
      userEmail: jsonSerialization['userEmail'] as String,
      reportType: jsonSerialization['reportType'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      locationLabel: jsonSerialization['locationLabel'] as String,
      locationId: jsonSerialization['locationId'] as int?,
      locationAreaId: jsonSerialization['locationAreaId'] as int?,
      eventTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['eventTime'],
      ),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      status: jsonSerialization['status'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = ItemReportTable();

  static const db = ItemReportRepository._();

  @override
  int? id;

  String userId;

  String userName;

  String userEmail;

  String reportType;

  String title;

  String description;

  String category;

  double latitude;

  double longitude;

  String locationLabel;

  int? locationId;

  int? locationAreaId;

  DateTime eventTime;

  String? imageUrl;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ItemReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ItemReport copyWith({
    int? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? reportType,
    String? title,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    String? locationLabel,
    int? locationId,
    int? locationAreaId,
    DateTime? eventTime,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemReport',
      if (id != null) 'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'reportType': reportType,
      'title': title,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'locationLabel': locationLabel,
      if (locationId != null) 'locationId': locationId,
      if (locationAreaId != null) 'locationAreaId': locationAreaId,
      'eventTime': eventTime.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemReport',
      if (id != null) 'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'reportType': reportType,
      'title': title,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'locationLabel': locationLabel,
      if (locationId != null) 'locationId': locationId,
      if (locationAreaId != null) 'locationAreaId': locationAreaId,
      'eventTime': eventTime.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ItemReportInclude include() {
    return ItemReportInclude._();
  }

  static ItemReportIncludeList includeList({
    _is.WhereExpressionBuilder<ItemReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemReportTable>? orderBy,
    _is.OrderByListBuilder<ItemReportTable>? orderByList,
    ItemReportInclude? include,
  }) {
    return ItemReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemReport.t),
      orderByList: orderByList?.call(ItemReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemReportImpl extends ItemReport {
  _ItemReportImpl({
    int? id,
    required String userId,
    required String userName,
    required String userEmail,
    required String reportType,
    required String title,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    required String locationLabel,
    int? locationId,
    int? locationAreaId,
    required DateTime eventTime,
    String? imageUrl,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         userName: userName,
         userEmail: userEmail,
         reportType: reportType,
         title: title,
         description: description,
         category: category,
         latitude: latitude,
         longitude: longitude,
         locationLabel: locationLabel,
         locationId: locationId,
         locationAreaId: locationAreaId,
         eventTime: eventTime,
         imageUrl: imageUrl,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ItemReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ItemReport copyWith({
    Object? id = _Undefined,
    String? userId,
    String? userName,
    String? userEmail,
    String? reportType,
    String? title,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    String? locationLabel,
    Object? locationId = _Undefined,
    Object? locationAreaId = _Undefined,
    DateTime? eventTime,
    Object? imageUrl = _Undefined,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemReport(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      reportType: reportType ?? this.reportType,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationLabel: locationLabel ?? this.locationLabel,
      locationId: locationId is int? ? locationId : this.locationId,
      locationAreaId: locationAreaId is int?
          ? locationAreaId
          : this.locationAreaId,
      eventTime: eventTime ?? this.eventTime,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ItemReportUpdateTable extends _is.UpdateTable<ItemReportTable> {
  ItemReportUpdateTable(super.table);

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> userName(String value) => _is.ColumnValue(
    table.userName,
    value,
  );

  _is.ColumnValue<String, String> userEmail(String value) => _is.ColumnValue(
    table.userEmail,
    value,
  );

  _is.ColumnValue<String, String> reportType(String value) => _is.ColumnValue(
    table.reportType,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> category(String value) => _is.ColumnValue(
    table.category,
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

  _is.ColumnValue<String, String> locationLabel(String value) =>
      _is.ColumnValue(
        table.locationLabel,
        value,
      );

  _is.ColumnValue<int, int> locationId(int? value) => _is.ColumnValue(
    table.locationId,
    value,
  );

  _is.ColumnValue<int, int> locationAreaId(int? value) => _is.ColumnValue(
    table.locationAreaId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> eventTime(DateTime value) =>
      _is.ColumnValue(
        table.eventTime,
        value,
      );

  _is.ColumnValue<String, String> imageUrl(String? value) => _is.ColumnValue(
    table.imageUrl,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ItemReportTable extends _is.Table<int?> {
  ItemReportTable({super.tableRelation}) : super(tableName: 'item_report') {
    updateTable = ItemReportUpdateTable(this);
    userId = _is.ColumnString(
      'userId',
      this,
    );
    userName = _is.ColumnString(
      'userName',
      this,
    );
    userEmail = _is.ColumnString(
      'userEmail',
      this,
    );
    reportType = _is.ColumnString(
      'reportType',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    category = _is.ColumnString(
      'category',
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
    locationLabel = _is.ColumnString(
      'locationLabel',
      this,
    );
    locationId = _is.ColumnInt(
      'locationId',
      this,
    );
    locationAreaId = _is.ColumnInt(
      'locationAreaId',
      this,
    );
    eventTime = _is.ColumnDateTime(
      'eventTime',
      this,
    );
    imageUrl = _is.ColumnString(
      'imageUrl',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ItemReportUpdateTable updateTable;

  late final _is.ColumnString userId;

  late final _is.ColumnString userName;

  late final _is.ColumnString userEmail;

  late final _is.ColumnString reportType;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnString category;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString locationLabel;

  late final _is.ColumnInt locationId;

  late final _is.ColumnInt locationAreaId;

  late final _is.ColumnDateTime eventTime;

  late final _is.ColumnString imageUrl;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    userName,
    userEmail,
    reportType,
    title,
    description,
    category,
    latitude,
    longitude,
    locationLabel,
    locationId,
    locationAreaId,
    eventTime,
    imageUrl,
    status,
    createdAt,
    updatedAt,
  ];
}

class ItemReportInclude extends _is.IncludeObject {
  ItemReportInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ItemReport.t;
}

class ItemReportIncludeList extends _is.IncludeList {
  ItemReportIncludeList._({
    _is.WhereExpressionBuilder<ItemReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ItemReport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ItemReport.t;
}

class ItemReportRepository {
  const ItemReportRepository._();

  /// Returns a list of [ItemReport]s matching the given query parameters.
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
  Future<List<ItemReport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemReportTable>? orderBy,
    _is.OrderByListBuilder<ItemReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ItemReport>(
      where: where?.call(ItemReport.t),
      orderBy: orderBy?.call(ItemReport.t),
      orderByList: orderByList?.call(ItemReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ItemReport] matching the given query parameters.
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
  Future<ItemReport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemReportTable>? where,
    int? offset,
    _is.OrderByBuilder<ItemReportTable>? orderBy,
    _is.OrderByListBuilder<ItemReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ItemReport>(
      where: where?.call(ItemReport.t),
      orderBy: orderBy?.call(ItemReport.t),
      orderByList: orderByList?.call(ItemReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ItemReport] by its [id] or null if no such row exists.
  Future<ItemReport?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ItemReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ItemReport]s in the list and returns the inserted rows.
  ///
  /// The returned [ItemReport]s will have their `id` fields set.
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
  Future<List<ItemReport>> insert(
    _is.DatabaseSession session,
    List<ItemReport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ItemReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ItemReport] and returns the inserted row.
  ///
  /// The returned [ItemReport] will have its `id` field set.
  Future<ItemReport> insertRow(
    _is.DatabaseSession session,
    ItemReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ItemReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ItemReport]s in the list and returns the resulting rows.
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
  /// The returned [ItemReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemReport>> upsert(
    _is.DatabaseSession session,
    List<ItemReport> rows, {
    required _is.ColumnSelections<ItemReportTable> conflictColumns,
    _is.ColumnSelections<ItemReportTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemReportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ItemReport>(
      rows,
      conflictColumns: conflictColumns(ItemReport.t),
      updateColumns: updateColumns?.call(ItemReport.t),
      updateWhere: updateWhere?.call(ItemReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ItemReport] and returns the resulting row.
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
  /// The returned [ItemReport] will have its `id` field set.
  Future<ItemReport?> upsertRow(
    _is.DatabaseSession session,
    ItemReport row, {
    required _is.ColumnSelections<ItemReportTable> conflictColumns,
    _is.ColumnSelections<ItemReportTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemReportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ItemReport>(
      row,
      conflictColumns: conflictColumns(ItemReport.t),
      updateColumns: updateColumns?.call(ItemReport.t),
      updateWhere: updateWhere?.call(ItemReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [ItemReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemReport>> update(
    _is.DatabaseSession session,
    List<ItemReport> rows, {
    _is.ColumnSelections<ItemReportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ItemReport>(
      rows,
      columns: columns?.call(ItemReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ItemReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ItemReport> updateRow(
    _is.DatabaseSession session,
    ItemReport row, {
    _is.ColumnSelections<ItemReportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ItemReport>(
      row,
      columns: columns?.call(ItemReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ItemReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ItemReport?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ItemReportUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ItemReport>(
      id,
      columnValues: columnValues(ItemReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ItemReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemReport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ItemReportUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ItemReportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemReportTable>? orderBy,
    _is.OrderByListBuilder<ItemReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ItemReport>(
      columnValues: columnValues(ItemReport.t.updateTable),
      where: where(ItemReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemReport.t),
      orderByList: orderByList?.call(ItemReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ItemReport]s in the list and returns the deleted rows.
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
  Future<List<ItemReport>> delete(
    _is.DatabaseSession session,
    List<ItemReport> rows, {
    _is.OrderByBuilder<ItemReportTable>? orderBy,
    _is.OrderByListBuilder<ItemReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ItemReport>(
      rows,
      orderBy: orderBy?.call(ItemReport.t),
      orderByList: orderByList?.call(ItemReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ItemReport].
  Future<ItemReport> deleteRow(
    _is.DatabaseSession session,
    ItemReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ItemReport>(
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
  Future<List<ItemReport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemReportTable> where,
    _is.OrderByBuilder<ItemReportTable>? orderBy,
    _is.OrderByListBuilder<ItemReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ItemReport>(
      where: where(ItemReport.t),
      orderBy: orderBy?.call(ItemReport.t),
      orderByList: orderByList?.call(ItemReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemReportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ItemReport>(
      where: where?.call(ItemReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ItemReport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemReportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ItemReport>(
      where: where(ItemReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
