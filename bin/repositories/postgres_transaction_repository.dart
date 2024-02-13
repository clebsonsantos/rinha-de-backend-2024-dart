import 'package:postgres/postgres.dart';

import '../models/transaction.dart';
import 'transaction_repository.dart';

class PostgresTransactionRepository implements TransactionRepository {
  final PostgreSQLConnection _connection;

  PostgresTransactionRepository(this._connection);

  @override
  Future<void> createTransaction(
      int clientId, Map<String, dynamic> transaction) async {
    await _connection.query(
      'INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (@clientId, @value, @type, @description)',
      substitutionValues: {
        'clientId': clientId,
        'value': transaction['valor'],
        'type': transaction['tipo'],
        'description': transaction['descricao'],
      },
    );
  }

  @override
  Future<List<Transaction>> getStatement(int clientId) async {
    return [];
  }
}
