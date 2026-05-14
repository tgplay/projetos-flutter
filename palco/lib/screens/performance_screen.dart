import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../providers/performance_provider.dart';
import '../widgets/chord_sheet_widget.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  final _scrollController = ScrollController();
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable(); // ← tela nunca apaga durante a performance
    _tick();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WakelockPlus.disable(); // ← restaura comportamento normal ao sair
    context.read<PerformanceProvider>().endPerformance();
    _scrollController.dispose();
    super.dispose();
  }

  void _tick() {
    if (!mounted) return;
    final provider = context.read<PerformanceProvider>();
    if (provider.settings.autoScroll && _scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;
      if (current < max) {
        _scrollController.animateTo(
          current + provider.settings.scrollSpeed * 0.1,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      }
    }
    Future.delayed(const Duration(milliseconds: 100), _tick);
  }

  void _toggleControls() =>
      setState(() => _controlsVisible = !_controlsVisible);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<PerformanceProvider>(
        builder: (context, provider, _) {
          final song = provider.currentSong!;
          final settings = provider.settings;

          return GestureDetector(
            onTap: _toggleControls,
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: _controlsVisible ? 100 : 40,
                    bottom: _controlsVisible ? 120 : 40,
                  ),
                  child: ChordSheetWidget(
                    sheet: provider.transposedSheet,
                    fontSize: settings.fontSize,
                  ),
                ),
                AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !_controlsVisible,
                    child: Column(
                      children: [
                        _TopBar(
                          title: song.title,
                          musicalKey: provider.currentKey,
                          capo: settings.capo,
                        ),
                        const Spacer(),
                        _BottomBar(provider: provider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final String musicalKey;
  final int capo;

  const _TopBar(
      {required this.title, required this.musicalKey, required this.capo});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis),
          ),
          if (capo > 0)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Capo $capo',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(musicalKey,
                style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final PerformanceProvider provider;
  const _BottomBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final settings = provider.settings;
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 12,
        top: 12,
        left: 16,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BarButton(
            icon: Icons.remove,
            label: 'Tom -',
            onTap: () => provider.transpose(-1),
            enabled: settings.transposeSteps > -6,
          ),
          _BarButton(
            icon: Icons.add,
            label: 'Tom +',
            onTap: () => provider.transpose(1),
            enabled: settings.transposeSteps < 6,
          ),
          _BarButton(
            icon: Icons.text_decrease,
            label: 'Fonte -',
            onTap: () => provider.setFontSize(settings.fontSize - 2),
          ),
          _BarButton(
            icon: Icons.text_increase,
            label: 'Fonte +',
            onTap: () => provider.setFontSize(settings.fontSize + 2),
          ),
          _BarButton(
            icon: settings.autoScroll ? Icons.pause : Icons.play_arrow,
            label: settings.autoScroll ? 'Pausar' : 'Rolar',
            onTap: provider.toggleAutoScroll,
            active: settings.autoScroll,
          ),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool active;

  const _BarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? Colors.amber
        : enabled
            ? Colors.white
            : Colors.white24;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}
