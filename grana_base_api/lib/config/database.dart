import 'package:postgres/postgres.dart';

class Database {
  static Connection? _connection;

  static Future<Connection> get() async {
    if (_connection == null) {
      _connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          port: 5432,
          database: 'grana_base',
          username: 'postgres',
          password: 'postgres',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
    }
    return _connection!;
  }
}
