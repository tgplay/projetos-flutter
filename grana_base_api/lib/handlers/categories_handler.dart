import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';

Router categoriesRouter() {
  final router = Router();

  router.get('/', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final type = request.url.queryParameters['type'];
      final db = await Database.get();

      final Result result;

      if (type != null) {
        result = await db.execute(
          Sql.named('''
            SELECT id, user_id, name, type, created_at, updated_at
            FROM categories
            WHERE user_id = @userId AND type = @type
            ORDER BY name ASC
          '''),
          parameters: {'userId': userId, 'type': type},
        );
      } else {
        result = await db.execute(
          Sql.named('''
            SELECT id, user_id, name, type, created_at, updated_at
            FROM categories
            WHERE user_id = @userId
            ORDER BY name ASC
          '''),
          parameters: {'userId': userId},
        );
      }

      return _ok(result.map(_categoryToMap).toList());
    } catch (e) {
      return _serverError(e);
    }
  });

  router.post('/', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final name = (body['name'] as String?)?.trim();
      final type = body['type'] as String?;

      if (name == null || name.isEmpty) return _badRequest('Nome é obrigatório.');
      if (type == null || !['income', 'expense'].contains(type)) {
        return _badRequest('Tipo deve ser income ou expense.');
      }

      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          INSERT INTO categories (user_id, name, type)
          VALUES (@userId, @name, @type)
          RETURNING id, user_id, name, type, created_at, updated_at
        '''),
        parameters: {'userId': userId, 'name': name, 'type': type},
      );

      return _ok(_categoryToMap(result.first));
    } catch (e) {
      return _serverError(e);
    }
  });

  return router;
}

Map<String, dynamic> _categoryToMap(dynamic row) {
  final m = row.toColumnMap();
  return {
    'id': m['id'].toString(),
    'user_id': m['user_id'].toString(),
    'name': m['name'],
    'type': m['type'],
    'created_at': _ts(m['created_at']),
    'updated_at': _ts(m['updated_at']),
  };
}

String _ts(dynamic v) => v is DateTime ? v.toIso8601String() : v.toString();

Response _ok(Object data) =>
    Response.ok(jsonEncode(data), headers: {'content-type': 'application/json'});

Response _badRequest(String msg) => Response.badRequest(
      body: jsonEncode({'error': msg}),
      headers: {'content-type': 'application/json'},
    );

Response _serverError(Object e) => Response.internalServerError(
      body: jsonEncode({'error': 'Erro interno: $e'}),
      headers: {'content-type': 'application/json'},
    );
