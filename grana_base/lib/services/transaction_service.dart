import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/transaction_model.dart';

class TransactionService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<TransactionModel>> getRecentTransactions() async {
    final response = await _client
        .from('transactions')
        .select()
        .order('transaction_date', ascending: false)
        .limit(20);

    return (response as List<dynamic>)
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
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    await _client.from('transactions').insert({
      'user_id': user.id,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'description': description?.trim().isEmpty == true
          ? null
          : description?.trim(),
      'transaction_date': transactionDate.toIso8601String().split('T').first,
    });
  }

  Future<void> updateTransaction({
    required String transactionId,
    required String categoryId,
    required String type,
    required double amount,
    required DateTime transactionDate,
    String? description,
  }) async {
    await _client
        .from('transactions')
        .update({
          'category_id': categoryId,
          'type': type,
          'amount': amount,
          'description': description?.trim().isEmpty == true
              ? null
              : description?.trim(),
          'transaction_date': transactionDate
              .toIso8601String()
              .split('T')
              .first,
        })
        .eq('id', transactionId);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _client.from('transactions').delete().eq('id', transactionId);
  }
}
