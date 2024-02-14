import 'transaction_type.dart';

class Transaction {
  final int id;
  final int clientId;
  final double valor;
  final TransactionType tipo;
  final String descricao;

  Transaction({
    required this.id,
    required this.clientId,
    required this.valor,
    required this.tipo,
    required this.descricao,
  });
}
