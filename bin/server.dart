import 'package:shelf_router/shelf_router.dart';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'controllers/client_controller.dart';
import 'repositories/postgres_client_repository.dart';
import 'repositories/postgres_transaction_repository.dart';
import 'usecases/get_client_by_id_usecase.dart';
import 'usecases/new_transaction_usecase.dart';

final _router = Router();

Future<void> bootstrap(Router router) async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final connection = PostgreSQLConnection('${env["DB_HOST"]}',
      int.parse('${env["DB_PORT"]}'), '${env["DB_SCHEMA"]}',
      username: '${env["DB_USER"]}', password: '${env["DB_PASS"]}');

  connection.open();

  final transactionRepository = PostgresTransactionRepository(connection);
  final clientRepository = PostgresClienteRepository(connection);

  final newTransactionUseCase =
      NewTransactionUseCase(clientRepository, transactionRepository);

  final getClientById = GetClientByIDUseCase(clientRepository);

  final ClientController clientController =
      ClientController(newTransactionUseCase, getClientById);

  router.post("/clientes/<ClientID>/transacoes",
      clientController.createTransactionToClient);

  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  int port = env["PORT"] != null ? int.parse(env["PORT"]!) : 8080;

  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

void main() async {
  await bootstrap(_router);
}
