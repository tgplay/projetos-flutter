import 'dart:convert';

import '../core/services/api_client.dart';
import '../models/category_model.dart';

class CategoryService {
  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    final response = await ApiClient.get('/categories/?type=$type');

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar categorias.');
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((item) => CategoryModel.fromMap(item as Map<String, dynamic>)).toList();
  }

  Future<CategoryModel> createCategory({
    required String name,
    required String type,
  }) async {
    final response = await ApiClient.post('/categories/', {
      'name': name.trim(),
      'type': type,
    });

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['error'] ?? 'Erro ao criar categoria.');
    }

    return CategoryModel.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
