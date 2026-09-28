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

abstract class Verification
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Verification._({
    this.id,
    required this.reportId,
    required this.question,
    required this.answerHash,
    required this.attemptCount,
    required this.maxAttempts,
    required this.isVerified,
    this.verifiedByUserId,
    this.verifiedAt,
    required this.createdAt,
  });

  factory Verification({
    int? id,
    required int reportId,
    required String question,
    required String answerHash,
    required int attemptCount,
    required int maxAttempts,
    required bool isVerified,
    String? verifiedByUserId,
    DateTime? verifiedAt,
    required DateTime createdAt,
  }) = _VerificationImpl;

  factory Verification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Verification(
      id: jsonSerialization['id'] as int?,
      reportId: jsonSerialization['reportId'] as int,
      question: jsonSerialization['question'] as String,
      answerHash: jsonSerialization['answerHash'] as String,
      attemptCount: jsonSerialization['attemptCount'] as int,
      maxAttempts: jsonSerialization['maxAttempts'] as int,
      isVerified: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isVerified'],
      ),
      verifiedByUserId: jsonSerialization['verifiedByUserId'] as String?,
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = VerificationTable();

  static const db = VerificationRepository._();

  @override
  int? id;

  int reportId;

  String question;

  String answerHash;

  int attemptCount;

  int maxAttempts;

  bool isVerified;

  String? verifiedByUserId;

  DateTime? verifiedAt;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Verification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Verification copyWith({
    int? id,
    int? reportId,
    String? question,
    String? answerHash,
    int? attemptCount,
    int? maxAttempts,
    bool? isVerified,
    String? verifiedByUserId,
    DateTime? verifiedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Verification',
      if (id != null) 'id': id,
      'reportId': reportId,
      'question': question,
      'answerHash': answerHash,
      'attemptCount': attemptCount,
      'maxAttempts': maxAttempts,
      'isVerified': isVerified,
      if (verifiedByUserId != null) 'verifiedByUserId': verifiedByUserId,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Verification',
      if (id != null) 'id': id,
      'reportId': reportId,
      'question': question,
      'answerHash': answerHash,
      'attemptCount': attemptCount,
      'maxAttempts': maxAttempts,
      'isVerified': isVerified,
      if (verifiedByUserId != null) 'verifiedByUserId': verifiedByUserId,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static VerificationInclude include() {
    return VerificationInclude._();
  }

  static VerificationIncludeList includeList({
    _is.WhereExpressionBuilder<VerificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VerificationTable>? orderBy,
    _is.OrderByListBuilder<VerificationTable>? orderByList,
    VerificationInclude? include,
  }) {
    return VerificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Verification.t),
      orderByList: orderByList?.call(Verification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationImpl extends Verification {
  _VerificationImpl({
    int? id,
    required int reportId,
    required String question,
    required String answerHash,
    required int attemptCount,
    required int maxAttempts,
    required bool isVerified,
    String? verifiedByUserId,
    DateTime? verifiedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         reportId: reportId,
         question: question,
         answerHash: answerHash,
         attemptCount: attemptCount,
         maxAttempts: maxAttempts,
         isVerified: isVerified,
         verifiedByUserId: verifiedByUserId,
         verifiedAt: verifiedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Verification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Verification copyWith({
    Object? id = _Undefined,
    int? reportId,
    String? question,
    String? answerHash,
    int? attemptCount,
    int? maxAttempts,
    bool? isVerified,
    Object? verifiedByUserId = _Undefined,
    Object? verifiedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Verification(
      id: id is int? ? id : this.id,
      reportId: reportId ?? this.reportId,
      question: question ?? this.question,
      answerHash: answerHash ?? this.answerHash,
      attemptCount: attemptCount ?? this.attemptCount,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      isVerified: isVerified ?? this.isVerified,
      verifiedByUserId: verifiedByUserId is String?
          ? verifiedByUserId
          : this.verifiedByUserId,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class VerificationUpdateTable extends _is.UpdateTable<VerificationTable> {
  VerificationUpdateTable(super.table);

  _is.ColumnValue<int, int> reportId(int value) => _is.ColumnValue(
    table.reportId,
    value,
  );

  _is.ColumnValue<String, String> question(String value) => _is.ColumnValue(
    table.question,
    value,
  );

  _is.ColumnValue<String, String> answerHash(String value) => _is.ColumnValue(
    table.answerHash,
    value,
  );

  _is.ColumnValue<int, int> attemptCount(int value) => _is.ColumnValue(
    table.attemptCount,
    value,
  );

  _is.ColumnValue<int, int> maxAttempts(int value) => _is.ColumnValue(
    table.maxAttempts,
    value,
  );

  _is.ColumnValue<bool, bool> isVerified(bool value) => _is.ColumnValue(
    table.isVerified,
    value,
  );

  _is.ColumnValue<String, String> verifiedByUserId(String? value) =>
      _is.ColumnValue(
        table.verifiedByUserId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> verifiedAt(DateTime? value) =>
      _is.ColumnValue(
        table.verifiedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class VerificationTable extends _is.Table<int?> {
  VerificationTable({super.tableRelation})
    : super(tableName: 'item_verification') {
    updateTable = VerificationUpdateTable(this);
    reportId = _is.ColumnInt(
      'reportId',
      this,
    );
    question = _is.ColumnString(
      'question',
      this,
    );
    answerHash = _is.ColumnString(
      'answerHash',
      this,
    );
    attemptCount = _is.ColumnInt(
      'attemptCount',
      this,
    );
    maxAttempts = _is.ColumnInt(
      'maxAttempts',
      this,
    );
    isVerified = _is.ColumnBool(
      'isVerified',
      this,
    );
    verifiedByUserId = _is.ColumnString(
      'verifiedByUserId',
      this,
    );
    verifiedAt = _is.ColumnDateTime(
      'verifiedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final VerificationUpdateTable updateTable;

  late final _is.ColumnInt reportId;

  late final _is.ColumnString question;

  late final _is.ColumnString answerHash;

  late final _is.ColumnInt attemptCount;

  late final _is.ColumnInt maxAttempts;

  late final _is.ColumnBool isVerified;

  late final _is.ColumnString verifiedByUserId;

  late final _is.ColumnDateTime verifiedAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    reportId,
    question,
    answerHash,
    attemptCount,
    maxAttempts,
    isVerified,
    verifiedByUserId,
    verifiedAt,
    createdAt,
  ];
}

class VerificationInclude extends _is.IncludeObject {
  VerificationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Verification.t;
}

class VerificationIncludeList extends _is.IncludeList {
  VerificationIncludeList._({
    _is.WhereExpressionBuilder<VerificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Verification.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Verification.t;
}

class VerificationRepository {
  const VerificationRepository._();

  /// Returns a list of [Verification]s matching the given query parameters.
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
  Future<List<Verification>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VerificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VerificationTable>? orderBy,
    _is.OrderByListBuilder<VerificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Verification>(
      where: where?.call(Verification.t),
      orderBy: orderBy?.call(Verification.t),
      orderByList: orderByList?.call(Verification.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Verification] matching the given query parameters.
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
  Future<Verification?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VerificationTable>? where,
    int? offset,
    _is.OrderByBuilder<VerificationTable>? orderBy,
    _is.OrderByListBuilder<VerificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Verification>(
      where: where?.call(Verification.t),
      orderBy: orderBy?.call(Verification.t),
      orderByList: orderByList?.call(Verification.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Verification] by its [id] or null if no such row exists.
  Future<Verification?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Verification>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Verification]s in the list and returns the inserted rows.
  ///
  /// The returned [Verification]s will have their `id` fields set.
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
  Future<List<Verification>> insert(
    _is.DatabaseSession session,
    List<Verification> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Verification>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Verification] and returns the inserted row.
  ///
  /// The returned [Verification] will have its `id` field set.
  Future<Verification> insertRow(
    _is.DatabaseSession session,
    Verification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Verification>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Verification]s in the list and returns the resulting rows.
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
  /// The returned [Verification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Verification>> upsert(
    _is.DatabaseSession session,
    List<Verification> rows, {
    required _is.ColumnSelections<VerificationTable> conflictColumns,
    _is.ColumnSelections<VerificationTable>? updateColumns,
    _is.WhereExpressionBuilder<VerificationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Verification>(
      rows,
      conflictColumns: conflictColumns(Verification.t),
      updateColumns: updateColumns?.call(Verification.t),
      updateWhere: updateWhere?.call(Verification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Verification] and returns the resulting row.
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
  /// The returned [Verification] will have its `id` field set.
  Future<Verification?> upsertRow(
    _is.DatabaseSession session,
    Verification row, {
    required _is.ColumnSelections<VerificationTable> conflictColumns,
    _is.ColumnSelections<VerificationTable>? updateColumns,
    _is.WhereExpressionBuilder<VerificationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Verification>(
      row,
      conflictColumns: conflictColumns(Verification.t),
      updateColumns: updateColumns?.call(Verification.t),
      updateWhere: updateWhere?.call(Verification.t),
      transaction: transaction,
    );
  }

  /// Updates all [Verification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Verification>> update(
    _is.DatabaseSession session,
    List<Verification> rows, {
    _is.ColumnSelections<VerificationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Verification>(
      rows,
      columns: columns?.call(Verification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Verification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Verification> updateRow(
    _is.DatabaseSession session,
    Verification row, {
    _is.ColumnSelections<VerificationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Verification>(
      row,
      columns: columns?.call(Verification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Verification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Verification?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<VerificationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Verification>(
      id,
      columnValues: columnValues(Verification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Verification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Verification>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<VerificationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<VerificationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VerificationTable>? orderBy,
    _is.OrderByListBuilder<VerificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Verification>(
      columnValues: columnValues(Verification.t.updateTable),
      where: where(Verification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Verification.t),
      orderByList: orderByList?.call(Verification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Verification]s in the list and returns the deleted rows.
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
  Future<List<Verification>> delete(
    _is.DatabaseSession session,
    List<Verification> rows, {
    _is.OrderByBuilder<VerificationTable>? orderBy,
    _is.OrderByListBuilder<VerificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Verification>(
      rows,
      orderBy: orderBy?.call(Verification.t),
      orderByList: orderByList?.call(Verification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Verification].
  Future<Verification> deleteRow(
    _is.DatabaseSession session,
    Verification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Verification>(
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
  Future<List<Verification>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VerificationTable> where,
    _is.OrderByBuilder<VerificationTable>? orderBy,
    _is.OrderByListBuilder<VerificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Verification>(
      where: where(Verification.t),
      orderBy: orderBy?.call(Verification.t),
      orderByList: orderByList?.call(Verification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VerificationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Verification>(
      where: where?.call(Verification.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Verification] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VerificationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Verification>(
      where: where(Verification.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
