class Transaction {
  final int id;
  final int clientId;
  final double value;
  final String type;
  final String description;

  Transaction({
    required this.id,
    required this.clientId,
    required this.value,
    required this.type,
    required this.description,
  });
}
