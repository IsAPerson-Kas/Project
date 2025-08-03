// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GuardAlbumsTable extends GuardAlbums
    with TableInfo<$GuardAlbumsTable, GuardAlbum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuardAlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileThumbailPathMeta = const VerificationMeta(
    'fileThumbailPath',
  );
  @override
  late final GeneratedColumn<String> fileThumbailPath = GeneratedColumn<String>(
    'file_thumbail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    password,
    fileThumbailPath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guard_albums';
  @override
  VerificationContext validateIntegrity(
    Insertable<GuardAlbum> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('file_thumbail_path')) {
      context.handle(
        _fileThumbailPathMeta,
        fileThumbailPath.isAcceptableOrUnknown(
          data['file_thumbail_path']!,
          _fileThumbailPathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuardAlbum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuardAlbum(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      fileThumbailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_thumbail_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GuardAlbumsTable createAlias(String alias) {
    return $GuardAlbumsTable(attachedDatabase, alias);
  }
}

class GuardAlbum extends DataClass implements Insertable<GuardAlbum> {
  final int id;
  final String name;
  final String? password;
  final String? fileThumbailPath;
  final DateTime createdAt;
  const GuardAlbum({
    required this.id,
    required this.name,
    this.password,
    this.fileThumbailPath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || fileThumbailPath != null) {
      map['file_thumbail_path'] = Variable<String>(fileThumbailPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GuardAlbumsCompanion toCompanion(bool nullToAbsent) {
    return GuardAlbumsCompanion(
      id: Value(id),
      name: Value(name),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      fileThumbailPath: fileThumbailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fileThumbailPath),
      createdAt: Value(createdAt),
    );
  }

  factory GuardAlbum.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuardAlbum(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      password: serializer.fromJson<String?>(json['password']),
      fileThumbailPath: serializer.fromJson<String?>(json['fileThumbailPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'password': serializer.toJson<String?>(password),
      'fileThumbailPath': serializer.toJson<String?>(fileThumbailPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GuardAlbum copyWith({
    int? id,
    String? name,
    Value<String?> password = const Value.absent(),
    Value<String?> fileThumbailPath = const Value.absent(),
    DateTime? createdAt,
  }) => GuardAlbum(
    id: id ?? this.id,
    name: name ?? this.name,
    password: password.present ? password.value : this.password,
    fileThumbailPath: fileThumbailPath.present
        ? fileThumbailPath.value
        : this.fileThumbailPath,
    createdAt: createdAt ?? this.createdAt,
  );
  GuardAlbum copyWithCompanion(GuardAlbumsCompanion data) {
    return GuardAlbum(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      password: data.password.present ? data.password.value : this.password,
      fileThumbailPath: data.fileThumbailPath.present
          ? data.fileThumbailPath.value
          : this.fileThumbailPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuardAlbum(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('fileThumbailPath: $fileThumbailPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, password, fileThumbailPath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuardAlbum &&
          other.id == this.id &&
          other.name == this.name &&
          other.password == this.password &&
          other.fileThumbailPath == this.fileThumbailPath &&
          other.createdAt == this.createdAt);
}

class GuardAlbumsCompanion extends UpdateCompanion<GuardAlbum> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> password;
  final Value<String?> fileThumbailPath;
  final Value<DateTime> createdAt;
  const GuardAlbumsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.password = const Value.absent(),
    this.fileThumbailPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GuardAlbumsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.password = const Value.absent(),
    this.fileThumbailPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<GuardAlbum> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? password,
    Expression<String>? fileThumbailPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (password != null) 'password': password,
      if (fileThumbailPath != null) 'file_thumbail_path': fileThumbailPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GuardAlbumsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? password,
    Value<String?>? fileThumbailPath,
    Value<DateTime>? createdAt,
  }) {
    return GuardAlbumsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      fileThumbailPath: fileThumbailPath ?? this.fileThumbailPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (fileThumbailPath.present) {
      map['file_thumbail_path'] = Variable<String>(fileThumbailPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuardAlbumsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('fileThumbailPath: $fileThumbailPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GuardFilesTable extends GuardFiles
    with TableInfo<$GuardFilesTable, GuardFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuardFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _albumIdMeta = const VerificationMeta(
    'albumId',
  );
  @override
  late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
    'album_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES guard_albums (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    albumId,
    filePath,
    createdAt,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guard_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<GuardFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('album_id')) {
      context.handle(
        _albumIdMeta,
        albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
      );
    } else if (isInserting) {
      context.missing(_albumIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuardFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuardFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}album_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $GuardFilesTable createAlias(String alias) {
    return $GuardFilesTable(attachedDatabase, alias);
  }
}

class GuardFile extends DataClass implements Insertable<GuardFile> {
  final int id;
  final int albumId;
  final String filePath;
  final DateTime createdAt;
  final int type;
  const GuardFile({
    required this.id,
    required this.albumId,
    required this.filePath,
    required this.createdAt,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['album_id'] = Variable<int>(albumId);
    map['file_path'] = Variable<String>(filePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['type'] = Variable<int>(type);
    return map;
  }

  GuardFilesCompanion toCompanion(bool nullToAbsent) {
    return GuardFilesCompanion(
      id: Value(id),
      albumId: Value(albumId),
      filePath: Value(filePath),
      createdAt: Value(createdAt),
      type: Value(type),
    );
  }

  factory GuardFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuardFile(
      id: serializer.fromJson<int>(json['id']),
      albumId: serializer.fromJson<int>(json['albumId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      type: serializer.fromJson<int>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'albumId': serializer.toJson<int>(albumId),
      'filePath': serializer.toJson<String>(filePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'type': serializer.toJson<int>(type),
    };
  }

  GuardFile copyWith({
    int? id,
    int? albumId,
    String? filePath,
    DateTime? createdAt,
    int? type,
  }) => GuardFile(
    id: id ?? this.id,
    albumId: albumId ?? this.albumId,
    filePath: filePath ?? this.filePath,
    createdAt: createdAt ?? this.createdAt,
    type: type ?? this.type,
  );
  GuardFile copyWithCompanion(GuardFilesCompanion data) {
    return GuardFile(
      id: data.id.present ? data.id.value : this.id,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuardFile(')
          ..write('id: $id, ')
          ..write('albumId: $albumId, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, albumId, filePath, createdAt, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuardFile &&
          other.id == this.id &&
          other.albumId == this.albumId &&
          other.filePath == this.filePath &&
          other.createdAt == this.createdAt &&
          other.type == this.type);
}

class GuardFilesCompanion extends UpdateCompanion<GuardFile> {
  final Value<int> id;
  final Value<int> albumId;
  final Value<String> filePath;
  final Value<DateTime> createdAt;
  final Value<int> type;
  const GuardFilesCompanion({
    this.id = const Value.absent(),
    this.albumId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.type = const Value.absent(),
  });
  GuardFilesCompanion.insert({
    this.id = const Value.absent(),
    required int albumId,
    required String filePath,
    this.createdAt = const Value.absent(),
    required int type,
  }) : albumId = Value(albumId),
       filePath = Value(filePath),
       type = Value(type);
  static Insertable<GuardFile> custom({
    Expression<int>? id,
    Expression<int>? albumId,
    Expression<String>? filePath,
    Expression<DateTime>? createdAt,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (albumId != null) 'album_id': albumId,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
      if (type != null) 'type': type,
    });
  }

  GuardFilesCompanion copyWith({
    Value<int>? id,
    Value<int>? albumId,
    Value<String>? filePath,
    Value<DateTime>? createdAt,
    Value<int>? type,
  }) {
    return GuardFilesCompanion(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<int>(albumId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuardFilesCompanion(')
          ..write('id: $id, ')
          ..write('albumId: $albumId, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GuardAlbumsTable guardAlbums = $GuardAlbumsTable(this);
  late final $GuardFilesTable guardFiles = $GuardFilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [guardAlbums, guardFiles];
}

typedef $$GuardAlbumsTableCreateCompanionBuilder =
    GuardAlbumsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> password,
      Value<String?> fileThumbailPath,
      Value<DateTime> createdAt,
    });
typedef $$GuardAlbumsTableUpdateCompanionBuilder =
    GuardAlbumsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> password,
      Value<String?> fileThumbailPath,
      Value<DateTime> createdAt,
    });

final class $$GuardAlbumsTableReferences
    extends BaseReferences<_$AppDatabase, $GuardAlbumsTable, GuardAlbum> {
  $$GuardAlbumsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GuardFilesTable, List<GuardFile>>
  _guardFilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.guardFiles,
    aliasName: $_aliasNameGenerator(db.guardAlbums.id, db.guardFiles.albumId),
  );

  $$GuardFilesTableProcessedTableManager get guardFilesRefs {
    final manager = $$GuardFilesTableTableManager(
      $_db,
      $_db.guardFiles,
    ).filter((f) => f.albumId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_guardFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GuardAlbumsTableFilterComposer
    extends Composer<_$AppDatabase, $GuardAlbumsTable> {
  $$GuardAlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileThumbailPath => $composableBuilder(
    column: $table.fileThumbailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> guardFilesRefs(
    Expression<bool> Function($$GuardFilesTableFilterComposer f) f,
  ) {
    final $$GuardFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.guardFiles,
      getReferencedColumn: (t) => t.albumId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuardFilesTableFilterComposer(
            $db: $db,
            $table: $db.guardFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GuardAlbumsTableOrderingComposer
    extends Composer<_$AppDatabase, $GuardAlbumsTable> {
  $$GuardAlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileThumbailPath => $composableBuilder(
    column: $table.fileThumbailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GuardAlbumsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuardAlbumsTable> {
  $$GuardAlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get fileThumbailPath => $composableBuilder(
    column: $table.fileThumbailPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> guardFilesRefs<T extends Object>(
    Expression<T> Function($$GuardFilesTableAnnotationComposer a) f,
  ) {
    final $$GuardFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.guardFiles,
      getReferencedColumn: (t) => t.albumId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuardFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.guardFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GuardAlbumsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GuardAlbumsTable,
          GuardAlbum,
          $$GuardAlbumsTableFilterComposer,
          $$GuardAlbumsTableOrderingComposer,
          $$GuardAlbumsTableAnnotationComposer,
          $$GuardAlbumsTableCreateCompanionBuilder,
          $$GuardAlbumsTableUpdateCompanionBuilder,
          (GuardAlbum, $$GuardAlbumsTableReferences),
          GuardAlbum,
          PrefetchHooks Function({bool guardFilesRefs})
        > {
  $$GuardAlbumsTableTableManager(_$AppDatabase db, $GuardAlbumsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuardAlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuardAlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuardAlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<String?> fileThumbailPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GuardAlbumsCompanion(
                id: id,
                name: name,
                password: password,
                fileThumbailPath: fileThumbailPath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> password = const Value.absent(),
                Value<String?> fileThumbailPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GuardAlbumsCompanion.insert(
                id: id,
                name: name,
                password: password,
                fileThumbailPath: fileThumbailPath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GuardAlbumsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({guardFilesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (guardFilesRefs) db.guardFiles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (guardFilesRefs)
                    await $_getPrefetchedData<
                      GuardAlbum,
                      $GuardAlbumsTable,
                      GuardFile
                    >(
                      currentTable: table,
                      referencedTable: $$GuardAlbumsTableReferences
                          ._guardFilesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GuardAlbumsTableReferences(
                            db,
                            table,
                            p0,
                          ).guardFilesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.albumId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GuardAlbumsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GuardAlbumsTable,
      GuardAlbum,
      $$GuardAlbumsTableFilterComposer,
      $$GuardAlbumsTableOrderingComposer,
      $$GuardAlbumsTableAnnotationComposer,
      $$GuardAlbumsTableCreateCompanionBuilder,
      $$GuardAlbumsTableUpdateCompanionBuilder,
      (GuardAlbum, $$GuardAlbumsTableReferences),
      GuardAlbum,
      PrefetchHooks Function({bool guardFilesRefs})
    >;
typedef $$GuardFilesTableCreateCompanionBuilder =
    GuardFilesCompanion Function({
      Value<int> id,
      required int albumId,
      required String filePath,
      Value<DateTime> createdAt,
      required int type,
    });
typedef $$GuardFilesTableUpdateCompanionBuilder =
    GuardFilesCompanion Function({
      Value<int> id,
      Value<int> albumId,
      Value<String> filePath,
      Value<DateTime> createdAt,
      Value<int> type,
    });

final class $$GuardFilesTableReferences
    extends BaseReferences<_$AppDatabase, $GuardFilesTable, GuardFile> {
  $$GuardFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GuardAlbumsTable _albumIdTable(_$AppDatabase db) =>
      db.guardAlbums.createAlias(
        $_aliasNameGenerator(db.guardFiles.albumId, db.guardAlbums.id),
      );

  $$GuardAlbumsTableProcessedTableManager get albumId {
    final $_column = $_itemColumn<int>('album_id')!;

    final manager = $$GuardAlbumsTableTableManager(
      $_db,
      $_db.guardAlbums,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_albumIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GuardFilesTableFilterComposer
    extends Composer<_$AppDatabase, $GuardFilesTable> {
  $$GuardFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  $$GuardAlbumsTableFilterComposer get albumId {
    final $$GuardAlbumsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.guardAlbums,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuardAlbumsTableFilterComposer(
            $db: $db,
            $table: $db.guardAlbums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GuardFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $GuardFilesTable> {
  $$GuardFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  $$GuardAlbumsTableOrderingComposer get albumId {
    final $$GuardAlbumsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.guardAlbums,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuardAlbumsTableOrderingComposer(
            $db: $db,
            $table: $db.guardAlbums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GuardFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuardFilesTable> {
  $$GuardFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $$GuardAlbumsTableAnnotationComposer get albumId {
    final $$GuardAlbumsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.guardAlbums,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuardAlbumsTableAnnotationComposer(
            $db: $db,
            $table: $db.guardAlbums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GuardFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GuardFilesTable,
          GuardFile,
          $$GuardFilesTableFilterComposer,
          $$GuardFilesTableOrderingComposer,
          $$GuardFilesTableAnnotationComposer,
          $$GuardFilesTableCreateCompanionBuilder,
          $$GuardFilesTableUpdateCompanionBuilder,
          (GuardFile, $$GuardFilesTableReferences),
          GuardFile,
          PrefetchHooks Function({bool albumId})
        > {
  $$GuardFilesTableTableManager(_$AppDatabase db, $GuardFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuardFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuardFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuardFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> albumId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> type = const Value.absent(),
              }) => GuardFilesCompanion(
                id: id,
                albumId: albumId,
                filePath: filePath,
                createdAt: createdAt,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int albumId,
                required String filePath,
                Value<DateTime> createdAt = const Value.absent(),
                required int type,
              }) => GuardFilesCompanion.insert(
                id: id,
                albumId: albumId,
                filePath: filePath,
                createdAt: createdAt,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GuardFilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({albumId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (albumId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.albumId,
                                referencedTable: $$GuardFilesTableReferences
                                    ._albumIdTable(db),
                                referencedColumn: $$GuardFilesTableReferences
                                    ._albumIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GuardFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GuardFilesTable,
      GuardFile,
      $$GuardFilesTableFilterComposer,
      $$GuardFilesTableOrderingComposer,
      $$GuardFilesTableAnnotationComposer,
      $$GuardFilesTableCreateCompanionBuilder,
      $$GuardFilesTableUpdateCompanionBuilder,
      (GuardFile, $$GuardFilesTableReferences),
      GuardFile,
      PrefetchHooks Function({bool albumId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GuardAlbumsTableTableManager get guardAlbums =>
      $$GuardAlbumsTableTableManager(_db, _db.guardAlbums);
  $$GuardFilesTableTableManager get guardFiles =>
      $$GuardFilesTableTableManager(_db, _db.guardFiles);
}
