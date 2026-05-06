import 'package:flutter/material.dart';

import '../../models/reserve_contribution_model.dart';
import '../../models/reserve_goal_model.dart';
import '../../models/transaction_model.dart';
import '../../services/reserve_contribution_service.dart';
import '../../services/reserve_goal_service.dart';
import '../../services/transaction_service.dart';
import '../reserve/add_reserve_contribution_screen.dart';
import '../reserve/add_reserve_goal_screen.dart';
import '../reserve/reserve_contributions_screen.dart';
import '../transactions/add_transaction_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TransactionService _transactionService = TransactionService();
  final ReserveGoalService _reserveGoalService = ReserveGoalService();
  final ReserveContributionService _reserveContributionService =
      ReserveContributionService();

  bool _isLoading = true;
  List<TransactionModel> _transactions = [];
  ReserveGoalModel? _reserveGoal;
  List<ReserveContributionModel> _reserveContributions = [];

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _confirmAndLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text('Tem certeza que deseja sair da sua conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      // Se você usa um AuthGate observando o estado de auth,
      // ele deve redirecionar automaticamente ao perceber o logout.
      // Aqui só damos um feedback rápido.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Você saiu da sua conta.')));
    } catch (e) {
      debugPrint('HomeScreen _confirmAndLogout error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao sair: $e')));
    }
  }

  Future<void> _goToReserveContributions() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReserveContributionsScreen()),
    );

    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await _transactionService.getRecentTransactions();
      final reserveGoal = await _reserveGoalService.getReserveGoal();
      final reserveContributions = await _reserveContributionService
          .getAllContributions();

      setState(() {
        _transactions = transactions;
        _reserveGoal = reserveGoal;
        _reserveContributions = reserveContributions;
      });
    } catch (e) {
      debugPrint('HomeScreen _loadHomeData error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados da Home: $e')),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  double get _totalIncome {
    return _transactions
        .where((transaction) => transaction.type == 'income')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get _totalExpense {
    return _transactions
        .where((transaction) => transaction.type == 'expense')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get _balance => _totalIncome - _totalExpense;

  double get _totalReserveContributions {
    return _reserveContributions.fold(
      0.0,
      (sum, contribution) => sum + contribution.amount,
    );
  }

  double get _reserveProgress {
    if (_reserveGoal == null || _reserveGoal!.targetAmount <= 0) {
      return 0.0;
    }

    final progress = _totalReserveContributions / _reserveGoal!.targetAmount;

    if (progress > 1) return 1.0;
    if (progress < 0) return 0.0;

    return progress;
  }

  double get _remainingReserveAmount {
    if (_reserveGoal == null) {
      return 0.0;
    }

    final remaining = _reserveGoal!.targetAmount - _totalReserveContributions;

    if (remaining < 0) return 0.0;

    return remaining;
  }

  String get _reserveStatusText {
    if (_reserveGoal == null) {
      return 'Toque para cadastrar sua meta';
    }

    if (_remainingReserveAmount == 0) {
      return 'Meta atingida';
    }

    return 'Faltam ${_formatCurrency(_remainingReserveAmount)} para a meta';
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  String _formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  Future<void> _goToAddTransaction() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );

    _loadHomeData();
  }

  Future<void> _goToEditTransaction(TransactionModel transaction) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(transaction: transaction),
      ),
    );

    _loadHomeData();
  }

  Future<void> _goToReserveGoalForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddReserveGoalScreen(reserveGoal: _reserveGoal),
      ),
    );

    if (result == true) {
      _loadHomeData();
    }
  }

  Future<void> _goToAddReserveContribution() async {
    if (_reserveGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastre uma meta antes de registrar aportes.'),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddReserveContributionScreen(reserveGoalId: _reserveGoal!.id),
      ),
    );

    if (result == true) {
      _loadHomeData();
    }
  }

  Future<void> _deleteTransaction(String transactionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir transação'),
          content: const Text('Tem certeza que deseja excluir esta transação?'),
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
      await _transactionService.deleteTransaction(transactionId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação excluída com sucesso.')),
      );

      _loadHomeData();
    } catch (e) {
      debugPrint('HomeScreen _deleteTransaction error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir transação: $e')));
    }
  }

  void _showReserveOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: const Text('Ver aportes'),
                onTap: () {
                  Navigator.pop(context);
                  _goToReserveContributions();
                },
              ),
              ListTile(
                leading: const Icon(Icons.savings),
                title: const Text('Editar meta'),
                onTap: () {
                  Navigator.pop(context);
                  _goToReserveGoalForm();
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Registrar aporte'),
                onTap: () {
                  Navigator.pop(context);
                  _goToAddReserveContribution();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GranaBase'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _confirmAndLogout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Sair')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTransaction,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadHomeData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummaryCard(
                    title: 'Receitas',
                    value: _formatCurrency(_totalIncome),
                    color: Colors.green,
                    icon: Icons.arrow_downward,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Despesas',
                    value: _formatCurrency(_totalExpense),
                    color: Colors.red,
                    icon: Icons.arrow_upward,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Saldo',
                    value: _formatCurrency(_balance),
                    color: Colors.blue,
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 12),
                  _buildReserveGoalCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Últimas transações',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_transactions.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhuma transação cadastrada ainda.'),
                      ),
                    )
                  else
                    ..._transactions.map(
                      (transaction) => Card(
                        child: ListTile(
                          onTap: () => _goToEditTransaction(transaction),
                          leading: CircleAvatar(
                            backgroundColor: transaction.type == 'income'
                                ? Colors.green.withValues(alpha: 0.15)
                                : Colors.red.withValues(alpha: 0.15),
                            child: Icon(
                              transaction.type == 'income'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaction.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(
                            transaction.description ?? 'Sem descrição',
                          ),
                          subtitle: Text(
                            '${transaction.type == 'income' ? 'Receita' : 'Despesa'} • ${transaction.transactionDate.toLocal().toString().split(' ').first}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatCurrency(transaction.amount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: transaction.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _deleteTransaction(transaction.id),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildReserveGoalCard() {
    final hasGoal = _reserveGoal != null;

    return Card(
      child: InkWell(
        onTap: hasGoal ? _showReserveOptions : _goToReserveGoalForm,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.withValues(alpha: 0.15),
                  child: const Icon(Icons.savings, color: Colors.orange),
                ),
                title: const Text(
                  'Fundo de reserva',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _reserveStatusText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  hasGoal ? Icons.more_horiz : Icons.chevron_right,
                ),
              ),
              if (hasGoal) ...[
                const SizedBox(height: 8),
                Text(
                  'Guardado',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(_totalReserveContributions),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Meta: ${_formatCurrency(_reserveGoal!.targetAmount)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _reserveProgress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.orange.withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildReserveInfoChip(
                        icon: Icons.percent,
                        label: 'Progresso',
                        value: _formatPercentage(_reserveProgress),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildReserveInfoChip(
                        icon: Icons.payments_outlined,
                        label: 'Aportes',
                        value: '${_reserveContributions.length}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildReserveInfoChip(
                        icon: Icons.flag_outlined,
                        label: 'Falta',
                        value: _formatCurrency(_remainingReserveAmount),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _goToReserveContributions,
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('Ver aportes'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _goToAddReserveContribution,
                        icon: const Icon(Icons.add),
                        label: const Text('Aportar'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReserveInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
