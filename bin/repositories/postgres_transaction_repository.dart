import 'package:postgres/postgres.dart';

import '../models/statement_result.dart';
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
  Future<Map<String, dynamic>> getStatement(int clientId) async {
    final result = await _connection.query(
      '''
      SELECT
        jsonb_build_object(
          'saldo',
          jsonb_build_object(
            'total', c.saldo,
            'data_extrato',  NOW(),
            'limite', c.limite
          ),
          'ultimas_transacoes',
          jsonb_agg(
            jsonb_build_object(
              'valor', t.valor,
              'tipo', t.tipo,
              'descricao', t.descricao,
              'realizada_em', t.realizada_em
            )
          )
        ) AS resultado
      FROM clientes c
      LEFT JOIN transacoes t ON c.id = t.cliente_id
      WHERE c.id = @clientId
      GROUP BY c.id, c.saldo, c.limite;
      ''',
      substitutionValues: {'clientId': clientId},
    );

    final statement = result[0].toColumnMap();
    return StatementResult().toJSON(statement);
  }
}
