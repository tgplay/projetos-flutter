import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';

Router authRouter() {
  final router = Router();

  router.post('/register', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final email = (body['email'] as String?)?.trim().toLowerCase();
      final password = body['password'] as String?;

      if (email == null || email.isEmpty || !email.contains('@')) {
        return _badRequest('Email inválido.');
      }
      if (password == null || password.length < 6) {
        return _badRequest('A senha deve ter pelo menos 6 caracteres.');
      }

      final db = await Database.get();

      final existing = await db.execute(
        Sql.named('SELECT id FROM users WHERE email = @email'),
        parameters: {'email': email},
      );

      if (existing.isNotEmpty) {
        return Response(
          409,
          body: jsonEncode({'error': 'Este email já está cadastrado.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final hash = BCrypt.hashpw(password, BCrypt.gensalt());

      final result = await db.execute(
        Sql.named('''
          INSERT INTO users (email, password_hash)
          VALUES (@email, @hash)
          RETURNING id, email
        '''),
        parameters: {'email': email, 'hash': hash},
      );

      final row = result.first.toColumnMap();
      final token = generateToken(row['id'].toString(), row['email'].toString());

      return _ok({'token': token, 'userId': row['id'].toString(), 'email': row['email']});
    } catch (e) {
      return _serverError(e);
    }
  });

  router.post('/login', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final email = (body['email'] as String?)?.trim().toLowerCase();
      final password = body['password'] as String?;

      if (email == null || email.isEmpty || password == null || password.isEmpty) {
        return _badRequest('Email e senha são obrigatórios.');
      }

      final db = await Database.get();

      final result = await db.execute(
        Sql.named('SELECT id, email, password_hash FROM users WHERE email = @email'),
        parameters: {'email': email},
      );

      if (result.isEmpty) {
        return Response(
          401,
          body: jsonEncode({'error': 'Email ou senha inválidos.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final row = result.first.toColumnMap();

      if (!BCrypt.checkpw(password, row['password_hash'].toString())) {
        return Response(
          401,
          body: jsonEncode({'error': 'Email ou senha inválidos.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final token = generateToken(row['id'].toString(), row['email'].toString());

      return _ok({'token': token, 'userId': row['id'].toString(), 'email': row['email']});
    } catch (e) {
      return _serverError(e);
    }
  });

  return router;
}

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
