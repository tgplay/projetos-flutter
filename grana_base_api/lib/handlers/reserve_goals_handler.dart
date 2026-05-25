import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';

Router reserveGoalsRouter() {
  final router = Router();

  router.get('/', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          SELECT id, user_id, target_amount, description, created_at, updated_at
          FROM reserve_goals
          WHERE user_id = @userId
          LIMIT 1
        '''),
        parameters: {'userId': userId},
      );

      if (result.isEmpty) {
        return Response.ok('null', headers: {'content-type': 'application/json'});
      }

      return _ok(_goalToMap(result.first));
    } catch (e) {
      return _serverError(e);
    }
  });

  router.post('/', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final targetAmount = body['target_amount'];
      final description = body['description'] as String?;

      if (targetAmount == null) return _badRequest('target_amount é obrigatório.');

      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          INSERT INTO reserve_goals (user_id, target_amount, description)
          VALUES (@userId, @amount, @description)
          RETURNING id, user_id, target_amount, description, created_at, updated_at
        '''),
        parameters: {
          'userId': userId,
          'amount': double.parse(targetAmount.toString()),
          'description': description,
        },
      );

      return _ok(_goalToMap(result.first));
    } catch (e) {
      return _serverError(e);
    }
  });

  router.put('/<id>', (Request request, String id) async {
    try {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final targetAmount = body['target_amount'];
      final description = body['description'] as String?;

      if (targetAmount == null) return _badRequest('target_amount é obrigatório.');

      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          UPDATE reserve_goals
          SET target_amount = @amount, description = @description, updated_at = NOW()
          WHERE id = @id AND user_id = @userId
          RETURNING id, user_id, target_amount, description, created_at, updated_at
        '''),
        parameters: {
          'id': id,
          'userId': userId,
          'amount': double.parse(targetAmount.toString()),
          'description': description,
        },
      );

      if (result.isEmpty) return _notFound('Meta de reserva não encontrada.');

      return _ok(_goalToMap(result.first));
    } catch (e) {
      return _serverError(e);
    }
  });

  return router;
}

Map<String, dynamic> _goalToMap(dynamic row) {
  final m = row.toColumnMap();
  return {
    'id': m['id'].toString(),
    'user_id': m['user_id'].toString(),
    'target_amount': double.parse(m['target_amount'].toString()),
    'description': m['description'],
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

Response _notFound(String msg) => Response.notFound(
      jsonEncode({'error': msg}),
      headers: {'content-type': 'application/json'},
    );

Response _serverError(Object e) => Response.internalServerError(
      body: jsonEncode({'error': 'Erro interno: $e'}),
      headers: {'content-type': 'application/json'},
    );
