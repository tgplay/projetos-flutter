import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reserve_goal_model.dart';

class ReserveGoalService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ReserveGoalModel?> getReserveGoal() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        debugPrint('ReserveGoalService: usuário não autenticado.');
        return null;
      }

      final data = await _supabase
          .from('reserve_goals')
          .select()
          .eq('user_id', user.id)
          .limit(1)
          .maybeSingle();

      if (data == null) {
        debugPrint('ReserveGoalService: nenhuma meta de reserva encontrada.');
        return null;
      }

      return ReserveGoalModel.fromMap(data);
    } catch (e) {
      debugPrint('ReserveGoalService.getReserveGoal error: $e');
      rethrow;
    }
  }

  Future<void> createReserveGoal({
    required double targetAmount,
    String? description,
  }) async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Usuário não autenticado.');
      }

      await _supabase.from('reserve_goals').insert({
        'user_id': user.id,
        'target_amount': targetAmount,
        'description': description,
      });

      debugPrint('ReserveGoalService: meta de reserva criada com sucesso.');
    } catch (e) {
      debugPrint('ReserveGoalService.createReserveGoal error: $e');
      rethrow;
    }
  }

  Future<void> updateReserveGoal({
    required String reserveGoalId,
    required double targetAmount,
    String? description,
  }) async {
    try {
      await _supabase
          .from('reserve_goals')
          .update({'target_amount': targetAmount, 'description': description})
          .eq('id', reserveGoalId);

      debugPrint('ReserveGoalService: meta de reserva atualizada com sucesso.');
    } catch (e) {
      debugPrint('ReserveGoalService.updateReserveGoal error: $e');
      rethrow;
    }
  }
}
