import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../models/reserve_contribution_model.dart';
import '../../services/reserve_contribution_service.dart';
import 'add_reserve_contribution_screen.dart';

class ReserveContributionsScreen extends StatefulWidget {
  const ReserveContributionsScreen({super.key});

  @override
  State<ReserveContributionsScreen> createState() =>
      _ReserveContributionsScreenState();
}

class _ReserveContributionsScreenState
    extends State<ReserveContributionsScreen> {
  final ReserveContributionService _reserveContributionService =
      ReserveContributionService();

  bool _isLoading = true;
  List<ReserveContributionModel> _contributions = [];

  @override
  void initState() {
    super.initState();
    _loadContributions();
  }

  Future<void> _loadContributions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final contributions = await _reserveContributionService
          .getRecentContributions();

      setState(() {
        _contributions = contributions;
      });
    } catch (e) {
      debugPrint('ReserveContributionsScreen _loadContributions error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar aportes: $e')));
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _goToEditContribution(
    ReserveContributionModel contribution,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddReserveContributionScreen(
          reserveGoalId: contribution.reserveGoalId,
          contribution: contribution,
        ),
      ),
    );

    if (result == true) {
      _loadContributions();
    }
  }

  Future<void> _deleteContribution(
    ReserveContributionModel contribution,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir aporte'),
          content: const Text('Tem certeza que deseja excluir este aporte?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _reserveContributionService.deleteContribution(contribution.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aporte excluído com sucesso.')),
      );

      _loadContributions();
    } catch (e) {
      debugPrint('ReserveContributionsScreen _deleteContribution error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir aporte: $e')));
    }
  }

  String _formatCurrency(double value) => formatCurrency(value);

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aportes da reserva')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadContributions,
              child: _contributions.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Nenhum aporte registrado ainda.'),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _contributions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final contribution = _contributions[index];

                        return Card(
                          child: ListTile(
                            onTap: () => _goToEditContribution(contribution),
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.withValues(
                                alpha: 0.15,
                              ),
                              child: const Icon(
                                Icons.savings,
                                color: Colors.orange,
                              ),
                            ),
                            title: Text(
                              _formatCurrency(contribution.amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              contribution.description?.trim().isNotEmpty ==
                                      true
                                  ? '${contribution.description} • ${_formatDate(contribution.contributionDate)}'
                                  : _formatDate(contribution.contributionDate),
                            ),
                            trailing: IconButton(
                              onPressed: () =>
                                  _deleteContribution(contribution),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
