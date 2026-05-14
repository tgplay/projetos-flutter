import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/song_provider.dart';

const _keys = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

class SongFormScreen extends StatefulWidget {
  final Song? song;
  const SongFormScreen({super.key, this.song});

  bool get isEditing => song != null;

  @override
  State<SongFormScreen> createState() => _SongFormScreenState();
}

class _SongFormScreenState extends State<SongFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _artist;
  late final TextEditingController _bpm;
  late final TextEditingController _chordSheet;
  late String _selectedKey;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.song;
    _title = TextEditingController(text: s?.title ?? '');
    _artist = TextEditingController(text: s?.artist ?? '');
    _bpm = TextEditingController(text: s?.bpm.toString() ?? '');
    _chordSheet = TextEditingController(text: s?.chordSheet ?? '');
    _selectedKey = s?.originalKey ?? 'C';
    if (!_keys.contains(_selectedKey)) _selectedKey = 'C';
  }

  @override
  void dispose() {
    _title.dispose();
    _artist.dispose();
    _bpm.dispose();
    _chordSheet.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final song = Song(
      id: widget.song?.id ?? 0,
      title: _title.text.trim(),
      artist: _artist.text.trim(),
      originalKey: _selectedKey,
      bpm: int.tryParse(_bpm.text.trim()) ?? 120,
      chordSheet: _chordSheet.text.trim(),
    );

    final provider = context.read<SongProvider>();
    if (widget.isEditing) {
      await provider.updateSong(song);
    } else {
      await provider.addSong(song);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(
          widget.isEditing ? 'Editar música' : 'Nova música',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Salvar', style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _Field(
              label: 'Título',
              controller: _title,
              validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            _Field(
              label: 'Artista',
              controller: _artist,
              validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _FormCard(
                    label: 'Tom original',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedKey,
                        dropdownColor: const Color(0xFF16213E),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        items: _keys
                            .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedKey = v!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Field(
                    label: 'BPM',
                    controller: _bpm,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Obrigatório';
                      final n = int.tryParse(v.trim());
                      if (n == null || n < 20 || n > 300) return '20-300';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FormCard(
              label: 'Cifra  (use [Acorde] antes da sílaba)',
              child: TextFormField(
                controller: _chordSheet,
                maxLines: 20,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '[G]Palavra [D]palavra...',
                  hintStyle: TextStyle(color: Colors.white24, fontFamily: 'monospace'),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _Field({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      label: label,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final String label;
  final Widget child;
  const _FormCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: child,
        ),
      ],
    );
  }
}
