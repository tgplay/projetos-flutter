import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._();
  factory SoundService() => _instance;
  SoundService._();

  final AudioPlayer _player = AudioPlayer();

  /// Dois tons ascendentes — sensação de dinheiro entrando.
  Future<void> playIncome() async {
    try {
      await _player.play(BytesSource(_buildWav([
        _Tone(frequency: 700, duration: 0.10),
        _Tone(frequency: 950, duration: 0.16),
      ])));
    } catch (_) {}
  }

  /// Tom grave e curto — saída de dinheiro, discreto.
  Future<void> playExpense() async {
    try {
      await _player.play(BytesSource(_buildWav([
        _Tone(frequency: 330, duration: 0.09),
      ])));
    } catch (_) {}
  }

  /// Três tons ascendentes — som de moeda caindo no cofre.
  Future<void> playReserveContribution() async {
    try {
      await _player.play(BytesSource(_buildWav([
        _Tone(frequency: 550, duration: 0.09),
        _Tone(frequency: 700, duration: 0.09),
        _Tone(frequency: 880, duration: 0.14),
      ])));
    } catch (_) {}
  }

  /// Melodia comemorativa — meta de reserva atingida.
  Future<void> playReserveGoalReached() async {
    try {
      await _player.play(BytesSource(_buildWav([
        _Tone(frequency: 523, duration: 0.12), // C5
        _Tone(frequency: 659, duration: 0.12), // E5
        _Tone(frequency: 784, duration: 0.12), // G5
        _Tone(frequency: 1047, duration: 0.28), // C6
      ])));
    } catch (_) {}
  }

  Uint8List _buildWav(List<_Tone> tones) {
    const sampleRate = 44100;
    const amplitude = 0.45;
    const gapSamples = 882; // ~20 ms de silêncio entre notas

    int totalSamples = 0;
    for (final t in tones) {
      totalSamples += (sampleRate * t.duration).round();
    }
    if (tones.length > 1) totalSamples += gapSamples * (tones.length - 1);

    final dataSize = totalSamples * 2; // 16-bit mono
    final buf = ByteData(44 + dataSize);
    _writeHeader(buf, sampleRate, dataSize);

    int offset = 44;
    for (int t = 0; t < tones.length; t++) {
      final tone = tones[t];
      final n = (sampleRate * tone.duration).round();
      final fadeIn = n ~/ 8;
      final fadeOut = n ~/ 4;

      for (int i = 0; i < n; i++) {
        double env = 1.0;
        if (i < fadeIn) {
          env = i / fadeIn;
        } else if (i > n - fadeOut) {
          env = (n - i) / fadeOut;
        }
        final raw = amplitude * env * sin(2 * pi * tone.frequency * i / sampleRate);
        buf.setInt16(offset, (raw * 32767).round().clamp(-32768, 32767), Endian.little);
        offset += 2;
      }

      if (t < tones.length - 1) {
        for (int i = 0; i < gapSamples; i++) {
          buf.setInt16(offset, 0, Endian.little);
          offset += 2;
        }
      }
    }

    return buf.buffer.asUint8List();
  }

  void _writeHeader(ByteData b, int sampleRate, int dataSize) {
    // RIFF chunk
    b.setUint8(0, 0x52); b.setUint8(1, 0x49); b.setUint8(2, 0x46); b.setUint8(3, 0x46);
    b.setUint32(4, 36 + dataSize, Endian.little);
    b.setUint8(8, 0x57); b.setUint8(9, 0x41); b.setUint8(10, 0x56); b.setUint8(11, 0x45);
    // fmt chunk
    b.setUint8(12, 0x66); b.setUint8(13, 0x6D); b.setUint8(14, 0x74); b.setUint8(15, 0x20);
    b.setUint32(16, 16, Endian.little);
    b.setUint16(20, 1, Endian.little); // PCM
    b.setUint16(22, 1, Endian.little); // mono
    b.setUint32(24, sampleRate, Endian.little);
    b.setUint32(28, sampleRate * 2, Endian.little); // byte rate
    b.setUint16(32, 2, Endian.little); // block align
    b.setUint16(34, 16, Endian.little); // bits per sample
    // data chunk
    b.setUint8(36, 0x64); b.setUint8(37, 0x61); b.setUint8(38, 0x74); b.setUint8(39, 0x61);
    b.setUint32(40, dataSize, Endian.little);
  }
}

class _Tone {
  final double frequency;
  final double duration;
  const _Tone({required this.frequency, required this.duration});
}
