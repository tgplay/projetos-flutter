import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

const jwtSecret = 'grana_base_secret_key_change_in_production';

Middleware authMiddleware() {
  return (Handler inner) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.unauthorized(
          jsonEncode({'error': 'Token não fornecido.'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final token = authHeader.substring(7);

      try {
        final jwt = JWT.verify(token, SecretKey(jwtSecret));
        final payload = jwt.payload as Map<String, dynamic>;
        final userId = payload['sub'] as String;
        return inner(request.change(context: {'userId': userId}));
      } on JWTExpiredException {
        return Response.unauthorized(
          jsonEncode({'error': 'Token expirado.'}),
          headers: {'content-type': 'application/json'},
        );
      } on JWTException {
        return Response.unauthorized(
          jsonEncode({'error': 'Token inválido.'}),
          headers: {'content-type': 'application/json'},
        );
      }
    };
  };
}

String generateToken(String userId, String email) {
  final jwt = JWT({'sub': userId, 'email': email});
  return jwt.sign(SecretKey(jwtSecret), expiresIn: const Duration(days: 7));
}
