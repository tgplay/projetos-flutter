import 'package:flutter/material.dart';

// ── Model ───────────────────────────────────────────────────────────────────
// frets: 6 valores — corda 6 (Mi grave/E) até corda 1 (Mi agudo/e)
// -1 = corda abafada (X), 0 = corda solta, 1..N = casa (relativa ao baseFret)
// fingers: dedo usado por corda (1=indicador,2=médio,3=anelar,4=mindinho)
//          0 = nenhum / parte da pestana (não exibe número)
// barre: true = tem pestana; barreString = índice (0=E grave) onde a pestana começa
// baseFret: casa real no braço onde o diagrama começa

class ChordVariant {
  final List<int> frets;
  final List<int> fingers;
  final int baseFret;
  final bool barre;
  final int barreString;
  final String? label;

  const ChordVariant({
    required this.frets,
    this.fingers = const [0, 0, 0, 0, 0, 0],
    this.baseFret = 1,
    this.barre = false,
    this.barreString = 0,
    this.label,
  });

  bool get isOpen => baseFret == 1 && !barre;
}

class ChordData {
  final String name;
  final List<ChordVariant> variants;
  const ChordData({required this.name, required this.variants});
}

// ── Banco de acordes ────────────────────────────────────────────────────────
// Referência: posições padrão de violão/guitarra verificadas
// Ordem das cordas: E2 A2 D3 G3 B3 e4  (grave → agudo, índices 0→5)

const Map<String, ChordData> chordDatabase = {
  // ══════════ MAIORES ══════════

  'C': ChordData(name: 'C', variants: [
    ChordVariant(
      frets: [-1, 3, 2, 0, 1, 0],
      fingers: [0, 3, 2, 0, 1, 0],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma E, pestana 8ª casa
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 8, barre: true, barreString: 0,
      label: 'Pestana 8ª casa',
    ),
  ]),

  'D': ChordData(name: 'D', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 2, 3, 2],
      fingers: [0, 0, 0, 1, 3, 2],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma A, pestana 5ª casa
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 0, 0, 0, 0],
      baseFret: 5, barre: true, barreString: 1,
      label: 'Pestana 5ª casa',
    ),
  ]),

  'E': ChordData(name: 'E', variants: [
    ChordVariant(
      frets: [0, 2, 2, 1, 0, 0],
      fingers: [0, 2, 3, 1, 0, 0],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma E, pestana 12ª (oitava)
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 12, barre: true, barreString: 0,
      label: 'Pestana 12ª casa',
    ),
  ]),

  'F': ChordData(name: 'F', variants: [
    ChordVariant(
      // forma E, pestana 1ª
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 1, barre: true, barreString: 0,
      label: 'Pestana 1ª casa',
    ),
    ChordVariant(
      // meia pestana nas 4 cordas agudas
      frets: [-1, -1, 3, 2, 1, 1],
      fingers: [0, 0, 4, 3, 0, 0],
      baseFret: 1, barre: true, barreString: 2,
      label: 'Meia pestana (fácil)',
    ),
  ]),

  'G': ChordData(name: 'G', variants: [
    ChordVariant(
      frets: [3, 2, 0, 0, 0, 3],
      fingers: [2, 1, 0, 0, 0, 3],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma E, pestana 3ª
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 3, barre: true, barreString: 0,
      label: 'Pestana 3ª casa',
    ),
  ]),

  'A': ChordData(name: 'A', variants: [
    ChordVariant(
      frets: [-1, 0, 2, 2, 2, 0],
      fingers: [0, 0, 1, 2, 3, 0],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma E, pestana 5ª
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 5, barre: true, barreString: 0,
      label: 'Pestana 5ª casa',
    ),
  ]),

  'B': ChordData(name: 'B', variants: [
    ChordVariant(
      // forma A, pestana 2ª
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 2, barre: true, barreString: 1,
      label: 'Pestana 2ª casa',
    ),
    ChordVariant(
      // forma E, pestana 7ª
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 7, barre: true, barreString: 0,
      label: 'Pestana 7ª casa',
    ),
  ]),

  'Bb': ChordData(name: 'Bb', variants: [
    ChordVariant(
      // forma A, pestana 1ª
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 1, barre: true, barreString: 1,
      label: 'Pestana 1ª casa',
    ),
    ChordVariant(
      // forma E, pestana 6ª
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 6, barre: true, barreString: 0,
      label: 'Pestana 6ª casa',
    ),
  ]),

  'A#': ChordData(name: 'A#', variants: [
    ChordVariant(
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 1,
      barre: true,
      barreString: 1,
      label: 'Pestana 1ª casa',
    ),
  ]),

  'C#': ChordData(name: 'C#', variants: [
    ChordVariant(
      // forma A, pestana 4ª
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 4, barre: true, barreString: 1,
      label: 'Pestana 4ª casa',
    ),
    ChordVariant(
      // forma E, pestana 9ª
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 9, barre: true, barreString: 0,
      label: 'Pestana 9ª casa',
    ),
  ]),

  'Db': ChordData(name: 'Db', variants: [
    ChordVariant(
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 4,
      barre: true,
      barreString: 1,
      label: 'Pestana 4ª casa',
    ),
  ]),

  'D#': ChordData(name: 'D#', variants: [
    ChordVariant(
      // forma A, pestana 6ª
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 6, barre: true, barreString: 1,
      label: 'Pestana 6ª casa',
    ),
  ]),

  'Eb': ChordData(name: 'Eb', variants: [
    ChordVariant(
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 6,
      barre: true,
      barreString: 1,
      label: 'Pestana 6ª casa',
    ),
  ]),

  'F#': ChordData(name: 'F#', variants: [
    ChordVariant(
      // forma E, pestana 2ª
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 2, barre: true, barreString: 0,
      label: 'Pestana 2ª casa',
    ),
    ChordVariant(
      // forma A, pestana 9ª
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 9, barre: true, barreString: 1,
      label: 'Pestana 9ª casa',
    ),
  ]),

  'Gb': ChordData(name: 'Gb', variants: [
    ChordVariant(
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 2,
      barre: true,
      barreString: 0,
      label: 'Pestana 2ª casa',
    ),
  ]),

  'G#': ChordData(name: 'G#', variants: [
    ChordVariant(
      // forma E, pestana 4ª
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 4, barre: true, barreString: 0,
      label: 'Pestana 4ª casa',
    ),
  ]),

  'Ab': ChordData(name: 'Ab', variants: [
    ChordVariant(
      frets: [1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 4,
      barre: true,
      barreString: 0,
      label: 'Pestana 4ª casa',
    ),
  ]),

  // ══════════ MENORES ══════════

  'Am': ChordData(name: 'Am', variants: [
    ChordVariant(
      frets: [-1, 0, 2, 2, 1, 0],
      fingers: [0, 0, 2, 3, 1, 0],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma Em transposta (pestana 5ª casa)
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 5, barre: true, barreString: 0,
      label: 'Pestana 5ª casa',
    ),
  ]),

  'Bm': ChordData(name: 'Bm', variants: [
    ChordVariant(
      // forma Am, pestana 2ª
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 2, barre: true, barreString: 1,
      label: 'Pestana 2ª casa',
    ),
    ChordVariant(
      // forma Em, pestana 7ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 7, barre: true, barreString: 0,
      label: 'Pestana 7ª casa',
    ),
  ]),

  'Cm': ChordData(name: 'Cm', variants: [
    ChordVariant(
      // forma Am, pestana 3ª
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 3, barre: true, barreString: 1,
      label: 'Pestana 3ª casa',
    ),
    ChordVariant(
      // forma Em, pestana 8ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 8, barre: true, barreString: 0,
      label: 'Pestana 8ª casa',
    ),
  ]),

  'Dm': ChordData(name: 'Dm', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 2, 3, 1],
      fingers: [0, 0, 0, 2, 3, 1],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma Am, pestana 5ª
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 5, barre: true, barreString: 1,
      label: 'Pestana 5ª casa',
    ),
  ]),

  'Em': ChordData(name: 'Em', variants: [
    ChordVariant(
      frets: [0, 2, 2, 0, 0, 0],
      fingers: [0, 2, 3, 0, 0, 0],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma Em, pestana 7ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 7, barre: true, barreString: 0,
      label: 'Pestana 7ª casa',
    ),
  ]),

  'Fm': ChordData(name: 'Fm', variants: [
    ChordVariant(
      // forma Em, pestana 1ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 1, barre: true, barreString: 0,
      label: 'Pestana 1ª casa',
    ),
  ]),

  'Gm': ChordData(name: 'Gm', variants: [
    ChordVariant(
      // forma Em, pestana 3ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 3, barre: true, barreString: 0,
      label: 'Pestana 3ª casa',
    ),
    ChordVariant(
      // forma Am, pestana 10ª
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 10, barre: true, barreString: 1,
      label: 'Pestana 10ª casa',
    ),
  ]),

  'F#m': ChordData(name: 'F#m', variants: [
    ChordVariant(
      // forma Em, pestana 2ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 2, barre: true, barreString: 0,
      label: 'Pestana 2ª casa',
    ),
    ChordVariant(
      // forma Am, pestana 9ª
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 9, barre: true, barreString: 1,
      label: 'Pestana 9ª casa',
    ),
  ]),

  'Gbm': ChordData(name: 'Gbm', variants: [
    ChordVariant(
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 2,
      barre: true,
      barreString: 0,
      label: 'Pestana 2ª casa',
    ),
  ]),

  'G#m': ChordData(name: 'G#m', variants: [
    ChordVariant(
      // forma Em, pestana 4ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 4, barre: true, barreString: 0,
      label: 'Pestana 4ª casa',
    ),
  ]),

  'Abm': ChordData(name: 'Abm', variants: [
    ChordVariant(
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 4,
      barre: true,
      barreString: 0,
      label: 'Pestana 4ª casa',
    ),
  ]),

  'C#m': ChordData(name: 'C#m', variants: [
    ChordVariant(
      // forma Am, pestana 4ª
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 4, barre: true, barreString: 1,
      label: 'Pestana 4ª casa',
    ),
    ChordVariant(
      // forma Em, pestana 9ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 9, barre: true, barreString: 0,
      label: 'Pestana 9ª casa',
    ),
  ]),

  'Dbm': ChordData(name: 'Dbm', variants: [
    ChordVariant(
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 4,
      barre: true,
      barreString: 1,
      label: 'Pestana 4ª casa',
    ),
  ]),

  'D#m': ChordData(name: 'D#m', variants: [
    ChordVariant(
      // forma Em, pestana 6ª
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 6, barre: true, barreString: 0,
      label: 'Pestana 6ª casa',
    ),
  ]),

  'Ebm': ChordData(name: 'Ebm', variants: [
    ChordVariant(
      frets: [1, 1, 2, 3, 2, 1],
      fingers: [0, 0, 2, 4, 3, 0],
      baseFret: 6,
      barre: true,
      barreString: 0,
      label: 'Pestana 6ª casa',
    ),
  ]),

  'A#m': ChordData(name: 'A#m', variants: [
    ChordVariant(
      // forma Am, pestana 1ª
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 1, barre: true, barreString: 1,
      label: 'Pestana 1ª casa',
    ),
  ]),

  'Bbm': ChordData(name: 'Bbm', variants: [
    ChordVariant(
      frets: [-1, 1, 2, 3, 3, 1],
      fingers: [0, 0, 2, 3, 4, 0],
      baseFret: 1,
      barre: true,
      barreString: 1,
      label: 'Pestana 1ª casa',
    ),
  ]),

  // ══════════ SÉTIMAS DOMINANTES ══════════

  'A7': ChordData(name: 'A7', variants: [
    ChordVariant(
      frets: [-1, 0, 2, 0, 2, 0],
      fingers: [0, 0, 2, 0, 3, 0],
      label: 'Posição aberta',
    ),
  ]),

  'B7': ChordData(name: 'B7', variants: [
    ChordVariant(
      frets: [-1, 2, 1, 2, 0, 2],
      fingers: [0, 2, 1, 3, 0, 4],
      label: 'Posição aberta',
    ),
  ]),

  'C7': ChordData(name: 'C7', variants: [
    ChordVariant(
      frets: [-1, 3, 2, 3, 1, 0],
      fingers: [0, 3, 2, 4, 1, 0],
      label: 'Posição aberta',
    ),
  ]),

  'D7': ChordData(name: 'D7', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 2, 1, 2],
      fingers: [0, 0, 0, 2, 1, 3],
      label: 'Posição aberta',
    ),
  ]),

  'E7': ChordData(name: 'E7', variants: [
    ChordVariant(
      frets: [0, 2, 0, 1, 0, 0],
      fingers: [0, 2, 0, 1, 0, 0],
      label: 'Posição aberta',
    ),
  ]),

  'F7': ChordData(name: 'F7', variants: [
    ChordVariant(
      // forma E7, pestana 1ª
      frets: [1, 1, 2, 1, 1, 1],
      fingers: [0, 0, 2, 0, 0, 0],
      baseFret: 1, barre: true, barreString: 0,
      label: 'Pestana 1ª casa',
    ),
  ]),

  'G7': ChordData(name: 'G7', variants: [
    ChordVariant(
      frets: [3, 2, 0, 0, 0, 1],
      fingers: [3, 2, 0, 0, 0, 1],
      label: 'Posição aberta',
    ),
  ]),

  // ══════════ MENORES COM SÉTIMA ══════════

  'Am7': ChordData(name: 'Am7', variants: [
    ChordVariant(
      frets: [-1, 0, 2, 0, 1, 0],
      fingers: [0, 0, 2, 0, 1, 0],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma Em7, pestana 5ª casa
      frets: [1, 1, 2, 1, 2, 1],
      fingers: [0, 0, 2, 0, 3, 0],
      baseFret: 5,
      barre: true,
      barreString: 0,
      label: 'Pestana 5ª casa',
    ),
  ]),

  'Bm7': ChordData(name: 'Bm7', variants: [
    ChordVariant(
      frets: [-1, 1, 2, 1, 2, 1],
      fingers: [0, 0, 2, 0, 3, 0],
      baseFret: 2,
      barre: true,
      barreString: 1,
      label: 'Pestana 2ª casa',
    ),
  ]),

  'Dm7': ChordData(name: 'Dm7', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 2, 1, 1],
      fingers: [0, 0, 0, 3, 1, 1],
      baseFret: 1,
      barre: true,
      barreString: 3,
      label: 'Posição aberta',
    ),
  ]),

  'Em7': ChordData(name: 'Em7', variants: [
    ChordVariant(
      frets: [0, 2, 0, 0, 0, 0],
      fingers: [0, 1, 0, 0, 0, 0],
      label: 'Posição aberta',
    ),
    ChordVariant(
      // forma Am7, pestana 7ª
      frets: [-1, 1, 2, 1, 2, 1],
      fingers: [0, 0, 2, 0, 3, 0],
      baseFret: 7,
      barre: true,
      barreString: 1,
      label: 'Pestana 7ª casa',
    ),
  ]),

  'Gm7': ChordData(name: 'Gm7', variants: [
    ChordVariant(
      frets: [1, 1, 2, 1, 2, 1],
      fingers: [0, 0, 2, 0, 3, 0],
      baseFret: 3,
      barre: true,
      barreString: 0,
      label: 'Pestana 3ª casa',
    ),
  ]),

  'Cm7': ChordData(name: 'Cm7', variants: [
    ChordVariant(
      frets: [1, 1, 2, 1, 2, 1],
      fingers: [0, 0, 2, 0, 3, 0],
      baseFret: 3,
      barre: true,
      barreString: 0,
      label: 'Pestana 3ª casa',
    ),
  ]),

  'F#m7': ChordData(name: 'F#m7', variants: [
    ChordVariant(
      frets: [1, 1, 2, 1, 2, 1],
      fingers: [0, 0, 2, 0, 3, 0],
      baseFret: 2,
      barre: true,
      barreString: 0,
      label: 'Pestana 2ª casa',
    ),
  ]),

  // ══════════ MAIOR COM SÉTIMA (Maj7) ══════════

  'Cmaj7': ChordData(name: 'Cmaj7', variants: [
    ChordVariant(
      frets: [-1, 3, 2, 0, 0, 0],
      fingers: [0, 3, 2, 0, 0, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Dmaj7': ChordData(name: 'Dmaj7', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 2, 2, 2],
      fingers: [0, 0, 0, 1, 2, 3],
      label: 'Posição aberta',
    ),
  ]),

  'Emaj7': ChordData(name: 'Emaj7', variants: [
    ChordVariant(
      frets: [0, 2, 1, 1, 0, 0],
      fingers: [0, 3, 1, 2, 0, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Fmaj7': ChordData(name: 'Fmaj7', variants: [
    ChordVariant(
      frets: [-1, -1, 3, 2, 1, 0],
      fingers: [0, 0, 4, 3, 2, 0],
      label: 'Posição aberta',
    ),
    ChordVariant(
      frets: [1, 1, 2, 2, 1, 1],
      fingers: [0, 0, 2, 3, 0, 0],
      baseFret: 1,
      barre: true,
      barreString: 0,
      label: 'Pestana 1ª casa',
    ),
  ]),

  'Gmaj7': ChordData(name: 'Gmaj7', variants: [
    ChordVariant(
      frets: [3, 2, 0, 0, 0, 2],
      fingers: [3, 2, 0, 0, 0, 4],
      label: 'Posição aberta',
    ),
  ]),

  'Amaj7': ChordData(name: 'Amaj7', variants: [
    ChordVariant(
      frets: [-1, 0, 2, 1, 2, 0],
      fingers: [0, 0, 3, 1, 4, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Bmaj7': ChordData(name: 'Bmaj7', variants: [
    ChordVariant(
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 0, 0],
      baseFret: 2,
      barre: true,
      barreString: 1,
      label: 'Pestana 2ª casa',
    ),
  ]),

  'Bbmaj7': ChordData(name: 'Bbmaj7', variants: [
    ChordVariant(
      frets: [-1, 1, 1, 1, 1, 1],
      fingers: [0, 0, 2, 3, 0, 0],
      baseFret: 1,
      barre: true,
      barreString: 1,
      label: 'Pestana 1ª casa',
    ),
  ]),

  // ══════════ SUS / ADD ══════════

  'Asus2': ChordData(name: 'Asus2', variants: [
    ChordVariant(
      frets: [-1, 0, 2, 2, 0, 0],
      fingers: [0, 0, 1, 2, 0, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Asus4': ChordData(name: 'Asus4', variants: [
    ChordVariant(
      frets: [-1, 0, 2, 2, 3, 0],
      fingers: [0, 0, 1, 2, 3, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Dsus2': ChordData(name: 'Dsus2', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 2, 3, 0],
      fingers: [0, 0, 0, 1, 2, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Dsus4': ChordData(name: 'Dsus4', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 2, 3, 3],
      fingers: [0, 0, 0, 1, 2, 3],
      label: 'Posição aberta',
    ),
  ]),

  'Esus4': ChordData(name: 'Esus4', variants: [
    ChordVariant(
      frets: [0, 2, 2, 2, 0, 0],
      fingers: [0, 1, 2, 3, 0, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Gsus4': ChordData(name: 'Gsus4', variants: [
    ChordVariant(
      frets: [3, 3, 0, 0, 1, 3],
      fingers: [2, 3, 0, 0, 1, 4],
      label: 'Posição aberta',
    ),
  ]),

  'Cadd9': ChordData(name: 'Cadd9', variants: [
    ChordVariant(
      frets: [-1, 3, 2, 0, 3, 0],
      fingers: [0, 3, 2, 0, 4, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Gadd9': ChordData(name: 'Gadd9', variants: [
    ChordVariant(
      frets: [3, 2, 0, 2, 0, 3],
      fingers: [2, 1, 0, 3, 0, 4],
      label: 'Posição aberta',
    ),
  ]),

  'Dadd9': ChordData(name: 'Dadd9', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 2, 3, 0],
      fingers: [0, 0, 0, 1, 2, 0],
      label: 'Posição aberta',
    ),
  ]),

  'A7sus4': ChordData(name: 'A7sus4', variants: [
    ChordVariant(
      frets: [-1, 0, 2, 0, 3, 0],
      fingers: [0, 0, 2, 0, 3, 0],
      label: 'Posição aberta',
    ),
  ]),

  // ══════════ DIMINUTOS / AUMENTADOS ══════════

  'Adim': ChordData(name: 'Adim', variants: [
    ChordVariant(
      frets: [-1, 0, 1, 2, 1, 0],
      fingers: [0, 0, 1, 3, 2, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Bdim': ChordData(name: 'Bdim', variants: [
    ChordVariant(
      frets: [-1, 2, 3, 4, 3, -1],
      fingers: [0, 1, 2, 4, 3, 0],
      label: 'Posição fechada',
    ),
  ]),

  'Cdim': ChordData(name: 'Cdim', variants: [
    ChordVariant(
      frets: [-1, -1, 1, 2, 1, 2],
      fingers: [0, 0, 1, 3, 2, 4],
      label: 'Posição fechada',
    ),
  ]),

  'Ddim': ChordData(name: 'Ddim', variants: [
    ChordVariant(
      frets: [-1, -1, 0, 1, 0, 1],
      fingers: [0, 0, 0, 1, 0, 2],
      label: 'Posição aberta',
    ),
  ]),

  'Edim': ChordData(name: 'Edim', variants: [
    ChordVariant(
      frets: [0, 1, 2, 3, 2, -1],
      fingers: [0, 1, 2, 4, 3, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Fdim': ChordData(name: 'Fdim', variants: [
    ChordVariant(
      frets: [-1, -1, 3, 4, 3, 4],
      fingers: [0, 0, 1, 3, 2, 4],
      label: 'Posição fechada',
    ),
  ]),

  'Gdim': ChordData(name: 'Gdim', variants: [
    ChordVariant(
      // E6=G(3ª) A5=Db(4ª) D4=G(5ª) G3=Bb(3ª) — posições relativas ao baseFret 3
      frets: [1, 2, 3, 1, -1, -1],
      fingers: [1, 2, 4, 3, 0, 0],
      baseFret: 3,
      label: 'Posição fechada',
    ),
  ]),

  'Eaug': ChordData(name: 'Eaug', variants: [
    ChordVariant(
      frets: [0, 3, 2, 1, 1, 0],
      fingers: [0, 4, 3, 1, 2, 0],
      label: 'Posição aberta',
    ),
  ]),

  'Aaug': ChordData(name: 'Aaug', variants: [
    ChordVariant(
      frets: [-1, 0, 3, 2, 2, 1],
      fingers: [0, 0, 4, 2, 3, 1],
      label: 'Posição aberta',
    ),
  ]),
};

// ── Busca no banco ───────────────────────────────────────────────────────────
String? findChordKey(String rawChord) {
  if (chordDatabase.containsKey(rawChord)) return rawChord;
  final attempts = [
    rawChord,
    if (rawChord.length > 1) rawChord.substring(0, rawChord.length - 1),
    if (rawChord.length > 2) rawChord.substring(0, rawChord.length - 2),
  ];
  for (final a in attempts) {
    if (chordDatabase.containsKey(a)) return a;
  }
  return null;
}

// ── Painter ────────────────────────────────────────────────────────────────

class _DiagramPainter extends CustomPainter {
  final ChordVariant variant;
  _DiagramPainter(this.variant);

  static const int _strings = 6;
  static const int _frets = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final sw = size.width / (_strings - 1);
    final fh = size.height / (_frets + 1.2);
    final top = fh * 1.2;
    final bottom = top + fh * _frets;

    final linePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;

    final nutPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Nut ou linha da casa base
    if (variant.baseFret == 1) {
      canvas.drawLine(Offset(0, top), Offset(size.width, top), nutPaint);
    } else {
      canvas.drawLine(Offset(0, top), Offset(size.width, top), linePaint);
      _text(canvas, '${variant.baseFret}ª', Offset(-22, top + fh * 0.45), 10,
          Colors.white54);
    }

    // Linhas horizontais (casas)
    for (int i = 1; i <= _frets; i++) {
      canvas.drawLine(
          Offset(0, top + i * fh), Offset(size.width, top + i * fh), linePaint);
    }

    // Linhas verticais (cordas)
    for (int s = 0; s < _strings; s++) {
      canvas.drawLine(Offset(s * sw, top), Offset(s * sw, bottom), linePaint);
    }

    // Barra de pestana (linha 1 = 1ª casa relativa)
    if (variant.barre) {
      final barreY = top + 0.5 * fh;
      final barreStartX = variant.barreString * sw;
      final barrePaint = Paint()
        ..color = Colors.white70
        ..strokeWidth = fh * 0.55
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
          Offset(barreStartX, barreY), Offset(size.width, barreY), barrePaint);
    }

    // Marcadores por corda
    for (int s = 0; s < _strings; s++) {
      final fret = variant.frets[s];
      final x = s * sw;

      if (fret == -1) {
        _drawX(canvas, Offset(x, top - fh * 0.65));
      } else if (fret == 0) {
        _drawOpen(canvas, Offset(x, top - fh * 0.65));
      } else {
        // fret já é relativo ao baseFret (1 = primeira linha do diagrama)
        final y = top + (fret - 0.5) * fh;
        final finger = variant.fingers[s];
        // não desenha círculo onde a pestana já cobre a corda
        final isBarrePos = variant.barre &&
            fret == 1 &&
            s >= variant.barreString;
        if (!isBarrePos) {
          _drawFinger(canvas, Offset(x, y), finger);
        }
      }
    }
  }

  void _drawX(Canvas canvas, Offset c) {
    final p = Paint()
      ..color = Colors.white38
      ..strokeWidth = 1.5;
    const r = 5.0;
    canvas.drawLine(c - const Offset(r, r), c + const Offset(r, r), p);
    canvas.drawLine(c + const Offset(r, -r), c - const Offset(r, -r), p);
  }

  void _drawOpen(Canvas canvas, Offset c) {
    canvas.drawCircle(
        c,
        5,
        Paint()
          ..color = Colors.white60
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  void _drawFinger(Canvas canvas, Offset c, int finger) {
    canvas.drawCircle(
        c,
        11,
        Paint()
          ..color = const Color(0xFFE8A838)
          ..style = PaintingStyle.fill);
    if (finger > 0) {
      _text(canvas, '$finger', c, 11, Colors.black);
    }
  }

  void _text(Canvas canvas, String t, Offset pos, double fs, Color color) {
    final tp = TextPainter(
      text: TextSpan(
          text: t,
          style: TextStyle(
              fontSize: fs, color: color, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_DiagramPainter old) => old.variant != variant;
}

// ── Widget ─────────────────────────────────────────────────────────────────

class ChordDiagramWidget extends StatefulWidget {
  final String chordName;
  const ChordDiagramWidget({super.key, required this.chordName});

  @override
  State<ChordDiagramWidget> createState() => _ChordDiagramWidgetState();
}

class _ChordDiagramWidgetState extends State<ChordDiagramWidget> {
  int _variantIndex = 0;

  @override
  Widget build(BuildContext context) {
    final key = findChordKey(widget.chordName);
    final data = key != null ? chordDatabase[key] : null;

    if (data == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.chordName,
                style: const TextStyle(
                    color: Color(0xFFE8A838),
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Icon(Icons.music_off, color: Colors.white24, size: 44),
            const SizedBox(height: 8),
            const Text('Diagrama não disponível',
                style: TextStyle(color: Colors.white38, fontSize: 13)),
          ],
        ),
      );
    }

    final variant = data.variants[_variantIndex];
    final hasMultiple = data.variants.length > 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(data.name,
              style: const TextStyle(
                  color: Color(0xFFE8A838),
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: variant.barre
                  ? Colors.deepPurple.withValues(alpha: 0.35)
                  : Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              variant.label ??
                  (variant.barre ? 'Com pestana' : 'Posição aberta'),
              style: TextStyle(
                  fontSize: 11,
                  color: variant.barre ? Colors.purple[200] : Colors.green[300],
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 170,
            height: 190,
            child: CustomPaint(painter: _DiagramPainter(variant)),
          ),
          const SizedBox(height: 10),
          const Text('E  A  D  G  B  e',
              style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  letterSpacing: 3.5)),
          const SizedBox(height: 16),
          if (hasMultiple) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(data.variants.length, (i) {
                final active = i == _variantIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 10 : 7,
                  height: active ? 10 : 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? const Color(0xFFE8A838) : Colors.white24,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() {
                _variantIndex = (_variantIndex + 1) % data.variants.length;
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('variar acorde',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Modal ───────────────────────────────────────────────────────────────────

void showChordDiagram(BuildContext context, String chordName) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1A1A1A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
              color: Colors.white24, borderRadius: BorderRadius.circular(2)),
        ),
        ChordDiagramWidget(chordName: chordName),
      ],
    ),
  );
}
