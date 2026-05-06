import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reserve_contribution_model.dart';

class ReserveContributionService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createContribution({
    required String reserveGoalId,
    required double amount,
    String? description,
    required DateTime contributionDate,
  }) async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Usuário não autenticado.');
      }

      await _supabase.from('reserve_contributions').insert({
        'user_id': user.id,
        'reserve_goal_id': reserveGoalId,
        'amount': amount,
        'description': description,
        'contribution_date': contributionDate
            .toIso8601String()
            .split('T')
            .first,
      });

      debugPrint('ReserveContributionService: aporte criado com sucesso.');
    } catch (e) {
      debugPrint('ReserveContributionService.createContribution error: $e');
      rethrow;
    }
  }

  Future<void> updateContribution({
    required String contributionId,
    required double amount,
    String? description,
    required DateTime contributionDate,
  }) async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Usuário não autenticado.');
      }

      await _supabase
          .from('reserve_contributions')
          .update({
            'amount': amount,
            'description': description,
            'contribution_date': contributionDate
                .toIso8601String()
                .split('T')
                .first,
          })
          .eq('id', contributionId)
          .eq('user_id', user.id);

      debugPrint('ReserveContributionService: aporte atualizado com sucesso.');
    } catch (e) {
      debugPrint('ReserveContributionService.updateContribution error: $e');
      rethrow;
    }
  }

  Future<void> deleteContribution(String contributionId) async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Usuário não autenticado.');
      }

      await _supabase
          .from('reserve_contributions')
          .delete()
          .eq('id', contributionId)
          .eq('user_id', user.id);

      debugPrint('ReserveContributionService: aporte excluído com sucesso.');
    } catch (e) {
      debugPrint('ReserveContributionService.deleteContribution error: $e');
      rethrow;
    }
  }

  Future<List<ReserveContributionModel>> getRecentContributions() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        debugPrint('ReserveContributionService: usuário não autenticado.');
        return [];
      }

      final data = await _supabase
          .from('reserve_contributions')
          .select()
          .eq('user_id', user.id)
          .order('contribution_date', ascending: false)
          .limit(10);

      return (data as List)
          .map((item) => ReserveContributionModel.fromMap(item))
          .toList();
    } catch (e) {
      debugPrint('ReserveContributionService.getRecentContributions error: $e');
      rethrow;
    }
  }

  Future<List<ReserveContributionModel>> getAllContributions() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        debugPrint('ReserveContributionService: usuário não autenticado.');
        return [];
      }

      final data = await _supabase
          .from('reserve_contributions')
          .select()
          .eq('user_id', user.id)
          .order('contribution_date', ascending: false);

      return (data as List)
          .map((item) => ReserveContributionModel.fromMap(item))
          .toList();
    } catch (e) {
      debugPrint('ReserveContributionService.getAllContributions error: $e');
      rethrow;
    }
  }
}
