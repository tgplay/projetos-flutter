class ChordTransposer {
  static const _sharps = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  static const _flats  = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B'];

  static String transposeSheet(String sheet, int semitones) {
    if (semitones == 0) return sheet;
    return sheet.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]'),
      (m) => '[${transposeChord(m.group(1)!, semitones)}]',
    );
  }

  static String transposeChord(String chord, int semitones) {
    final match = RegExp(r'^([A-G][b#]?)(.*)$').firstMatch(chord);
    if (match == null) return chord;
    final root = match.group(1)!;
    final suffix = match.group(2)!;
    final idx = _findNoteIndex(root);
    if (idx == -1) return chord;
    final newIdx = ((idx + semitones) % 12 + 12) % 12;
    final useFlats = root.contains('b') || semitones < 0;
    return '${useFlats ? _flats[newIdx] : _sharps[newIdx]}$suffix';
  }

  static String getTransposedKey(String originalKey, int semitones) {
    return transposeChord(originalKey, semitones);
  }

  static int _findNoteIndex(String note) {
    final i = _sharps.indexOf(note);
    return i != -1 ? i : _flats.indexOf(note);
  }
}
