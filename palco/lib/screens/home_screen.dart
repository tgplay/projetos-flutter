import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song_provider.dart';
import '../providers/performance_provider.dart';
import '../models/song.dart';
import 'setup_screen.dart';
import 'song_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openSetup(BuildContext context, Song song) {
    context.read<PerformanceProvider>().loadSong(song);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SetupScreen()));
  }

  void _openForm(BuildContext context, {Song? song}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SongFormScreen(song: song)),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Song song) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Excluir música', style: TextStyle(color: Colors.white)),
        content: Text(
          'Deseja excluir "${song.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<SongProvider>().deleteSong(song.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Palco',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: context.read<SongProvider>().search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar música ou artista...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF16213E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<SongProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.deepPurpleAccent));
                }
                final songs = provider.songs;
                if (songs.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma música encontrada',
                        style: TextStyle(color: Colors.white54)),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                  itemCount: songs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) => _SongCard(
                    song: songs[i],
                    onTap: () => _openSetup(context, songs[i]),
                    onEdit: () => _openForm(context, song: songs[i]),
                    onDelete: () => _confirmDelete(context, songs[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SongCard({
    required this.song,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.music_note, color: Colors.deepPurpleAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(song.artist,
                      style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(song.originalKey,
                      style: const TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                Text('${song.bpm} BPM',
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              color: const Color(0xFF16213E),
              icon: const Icon(Icons.more_vert, color: Colors.white38),
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit, color: Colors.white70, size: 18),
                    SizedBox(width: 8),
                    Text('Editar', style: TextStyle(color: Colors.white70)),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete, color: Colors.redAccent, size: 18),
                    SizedBox(width: 8),
                    Text('Excluir', style: TextStyle(color: Colors.redAccent)),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
