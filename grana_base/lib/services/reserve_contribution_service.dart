import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/services/api_client.dart';
import '../models/reserve_contribution_model.dart';

class ReserveContributionService {
  Future<void> createContribution({
    required String reserveGoalId,
    required double amount,
    String? description,
    required DateTime contributionDate,
  }) async {
    try {
      final response = await ApiClient.post('/reserve-contributions/', {
        'reserve_goal_id': reserveGoalId,
        'amount': amount,
        'description': description,
        'contribution_date': contributionDate.toIso8601String().split('T').first,
      });

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(data['error'] ?? 'Erro ao criar aporte.');
      }
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
      final response = await ApiClient.put('/reserve-contributions/$contributionId', {
        'amount': amount,
        'description': description,
        'contribution_date': contributionDate.toIso8601String().split('T').first,
      });

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(data['error'] ?? 'Erro ao atualizar aporte.');
      }
    } catch (e) {
      debugPrint('ReserveContributionService.updateContribution error: $e');
      rethrow;
    }
  }

  Future<void> deleteContribution(String contributionId) async {
    try {
      final response = await ApiClient.delete('/reserve-contributions/$contributionId');

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(data['error'] ?? 'Erro ao excluir aporte.');
      }
    } catch (e) {
      debugPrint('ReserveContributionService.deleteContribution error: $e');
      rethrow;
    }
  }

  Future<List<ReserveContributionModel>> getRecentContributions() async {
    try {
      final response = await ApiClient.get('/reserve-contributions/?recent=true');

      if (response.statusCode != 200) {
        debugPrint('ReserveContributionService: erro ${response.statusCode}');
        return [];
      }

      final list = jsonDecode(response.body) as List<dynamic>;
      return list.map((item) => ReserveContributionModel.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('ReserveContributionService.getRecentContributions error: $e');
      rethrow;
    }
  }

  Future<List<ReserveContributionModel>> getAllContributions() async {
    try {
      final response = await ApiClient.get('/reserve-contributions/');

      if (response.statusCode != 200) {
        debugPrint('ReserveContributionService: erro ${response.statusCode}');
        return [];
      }

      final list = jsonDecode(response.body) as List<dynamic>;
      return list.map((item) => ReserveContributionModel.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('ReserveContributionService.getAllContributions error: $e');
      rethrow;
    }
  }
}
