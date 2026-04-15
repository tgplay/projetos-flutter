import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/transaction_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/transaction_service.dart';
import '../transactions/add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TransactionService _transactionService = TransactionService();

  late Future<List<TransactionModel>> _transactionsFuture;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _transactionService.getRecentTransactions();
  }

  Future<void> _reload() async {
    setState(() {
      _transactionsFuture = _transactionService.getRecentTransactions();
    });

    await _transactionsFuture;
  }

  Future<void> _goToAddTransaction() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );

    if (created == true) {
      await _reload();
    }
  }

  Future<void> _goToEditTransaction(TransactionModel transaction) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(transaction: transaction),
      ),
    );

    if (updated == true) {
      await _reload();
    }
  }

  Future<void> _deleteTransaction(TransactionModel transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Excluir transação'),
        content: Text(
          'Deseja realmente excluir "${transaction.description?.isNotEmpty == true ? transaction.description! : 'Sem descrição'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await _transactionService.deleteTransaction(transaction.id);

      if (!mounted) return;

      await _reload();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação excluída com sucesso')),
      );
    } catch (e) {
      debugPrint('Erro ao excluir transação: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir transação: $e')));
    } finally {
      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('GranaBase'),
        actions: [
          IconButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    await authProvider.signOut();
                  },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isDeleting ? null : _goToAddTransaction,
        icon: const Icon(Icons.add),
        label: const Text('Transação'),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<TransactionModel>>(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 80),
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text(
                    'Erro ao carregar transações.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center),
                ],
              );
            }

            final transactions = snapshot.data ?? [];

            final totalIncome = transactions
                .where((t) => t.type.toLowerCase() == 'income')
                .fold<double>(0, (sum, item) => sum + item.amount);

            final totalExpense = transactions
                .where((t) => t.type.toLowerCase() == 'expense')
                .fold<double>(0, (sum, item) => sum + item.amount);

            final balance = totalIncome - totalExpense;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Resumo',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Receitas',
                        value: currencyFormat.format(totalIncome),
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Despesas',
                        value: currencyFormat.format(totalExpense),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SummaryCard(
                  title: 'Saldo',
                  value: currencyFormat.format(balance),
                  color: balance >= 0 ? Colors.blue : Colors.orange,
                ),
                const SizedBox(height: 24),
                Text(
                  'Últimas transações',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (transactions.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Nenhuma transação encontrada.'),
                    ),
                  )
                else
                  ...transactions.map(
                    (transaction) => Card(
                      child: ListTile(
                        onTap: _isDeleting
                            ? null
                            : () => _goToEditTransaction(transaction),
                        leading: CircleAvatar(
                          backgroundColor:
                              transaction.type.toLowerCase() == 'income'
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          child: Icon(
                            transaction.type.toLowerCase() == 'income'
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: transaction.type.toLowerCase() == 'income'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        title: Text(
                          transaction.description?.isNotEmpty == true
                              ? transaction.description!
                              : 'Sem descrição',
                        ),
                        subtitle: Text(
                          dateFormat.format(transaction.transactionDate),
                        ),
                        trailing: IconButton(
                          onPressed: _isDeleting
                              ? null
                              : () => _deleteTransaction(transaction),
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Excluir transação',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 80),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
