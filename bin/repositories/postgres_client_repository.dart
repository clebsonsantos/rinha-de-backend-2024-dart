import 'dart:async';

import 'package:postgres/postgres.dart';

import '../models/client.dart';
import 'client_repository.dart';

class PostgresClienteRepository implements ClientRepository {
  final PostgreSQLConnection _connection;
  PostgresClienteRepository(this._connection);

  @override
  Future<Client?> getClientByID(int clientId) async {
    final result = await _connection.query(
      'SELECT * FROM clientes WHERE id = @clientId',
      substitutionValues: {'clientId': clientId},
    );

    if (result.isEmpty) {
      return null;
    }

    return result
        .map((client) => Client.convertRowToClient(client))
        .firstWhere((element) => element.id == clientId);
  }
}
