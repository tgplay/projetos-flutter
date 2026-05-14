import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/song.dart';
import '../models/performance_settings.dart';
import '../models/chord_transposer.dart';

class PerformanceProvider extends ChangeNotifier {
  Song? _currentSong;
  PerformanceSettings _settings = const PerformanceSettings();

  Song? get currentSong => _currentSong;
  PerformanceSettings get settings => _settings;

  String get currentKey => _currentSong == null
      ? ''
      : ChordTransposer.getTransposedKey(
          _currentSong!.originalKey, _settings.transposeSteps);

  String get transposedSheet => _currentSong == null
      ? ''
      : ChordTransposer.transposeSheet(
          _currentSong!.chordSheet, _settings.transposeSteps);

  void loadSong(Song song) {
    _currentSong = song;
    _settings = const PerformanceSettings();
    notifyListeners();
  }

  void transpose(int delta) {
    final steps = (_settings.transposeSteps + delta).clamp(-6, 6);
    _settings = _settings.copyWith(transposeSteps: steps);
    notifyListeners();
  }

  void setCapo(int capo) {
    _settings = _settings.copyWith(capo: capo.clamp(0, 11));
    notifyListeners();
  }

  void setFontSize(double size) {
    _settings = _settings.copyWith(fontSize: size.clamp(12.0, 32.0));
    notifyListeners();
  }

  void setScrollSpeed(double speed) {
    _settings = _settings.copyWith(scrollSpeed: speed);
    notifyListeners();
  }

  void toggleAutoScroll() {
    _settings = _settings.copyWith(autoScroll: !_settings.autoScroll);
    notifyListeners();
  }

  void startPerformance() => WakelockPlus.enable();

  void endPerformance() => WakelockPlus.disable();
}
