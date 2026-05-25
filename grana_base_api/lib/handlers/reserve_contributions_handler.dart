import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';

Router reserveContributionsRouter() {
  final router = Router();

  router.get('/', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final recent = request.url.queryParameters['recent'] == 'true';
      final db = await Database.get();

      final sql = '''
        SELECT id, user_id, reserve_goal_id, amount, description,
               contribution_date, created_at, updated_at
        FROM reserve_contributions
        WHERE user_id = @userId
        ORDER BY contribution_date DESC
        ${recent ? 'LIMIT 10' : ''}
      ''';

      final result = await db.execute(
        Sql.named(sql),
        parameters: {'userId': userId},
      );

      return _ok(result.map(_contribToMap).toList());
    } catch (e) {
      return _serverError(e);
    }
  });

  router.post('/', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final reserveGoalId = body['reserve_goal_id'] as String?;
      final amount = body['amount'];
      final contributionDate = body['contribution_date'] as String?;
      final description = body['description'] as String?;

      if (reserveGoalId == null || amount == null || contributionDate == null) {
        return _badRequest('Campos obrigatórios: reserve_goal_id, amount, contribution_date.');
      }

      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          INSERT INTO reserve_contributions
            (user_id, reserve_goal_id, amount, description, contribution_date)
          VALUES
            (@userId, @goalId, @amount, @description, @date)
          RETURNING id, user_id, reserve_goal_id, amount, description,
                    contribution_date, created_at, updated_at
        '''),
        parameters: {
          'userId': userId,
          'goalId': reserveGoalId,
          'amount': double.parse(amount.toString()),
          'description': description,
          'date': contributionDate,
        },
      );

      return _ok(_contribToMap(result.first));
    } catch (e) {
      return _serverError(e);
    }
  });

  router.put('/<id>', (Request request, String id) async {
    try {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final amount = body['amount'];
      final contributionDate = body['contribution_date'] as String?;
      final description = body['description'] as String?;

      if (amount == null || contributionDate == null) {
        return _badRequest('Campos obrigatórios: amount, contribution_date.');
      }

      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          UPDATE reserve_contributions
          SET amount = @amount, description = @description,
              contribution_date = @date, updated_at = NOW()
          WHERE id = @id AND user_id = @userId
          RETURNING id, user_id, reserve_goal_id, amount, description,
                    contribution_date, created_at, updated_at
        '''),
        parameters: {
          'id': id,
          'userId': userId,
          'amount': double.parse(amount.toString()),
          'description': description,
          'date': contributionDate,
        },
      );

      if (result.isEmpty) return _notFound('Aporte não encontrado.');

      return _ok(_contribToMap(result.first));
    } catch (e) {
      return _serverError(e);
    }
  });

  router.delete('/<id>', (Request request, String id) async {
    try {
      final userId = request.context['userId'] as String;
      final db = await Database.get();

      await db.execute(
        Sql.named('DELETE FROM reserve_contributions WHERE id = @id AND user_id = @userId'),
        parameters: {'id': id, 'userId': userId},
      );

      return _ok({'message': 'Aporte excluído com sucesso.'});
    } catch (e) {
      return _serverError(e);
    }
  });

  return router;
}

Map<String, dynamic> _contribToMap(dynamic row) {
  final m = row.toColumnMap();
  return {
    'id': m['id'].toString(),
    'user_id': m['user_id'].toString(),
    'reserve_goal_id': m['reserve_goal_id'].toString(),
    'amount': double.parse(m['amount'].toString()),
    'description': m['description'],
    'contribution_date': _date(m['contribution_date']),
    'created_at': _ts(m['created_at']),
    'updated_at': _ts(m['updated_at']),
  };
}

String _date(dynamic v) =>
    v is DateTime ? v.toIso8601String().split('T').first : v.toString().split(' ').first;

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
