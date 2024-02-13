import 'package:shelf_router/shelf_router.dart';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'controllers/client_controller.dart';
import 'repositories/client_repository.dart';
import 'repositories/postgres_client_repository.dart';
import 'repositories/postgres_transaction_repository.dart';

final _router = Router();

Future<void> bootstrap(Router router) async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final connection = PostgreSQLConnection('${env["DB_HOST"]}',
      int.parse('${env["DB_PORT"]}'), '${env["DB_SCHEMA"]}',
      username: '${env["DB_USER"]}', password: '${env["DB_PASS"]}');

  connection.open();
  final transactionRepository = PostgresTransactionRepository(connection);
  final clientRepository = PostgresClienteRepository(connection);
  final ClientController clientController =
      ClientController(transactionRepository, clientRepository);

  router.post("/clientes/<ClientID>/transacoes",
      clientController.createTransactionToClient);

  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  int port = env["PORT"] != null ? int.parse(env["PORT"]!) : 3000;

  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

void main() async {
  await bootstrap(_router);
}
