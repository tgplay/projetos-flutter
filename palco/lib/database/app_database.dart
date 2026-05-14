import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../models/song.dart';
import '../data/mock_songs.dart';

part 'app_database.g.dart';

@DataClassName('SongRecord')
class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get artist => text()();
  TextColumn get originalKey => text()();
  IntColumn get bpm => integer()();
  TextColumn get chordSheet => text()();
}

@DriftDatabase(tables: [Songs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'palco_db'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          for (final s in mockSongs) {
            await into(songs).insert(SongsCompanion.insert(
              title: s.title,
              artist: s.artist,
              originalKey: s.originalKey,
              bpm: s.bpm,
              chordSheet: s.chordSheet,
            ));
          }
        },
      );

  Future<List<Song>> getAllSongs() async {
    final rows = await (select(songs)
          ..orderBy([(s) => OrderingTerm.asc(s.title)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<Song> insertSong(Song song) async {
    final newId = await into(songs).insert(SongsCompanion.insert(
      title: song.title,
      artist: song.artist,
      originalKey: song.originalKey,
      bpm: song.bpm,
      chordSheet: song.chordSheet,
    ));
    return song.copyWith(id: newId);
  }

  Future<void> updateSong(Song song) async {
    await (update(songs)..where((s) => s.id.equals(song.id))).write(
      SongsCompanion(
        title: Value(song.title),
        artist: Value(song.artist),
        originalKey: Value(song.originalKey),
        bpm: Value(song.bpm),
        chordSheet: Value(song.chordSheet),
      ),
    );
  }

  Future<void> deleteSong(int id) async {
    await (delete(songs)..where((s) => s.id.equals(id))).go();
  }

  Song _toModel(SongRecord r) => Song(
        id: r.id,
        title: r.title,
        artist: r.artist,
        originalKey: r.originalKey,
        bpm: r.bpm,
        chordSheet: r.chordSheet,
      );
}
