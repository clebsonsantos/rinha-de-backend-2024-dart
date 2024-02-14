abstract class TransactionRepository {
  Future<void> createTransaction(
      int clientId, Map<String, dynamic> transaction);
  Future<Map<String, dynamic>> getStatement(int clientId);
}
