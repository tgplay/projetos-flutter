import 'package:flutter/foundation.dart';
import '../database/app_database.dart';
import '../models/song.dart';

class SongProvider extends ChangeNotifier {
  final AppDatabase _db;
  List<Song> _songs = [];
  bool isLoading = true;
  String _query = '';

  SongProvider(this._db) {
    _load();
  }

  List<Song> get songs {
    if (_query.isEmpty) return _songs;
    final q = _query.toLowerCase();
    return _songs
        .where((s) =>
            s.title.toLowerCase().contains(q) ||
            s.artist.toLowerCase().contains(q))
        .toList();
  }

  void search(String query) {
    _query = query;
    notifyListeners();
  }

  Future<void> _load() async {
    isLoading = true;
    notifyListeners();
    _songs = await _db.getAllSongs();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addSong(Song song) async {
    await _db.insertSong(song);
    await _load();
  }

  Future<void> updateSong(Song song) async {
    await _db.updateSong(song);
    await _load();
  }

  Future<void> deleteSong(int id) async {
    await _db.deleteSong(id);
    await _load();
  }
}
