import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';

Router transactionsRouter() {
  final router = Router();

  router.get('/summary', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          SELECT
            COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) AS total_income,
            COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0) AS total_expense
          FROM transactions
          WHERE user_id = @userId
        '''),
        parameters: {'userId': userId},
      );

      final m = result.first.toColumnMap();
      return _ok({
        'total_income': double.parse(m['total_income'].toString()),
        'total_expense': double.parse(m['total_expense'].toString()),
      });
    } catch (e) {
      return _serverError(e);
    }
  });

  router.get('/', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = int.tryParse(params['limit'] ?? '20') ?? 20;
      final offset = (page - 1) * limit;
      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          SELECT id, user_id, category_id, type, amount, description,
                 transaction_date, created_at, updated_at
          FROM transactions
          WHERE user_id = @userId
          ORDER BY transaction_date DESC
          LIMIT @limit OFFSET @offset
        '''),
        parameters: {'userId': userId, 'limit': limit, 'offset': offset},
      );

      return _ok(result.map(_txToMap).toList());
    } catch (e) {
      return _serverError(e);
    }
  });

  router.post('/', (Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final categoryId = body['category_id'] as String?;
      final type = body['type'] as String?;
      final amount = body['amount'];
      final transactionDate = body['transaction_date'] as String?;
      final description = body['description'] as String?;

      if (categoryId == null || type == null || amount == null || transactionDate == null) {
        return _badRequest('Campos obrigatórios: category_id, type, amount, transaction_date.');
      }

      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          INSERT INTO transactions
            (user_id, category_id, type, amount, description, transaction_date)
          VALUES
            (@userId, @categoryId, @type, @amount, @description, @date)
          RETURNING id, user_id, category_id, type, amount, description,
                    transaction_date, created_at, updated_at
        '''),
        parameters: {
          'userId': userId,
          'categoryId': categoryId,
          'type': type,
          'amount': double.parse(amount.toString()),
          'description': _nullIfEmpty(description),
          'date': transactionDate,
        },
      );

      return _ok(_txToMap(result.first));
    } catch (e) {
      return _serverError(e);
    }
  });

  router.put('/<id>', (Request request, String id) async {
    try {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final categoryId = body['category_id'] as String?;
      final type = body['type'] as String?;
      final amount = body['amount'];
      final transactionDate = body['transaction_date'] as String?;
      final description = body['description'] as String?;

      if (categoryId == null || type == null || amount == null || transactionDate == null) {
        return _badRequest('Campos obrigatórios: category_id, type, amount, transaction_date.');
      }

      final db = await Database.get();

      final result = await db.execute(
        Sql.named('''
          UPDATE transactions
          SET category_id = @categoryId, type = @type, amount = @amount,
              description = @description, transaction_date = @date, updated_at = NOW()
          WHERE id = @id AND user_id = @userId
          RETURNING id, user_id, category_id, type, amount, description,
                    transaction_date, created_at, updated_at
        '''),
        parameters: {
          'id': id,
          'userId': userId,
          'categoryId': categoryId,
          'type': type,
          'amount': double.parse(amount.toString()),
          'description': _nullIfEmpty(description),
          'date': transactionDate,
        },
      );

      if (result.isEmpty) return _notFound('Transação não encontrada.');

      return _ok(_txToMap(result.first));
    } catch (e) {
      return _serverError(e);
    }
  });

  router.delete('/<id>', (Request request, String id) async {
    try {
      final userId = request.context['userId'] as String;
      final db = await Database.get();

      await db.execute(
        Sql.named('DELETE FROM transactions WHERE id = @id AND user_id = @userId'),
        parameters: {'id': id, 'userId': userId},
      );

      return _ok({'message': 'Transação excluída com sucesso.'});
    } catch (e) {
      return _serverError(e);
    }
  });

  return router;
}

Map<String, dynamic> _txToMap(dynamic row) {
  final m = row.toColumnMap();
  return {
    'id': m['id'].toString(),
    'user_id': m['user_id'].toString(),
    'category_id': m['category_id'].toString(),
    'type': m['type'],
    'amount': double.parse(m['amount'].toString()),
    'description': m['description'],
    'transaction_date': _date(m['transaction_date']),
    'created_at': _ts(m['created_at']),
    'updated_at': _ts(m['updated_at']),
  };
}

String _date(dynamic v) =>
    v is DateTime ? v.toIso8601String().split('T').first : v.toString().split(' ').first;

String _ts(dynamic v) => v is DateTime ? v.toIso8601String() : v.toString();

String? _nullIfEmpty(String? v) => (v?.trim().isEmpty ?? true) ? null : v?.trim();

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
