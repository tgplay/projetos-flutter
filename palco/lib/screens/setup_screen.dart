import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/performance_provider.dart';
import 'performance_screen.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Consumer<PerformanceProvider>(
          builder: (_, p, __) => Text(
            p.currentSong?.title ?? '',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<PerformanceProvider>(
        builder: (context, provider, _) {
          final song = provider.currentSong!;
          final settings = provider.settings;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _InfoCard(
                child: Column(
                  children: [
                    Text(song.artist,
                        style: const TextStyle(color: Colors.white54, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('${song.bpm} BPM',
                        style: const TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionLabel('Tom'),
              const SizedBox(height: 12),
              _InfoCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TransposeButton(
                      icon: Icons.remove,
                      onTap: () => provider.transpose(-1),
                      enabled: settings.transposeSteps > -6,
                    ),
                    Column(
                      children: [
                        Text(
                          provider.currentKey,
                          style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          settings.transposeSteps == 0
                              ? 'Original'
                              : '${settings.transposeSteps > 0 ? '+' : ''}${settings.transposeSteps} semitons',
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                    _TransposeButton(
                      icon: Icons.add,
                      onTap: () => provider.transpose(1),
                      enabled: settings.transposeSteps < 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionLabel('Capotraste'),
              const SizedBox(height: 12),
              _InfoCard(
                child: Row(
                  children: List.generate(8, (i) {
                    final selected = settings.capo == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => provider.setCapo(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.deepPurpleAccent
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            i == 0 ? '—' : '$i',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.white54,
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
              _SectionLabel('Tamanho da fonte  ${settings.fontSize.toInt()}px'),
              const SizedBox(height: 8),
              _InfoCard(
                child: Slider(
                  value: settings.fontSize,
                  min: 12,
                  max: 32,
                  divisions: 10,
                  activeColor: Colors.deepPurpleAccent,
                  inactiveColor: Colors.white12,
                  onChanged: provider.setFontSize,
                ),
              ),
              const SizedBox(height: 24),
              _SectionLabel('Velocidade de rolagem  ${settings.scrollSpeed.toInt()}'),
              const SizedBox(height: 8),
              _InfoCard(
                child: Slider(
                  value: settings.scrollSpeed,
                  min: 5,
                  max: 100,
                  divisions: 19,
                  activeColor: Colors.deepPurpleAccent,
                  inactiveColor: Colors.white12,
                  onChanged: provider.setScrollSpeed,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    provider.startPerformance();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PerformanceScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar Performance',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5));
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _TransposeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _TransposeButton(
      {required this.icon, required this.onTap, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon),
      color: Colors.white,
      disabledColor: Colors.white24,
      style: IconButton.styleFrom(
        backgroundColor: enabled
            ? Colors.deepPurple.withValues(alpha: 0.4)
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
