import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/services/api_client.dart';
import '../models/reserve_goal_model.dart';

class ReserveGoalService {
  Future<ReserveGoalModel?> getReserveGoal() async {
    try {
      final response = await ApiClient.get('/reserve-goals/');

      if (response.statusCode != 200) {
        debugPrint('ReserveGoalService: erro ${response.statusCode}');
        return null;
      }

      final body = response.body.trim();
      if (body == 'null' || body.isEmpty) return null;

      return ReserveGoalModel.fromMap(jsonDecode(body) as Map<String, dynamic>);
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
      final response = await ApiClient.post('/reserve-goals/', {
        'target_amount': targetAmount,
        'description': description,
      });

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(data['error'] ?? 'Erro ao criar meta.');
      }
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
      final response = await ApiClient.put('/reserve-goals/$reserveGoalId', {
        'target_amount': targetAmount,
        'description': description,
      });

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(data['error'] ?? 'Erro ao atualizar meta.');
      }
    } catch (e) {
      debugPrint('ReserveGoalService.updateReserveGoal error: $e');
      rethrow;
    }
  }
}
