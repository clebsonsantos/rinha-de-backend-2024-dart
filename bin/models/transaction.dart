class Transaction {
  final int id;
  final int clientId;
  final double valor;
  final String tipo;
  final String descricao;

  Transaction({
    required this.id,
    required this.clientId,
    required this.valor,
    required this.tipo,
    required this.descricao,
  });
}
