// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SongsTable extends Songs with TableInfo<$SongsTable, SongRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalKeyMeta =
      const VerificationMeta('originalKey');
  @override
  late final GeneratedColumn<String> originalKey = GeneratedColumn<String>(
      'original_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bpmMeta = const VerificationMeta('bpm');
  @override
  late final GeneratedColumn<int> bpm = GeneratedColumn<int>(
      'bpm', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chordSheetMeta =
      const VerificationMeta('chordSheet');
  @override
  late final GeneratedColumn<String> chordSheet = GeneratedColumn<String>(
      'chord_sheet', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, artist, originalKey, bpm, chordSheet];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(Insertable<SongRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('original_key')) {
      context.handle(
          _originalKeyMeta,
          originalKey.isAcceptableOrUnknown(
              data['original_key']!, _originalKeyMeta));
    } else if (isInserting) {
      context.missing(_originalKeyMeta);
    }
    if (data.containsKey('bpm')) {
      context.handle(
          _bpmMeta, bpm.isAcceptableOrUnknown(data['bpm']!, _bpmMeta));
    } else if (isInserting) {
      context.missing(_bpmMeta);
    }
    if (data.containsKey('chord_sheet')) {
      context.handle(
          _chordSheetMeta,
          chordSheet.isAcceptableOrUnknown(
              data['chord_sheet']!, _chordSheetMeta));
    } else if (isInserting) {
      context.missing(_chordSheetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SongRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist'])!,
      originalKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_key'])!,
      bpm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bpm'])!,
      chordSheet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chord_sheet'])!,
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class SongRecord extends DataClass implements Insertable<SongRecord> {
  final int id;
  final String title;
  final String artist;
  final String originalKey;
  final int bpm;
  final String chordSheet;
  const SongRecord(
      {required this.id,
      required this.title,
      required this.artist,
      required this.originalKey,
      required this.bpm,
      required this.chordSheet});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['artist'] = Variable<String>(artist);
    map['original_key'] = Variable<String>(originalKey);
    map['bpm'] = Variable<int>(bpm);
    map['chord_sheet'] = Variable<String>(chordSheet);
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      title: Value(title),
      artist: Value(artist),
      originalKey: Value(originalKey),
      bpm: Value(bpm),
      chordSheet: Value(chordSheet),
    );
  }

  factory SongRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongRecord(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      originalKey: serializer.fromJson<String>(json['originalKey']),
      bpm: serializer.fromJson<int>(json['bpm']),
      chordSheet: serializer.fromJson<String>(json['chordSheet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'originalKey': serializer.toJson<String>(originalKey),
      'bpm': serializer.toJson<int>(bpm),
      'chordSheet': serializer.toJson<String>(chordSheet),
    };
  }

  SongRecord copyWith(
          {int? id,
          String? title,
          String? artist,
          String? originalKey,
          int? bpm,
          String? chordSheet}) =>
      SongRecord(
        id: id ?? this.id,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        originalKey: originalKey ?? this.originalKey,
        bpm: bpm ?? this.bpm,
        chordSheet: chordSheet ?? this.chordSheet,
      );
  SongRecord copyWithCompanion(SongsCompanion data) {
    return SongRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      originalKey:
          data.originalKey.present ? data.originalKey.value : this.originalKey,
      bpm: data.bpm.present ? data.bpm.value : this.bpm,
      chordSheet:
          data.chordSheet.present ? data.chordSheet.value : this.chordSheet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('originalKey: $originalKey, ')
          ..write('bpm: $bpm, ')
          ..write('chordSheet: $chordSheet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, artist, originalKey, bpm, chordSheet);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.originalKey == this.originalKey &&
          other.bpm == this.bpm &&
          other.chordSheet == this.chordSheet);
}

class SongsCompanion extends UpdateCompanion<SongRecord> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> artist;
  final Value<String> originalKey;
  final Value<int> bpm;
  final Value<String> chordSheet;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.originalKey = const Value.absent(),
    this.bpm = const Value.absent(),
    this.chordSheet = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String artist,
    required String originalKey,
    required int bpm,
    required String chordSheet,
  })  : title = Value(title),
        artist = Value(artist),
        originalKey = Value(originalKey),
        bpm = Value(bpm),
        chordSheet = Value(chordSheet);
  static Insertable<SongRecord> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? originalKey,
    Expression<int>? bpm,
    Expression<String>? chordSheet,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (originalKey != null) 'original_key': originalKey,
      if (bpm != null) 'bpm': bpm,
      if (chordSheet != null) 'chord_sheet': chordSheet,
    });
  }

  SongsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? artist,
      Value<String>? originalKey,
      Value<int>? bpm,
      Value<String>? chordSheet}) {
    return SongsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      originalKey: originalKey ?? this.originalKey,
      bpm: bpm ?? this.bpm,
      chordSheet: chordSheet ?? this.chordSheet,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (originalKey.present) {
      map['original_key'] = Variable<String>(originalKey.value);
    }
    if (bpm.present) {
      map['bpm'] = Variable<int>(bpm.value);
    }
    if (chordSheet.present) {
      map['chord_sheet'] = Variable<String>(chordSheet.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('originalKey: $originalKey, ')
          ..write('bpm: $bpm, ')
          ..write('chordSheet: $chordSheet')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTable songs = $SongsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [songs];
}

typedef $$SongsTableCreateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  required String title,
  required String artist,
  required String originalKey,
  required int bpm,
  required String chordSheet,
});
typedef $$SongsTableUpdateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> artist,
  Value<String> originalKey,
  Value<int> bpm,
  Value<String> chordSheet,
});

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalKey => $composableBuilder(
      column: $table.originalKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bpm => $composableBuilder(
      column: $table.bpm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chordSheet => $composableBuilder(
      column: $table.chordSheet, builder: (column) => ColumnFilters(column));
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalKey => $composableBuilder(
      column: $table.originalKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bpm => $composableBuilder(
      column: $table.bpm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chordSheet => $composableBuilder(
      column: $table.chordSheet, builder: (column) => ColumnOrderings(column));
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get originalKey => $composableBuilder(
      column: $table.originalKey, builder: (column) => column);

  GeneratedColumn<int> get bpm =>
      $composableBuilder(column: $table.bpm, builder: (column) => column);

  GeneratedColumn<String> get chordSheet => $composableBuilder(
      column: $table.chordSheet, builder: (column) => column);
}

class $$SongsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SongsTable,
    SongRecord,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (SongRecord, BaseReferences<_$AppDatabase, $SongsTable, SongRecord>),
    SongRecord,
    PrefetchHooks Function()> {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> artist = const Value.absent(),
            Value<String> originalKey = const Value.absent(),
            Value<int> bpm = const Value.absent(),
            Value<String> chordSheet = const Value.absent(),
          }) =>
              SongsCompanion(
            id: id,
            title: title,
            artist: artist,
            originalKey: originalKey,
            bpm: bpm,
            chordSheet: chordSheet,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String artist,
            required String originalKey,
            required int bpm,
            required String chordSheet,
          }) =>
              SongsCompanion.insert(
            id: id,
            title: title,
            artist: artist,
            originalKey: originalKey,
            bpm: bpm,
            chordSheet: chordSheet,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SongsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SongsTable,
    SongRecord,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (SongRecord, BaseReferences<_$AppDatabase, $SongsTable, SongRecord>),
    SongRecord,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
}
