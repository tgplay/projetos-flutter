import 'package:flutter/material.dart';
import 'chord_diagram_widget.dart';

class ChordSheetWidget extends StatelessWidget {
  final String sheet;
  final double fontSize;

  const ChordSheetWidget({
    super.key,
    required this.sheet,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final lines = sheet.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map((line) => _ChordLine(line: line, fontSize: fontSize))
          .toList(),
    );
  }
}

class _ChordLine extends StatelessWidget {
  final String line;
  final double fontSize;

  const _ChordLine({required this.line, required this.fontSize});

  List<({String chord, String text})> _parse() {
    if (line.isEmpty) return [(chord: '', text: '')];

    final segments = <({String chord, String text})>[];
    final regex = RegExp(r'\[([^\]]+)\]([^\[]*)');
    final firstBracket = line.indexOf('[');

    if (firstBracket > 0) {
      segments.add((chord: '', text: line.substring(0, firstBracket)));
    }

    for (final m in regex
        .allMatches(firstBracket >= 0 ? line.substring(firstBracket) : line)) {
      segments.add((chord: m.group(1)!, text: m.group(2)!));
    }

    if (segments.isEmpty) {
      segments.add((chord: '', text: line));
    }

    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final segments = _parse();
    final hasChords = segments.any((s) => s.chord.isNotEmpty);

    if (!hasChords) {
      return Padding(
        padding: EdgeInsets.only(bottom: line.isEmpty ? fontSize * 0.6 : 2),
        child: Text(
          line.isEmpty ? '' : line,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: segments.map((seg) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Acorde clicável ──
              if (seg.chord.isEmpty)
                SizedBox(height: fontSize * 0.85 + 4)
              else
                GestureDetector(
                  onTap: () => showChordDiagram(context, seg.chord),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.amber.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      seg.chord,
                      style: TextStyle(
                        fontSize: fontSize * 0.85,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              // ── Letra ──
              Text(
                seg.text.isEmpty ? ' ' : seg.text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
