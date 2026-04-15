import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';

class CategoryService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    final response = await _client
        .from('categories')
        .select()
        .eq('type', type)
        .order('name', ascending: true);

    return (response as List<dynamic>)
        .map((item) => CategoryModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<CategoryModel> createCategory({
    required String name,
    required String type,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    final response = await _client
        .from('categories')
        .insert({'user_id': user.id, 'name': name.trim(), 'type': type})
        .select()
        .single();

    return CategoryModel.fromMap(response);
  }
}
