import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:grana_base_api/handlers/auth_handler.dart';
import 'package:grana_base_api/handlers/categories_handler.dart';
import 'package:grana_base_api/handlers/transactions_handler.dart';
import 'package:grana_base_api/handlers/reserve_goals_handler.dart';
import 'package:grana_base_api/handlers/reserve_contributions_handler.dart';
import 'package:grana_base_api/middleware/auth_middleware.dart';

void main() async {
  final app = Router();

  app.mount('/auth/', authRouter().call);

  final protected = const Pipeline().addMiddleware(authMiddleware());

  app.mount('/categories/', protected.addHandler(categoriesRouter().call));
  app.mount('/transactions/', protected.addHandler(transactionsRouter().call));
  app.mount('/reserve-goals/', protected.addHandler(reserveGoalsRouter().call));
  app.mount('/reserve-contributions/', protected.addHandler(reserveContributionsRouter().call));

  final handler = const Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(app.call);

  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  print('GranaBase API rodando em http://0.0.0.0:${server.port}');
}
