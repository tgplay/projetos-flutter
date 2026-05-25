import 'dart:convert';

import '../core/services/api_client.dart';
import '../models/transaction_model.dart';

class TransactionSummary {
  final double totalIncome;
  final double totalExpense;
  double get balance => totalIncome - totalExpense;

  TransactionSummary({required this.totalIncome, required this.totalExpense});
}

class TransactionService {
  static const int pageSize = 5;

  Future<TransactionSummary> getSummary() async {
    final response = await ApiClient.get('/transactions/summary');

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar resumo.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return TransactionSummary(
      totalIncome: (data['total_income'] as num).toDouble(),
      totalExpense: (data['total_expense'] as num).toDouble(),
    );
  }

  Future<List<TransactionModel>> getTransactions({int page = 1}) async {
    final response = await ApiClient.get(
      '/transactions/?page=$page&limit=$pageSize',
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar transações.');
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((item) => TransactionModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> createTransaction({
    required String categoryId,
    required String type,
    required double amount,
    required DateTime transactionDate,
    String? description,
  }) async {
    final response = await ApiClient.post('/transactions/', {
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'description': description?.trim().isEmpty == true
          ? null
          : description?.trim(),
      'transaction_date': transactionDate.toIso8601String().split('T').first,
    });

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['error'] ?? 'Erro ao criar transação.');
    }
  }

  Future<void> updateTransaction({
    required String transactionId,
    required String categoryId,
    required String type,
    required double amount,
    required DateTime transactionDate,
    String? description,
  }) async {
    final response = await ApiClient.put('/transactions/$transactionId', {
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'description': description?.trim().isEmpty == true
          ? null
          : description?.trim(),
      'transaction_date': transactionDate.toIso8601String().split('T').first,
    });

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['error'] ?? 'Erro ao atualizar transação.');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    final response = await ApiClient.delete('/transactions/$transactionId');

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['error'] ?? 'Erro ao excluir transação.');
    }
  }
}
