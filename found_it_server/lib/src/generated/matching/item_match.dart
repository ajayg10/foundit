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

abstract class ItemMatch
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ItemMatch._({
    this.id,
    required this.lostReportId,
    required this.foundReportId,
    required this.confidenceScore,
    required this.textScore,
    required this.locationScore,
    required this.distanceScore,
    required this.timeScore,
    required this.categoryScore,
    required this.explanation,
    required this.distanceKm,
    required this.timeDiffHours,
    required this.status,
    required this.createdAt,
  });

  factory ItemMatch({
    int? id,
    required int lostReportId,
    required int foundReportId,
    required double confidenceScore,
    required double textScore,
    required double locationScore,
    required double distanceScore,
    required double timeScore,
    required double categoryScore,
    required String explanation,
    required double distanceKm,
    required double timeDiffHours,
    required String status,
    required DateTime createdAt,
  }) = _ItemMatchImpl;

  factory ItemMatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemMatch(
      id: jsonSerialization['id'] as int?,
      lostReportId: jsonSerialization['lostReportId'] as int,
      foundReportId: jsonSerialization['foundReportId'] as int,
      confidenceScore: (jsonSerialization['confidenceScore'] as num).toDouble(),
      textScore: (jsonSerialization['textScore'] as num).toDouble(),
      locationScore: (jsonSerialization['locationScore'] as num).toDouble(),
      distanceScore: (jsonSerialization['distanceScore'] as num).toDouble(),
      timeScore: (jsonSerialization['timeScore'] as num).toDouble(),
      categoryScore: (jsonSerialization['categoryScore'] as num).toDouble(),
      explanation: jsonSerialization['explanation'] as String,
      distanceKm: (jsonSerialization['distanceKm'] as num).toDouble(),
      timeDiffHours: (jsonSerialization['timeDiffHours'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ItemMatchTable();

  static const db = ItemMatchRepository._();

  @override
  int? id;

  int lostReportId;

  int foundReportId;

  double confidenceScore;

  double textScore;

  double locationScore;

  double distanceScore;

  double timeScore;

  double categoryScore;

  String explanation;

  double distanceKm;

  double timeDiffHours;

  String status;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ItemMatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ItemMatch copyWith({
    int? id,
    int? lostReportId,
    int? foundReportId,
    double? confidenceScore,
    double? textScore,
    double? locationScore,
    double? distanceScore,
    double? timeScore,
    double? categoryScore,
    String? explanation,
    double? distanceKm,
    double? timeDiffHours,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemMatch',
      if (id != null) 'id': id,
      'lostReportId': lostReportId,
      'foundReportId': foundReportId,
      'confidenceScore': confidenceScore,
      'textScore': textScore,
      'locationScore': locationScore,
      'distanceScore': distanceScore,
      'timeScore': timeScore,
      'categoryScore': categoryScore,
      'explanation': explanation,
      'distanceKm': distanceKm,
      'timeDiffHours': timeDiffHours,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemMatch',
      if (id != null) 'id': id,
      'lostReportId': lostReportId,
      'foundReportId': foundReportId,
      'confidenceScore': confidenceScore,
      'textScore': textScore,
      'locationScore': locationScore,
      'distanceScore': distanceScore,
      'timeScore': timeScore,
      'categoryScore': categoryScore,
      'explanation': explanation,
      'distanceKm': distanceKm,
      'timeDiffHours': timeDiffHours,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  static ItemMatchInclude include() {
    return ItemMatchInclude._();
  }

  static ItemMatchIncludeList includeList({
    _is.WhereExpressionBuilder<ItemMatchTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemMatchTable>? orderBy,
    _is.OrderByListBuilder<ItemMatchTable>? orderByList,
    ItemMatchInclude? include,
  }) {
    return ItemMatchIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemMatch.t),
      orderByList: orderByList?.call(ItemMatch.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemMatchImpl extends ItemMatch {
  _ItemMatchImpl({
    int? id,
    required int lostReportId,
    required int foundReportId,
    required double confidenceScore,
    required double textScore,
    required double locationScore,
    required double distanceScore,
    required double timeScore,
    required double categoryScore,
    required String explanation,
    required double distanceKm,
    required double timeDiffHours,
    required String status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         lostReportId: lostReportId,
         foundReportId: foundReportId,
         confidenceScore: confidenceScore,
         textScore: textScore,
         locationScore: locationScore,
         distanceScore: distanceScore,
         timeScore: timeScore,
         categoryScore: categoryScore,
         explanation: explanation,
         distanceKm: distanceKm,
         timeDiffHours: timeDiffHours,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ItemMatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ItemMatch copyWith({
    Object? id = _Undefined,
    int? lostReportId,
    int? foundReportId,
    double? confidenceScore,
    double? textScore,
    double? locationScore,
    double? distanceScore,
    double? timeScore,
    double? categoryScore,
    String? explanation,
    double? distanceKm,
    double? timeDiffHours,
    String? status,
    DateTime? createdAt,
  }) {
    return ItemMatch(
      id: id is int? ? id : this.id,
      lostReportId: lostReportId ?? this.lostReportId,
      foundReportId: foundReportId ?? this.foundReportId,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      textScore: textScore ?? this.textScore,
      locationScore: locationScore ?? this.locationScore,
      distanceScore: distanceScore ?? this.distanceScore,
      timeScore: timeScore ?? this.timeScore,
      categoryScore: categoryScore ?? this.categoryScore,
      explanation: explanation ?? this.explanation,
      distanceKm: distanceKm ?? this.distanceKm,
      timeDiffHours: timeDiffHours ?? this.timeDiffHours,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ItemMatchUpdateTable extends _is.UpdateTable<ItemMatchTable> {
  ItemMatchUpdateTable(super.table);

  _is.ColumnValue<int, int> lostReportId(int value) => _is.ColumnValue(
    table.lostReportId,
    value,
  );

  _is.ColumnValue<int, int> foundReportId(int value) => _is.ColumnValue(
    table.foundReportId,
    value,
  );

  _is.ColumnValue<double, double> confidenceScore(double value) =>
      _is.ColumnValue(
        table.confidenceScore,
        value,
      );

  _is.ColumnValue<double, double> textScore(double value) => _is.ColumnValue(
    table.textScore,
    value,
  );

  _is.ColumnValue<double, double> locationScore(double value) =>
      _is.ColumnValue(
        table.locationScore,
        value,
      );

  _is.ColumnValue<double, double> distanceScore(double value) =>
      _is.ColumnValue(
        table.distanceScore,
        value,
      );

  _is.ColumnValue<double, double> timeScore(double value) => _is.ColumnValue(
    table.timeScore,
    value,
  );

  _is.ColumnValue<double, double> categoryScore(double value) =>
      _is.ColumnValue(
        table.categoryScore,
        value,
      );

  _is.ColumnValue<String, String> explanation(String value) => _is.ColumnValue(
    table.explanation,
    value,
  );

  _is.ColumnValue<double, double> distanceKm(double value) => _is.ColumnValue(
    table.distanceKm,
    value,
  );

  _is.ColumnValue<double, double> timeDiffHours(double value) =>
      _is.ColumnValue(
        table.timeDiffHours,
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
}

class ItemMatchTable extends _is.Table<int?> {
  ItemMatchTable({super.tableRelation}) : super(tableName: 'item_match') {
    updateTable = ItemMatchUpdateTable(this);
    lostReportId = _is.ColumnInt(
      'lostReportId',
      this,
    );
    foundReportId = _is.ColumnInt(
      'foundReportId',
      this,
    );
    confidenceScore = _is.ColumnDouble(
      'confidenceScore',
      this,
    );
    textScore = _is.ColumnDouble(
      'textScore',
      this,
    );
    locationScore = _is.ColumnDouble(
      'locationScore',
      this,
    );
    distanceScore = _is.ColumnDouble(
      'distanceScore',
      this,
    );
    timeScore = _is.ColumnDouble(
      'timeScore',
      this,
    );
    categoryScore = _is.ColumnDouble(
      'categoryScore',
      this,
    );
    explanation = _is.ColumnString(
      'explanation',
      this,
    );
    distanceKm = _is.ColumnDouble(
      'distanceKm',
      this,
    );
    timeDiffHours = _is.ColumnDouble(
      'timeDiffHours',
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
  }

  late final ItemMatchUpdateTable updateTable;

  late final _is.ColumnInt lostReportId;

  late final _is.ColumnInt foundReportId;

  late final _is.ColumnDouble confidenceScore;

  late final _is.ColumnDouble textScore;

  late final _is.ColumnDouble locationScore;

  late final _is.ColumnDouble distanceScore;

  late final _is.ColumnDouble timeScore;

  late final _is.ColumnDouble categoryScore;

  late final _is.ColumnString explanation;

  late final _is.ColumnDouble distanceKm;

  late final _is.ColumnDouble timeDiffHours;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    lostReportId,
    foundReportId,
    confidenceScore,
    textScore,
    locationScore,
    distanceScore,
    timeScore,
    categoryScore,
    explanation,
    distanceKm,
    timeDiffHours,
    status,
    createdAt,
  ];
}

class ItemMatchInclude extends _is.IncludeObject {
  ItemMatchInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ItemMatch.t;
}

class ItemMatchIncludeList extends _is.IncludeList {
  ItemMatchIncludeList._({
    _is.WhereExpressionBuilder<ItemMatchTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ItemMatch.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ItemMatch.t;
}

class ItemMatchRepository {
  const ItemMatchRepository._();

  /// Returns a list of [ItemMatch]s matching the given query parameters.
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
  Future<List<ItemMatch>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemMatchTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemMatchTable>? orderBy,
    _is.OrderByListBuilder<ItemMatchTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ItemMatch>(
      where: where?.call(ItemMatch.t),
      orderBy: orderBy?.call(ItemMatch.t),
      orderByList: orderByList?.call(ItemMatch.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ItemMatch] matching the given query parameters.
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
  Future<ItemMatch?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemMatchTable>? where,
    int? offset,
    _is.OrderByBuilder<ItemMatchTable>? orderBy,
    _is.OrderByListBuilder<ItemMatchTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ItemMatch>(
      where: where?.call(ItemMatch.t),
      orderBy: orderBy?.call(ItemMatch.t),
      orderByList: orderByList?.call(ItemMatch.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ItemMatch] by its [id] or null if no such row exists.
  Future<ItemMatch?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ItemMatch>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ItemMatch]s in the list and returns the inserted rows.
  ///
  /// The returned [ItemMatch]s will have their `id` fields set.
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
  Future<List<ItemMatch>> insert(
    _is.DatabaseSession session,
    List<ItemMatch> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ItemMatch>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ItemMatch] and returns the inserted row.
  ///
  /// The returned [ItemMatch] will have its `id` field set.
  Future<ItemMatch> insertRow(
    _is.DatabaseSession session,
    ItemMatch row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ItemMatch>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ItemMatch]s in the list and returns the resulting rows.
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
  /// The returned [ItemMatch]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemMatch>> upsert(
    _is.DatabaseSession session,
    List<ItemMatch> rows, {
    required _is.ColumnSelections<ItemMatchTable> conflictColumns,
    _is.ColumnSelections<ItemMatchTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemMatchTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ItemMatch>(
      rows,
      conflictColumns: conflictColumns(ItemMatch.t),
      updateColumns: updateColumns?.call(ItemMatch.t),
      updateWhere: updateWhere?.call(ItemMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ItemMatch] and returns the resulting row.
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
  /// The returned [ItemMatch] will have its `id` field set.
  Future<ItemMatch?> upsertRow(
    _is.DatabaseSession session,
    ItemMatch row, {
    required _is.ColumnSelections<ItemMatchTable> conflictColumns,
    _is.ColumnSelections<ItemMatchTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemMatchTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ItemMatch>(
      row,
      conflictColumns: conflictColumns(ItemMatch.t),
      updateColumns: updateColumns?.call(ItemMatch.t),
      updateWhere: updateWhere?.call(ItemMatch.t),
      transaction: transaction,
    );
  }

  /// Updates all [ItemMatch]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemMatch>> update(
    _is.DatabaseSession session,
    List<ItemMatch> rows, {
    _is.ColumnSelections<ItemMatchTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ItemMatch>(
      rows,
      columns: columns?.call(ItemMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ItemMatch]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ItemMatch> updateRow(
    _is.DatabaseSession session,
    ItemMatch row, {
    _is.ColumnSelections<ItemMatchTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ItemMatch>(
      row,
      columns: columns?.call(ItemMatch.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ItemMatch] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ItemMatch?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ItemMatchUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ItemMatch>(
      id,
      columnValues: columnValues(ItemMatch.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ItemMatch]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemMatch>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ItemMatchUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ItemMatchTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemMatchTable>? orderBy,
    _is.OrderByListBuilder<ItemMatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ItemMatch>(
      columnValues: columnValues(ItemMatch.t.updateTable),
      where: where(ItemMatch.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemMatch.t),
      orderByList: orderByList?.call(ItemMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ItemMatch]s in the list and returns the deleted rows.
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
  Future<List<ItemMatch>> delete(
    _is.DatabaseSession session,
    List<ItemMatch> rows, {
    _is.OrderByBuilder<ItemMatchTable>? orderBy,
    _is.OrderByListBuilder<ItemMatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ItemMatch>(
      rows,
      orderBy: orderBy?.call(ItemMatch.t),
      orderByList: orderByList?.call(ItemMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ItemMatch].
  Future<ItemMatch> deleteRow(
    _is.DatabaseSession session,
    ItemMatch row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ItemMatch>(
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
  Future<List<ItemMatch>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemMatchTable> where,
    _is.OrderByBuilder<ItemMatchTable>? orderBy,
    _is.OrderByListBuilder<ItemMatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ItemMatch>(
      where: where(ItemMatch.t),
      orderBy: orderBy?.call(ItemMatch.t),
      orderByList: orderByList?.call(ItemMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemMatchTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ItemMatch>(
      where: where?.call(ItemMatch.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ItemMatch] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemMatchTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ItemMatch>(
      where: where(ItemMatch.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
