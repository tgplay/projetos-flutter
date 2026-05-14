class Song {
  final int id;
  final String title;
  final String artist;
  final String originalKey;
  final int bpm;
  final String chordSheet;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.originalKey,
    required this.bpm,
    required this.chordSheet,
  });

  Song copyWith({
    int? id,
    String? title,
    String? artist,
    String? originalKey,
    int? bpm,
    String? chordSheet,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      originalKey: originalKey ?? this.originalKey,
      bpm: bpm ?? this.bpm,
      chordSheet: chordSheet ?? this.chordSheet,
    );
  }
}
