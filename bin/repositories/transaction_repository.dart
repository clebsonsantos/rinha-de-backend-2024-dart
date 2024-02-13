import '../models/transaction.dart';

abstract class TransactionRepository {
  Future<void> createTransaction(
      int clientId, Map<String, dynamic> transaction);
  Future<List<Transaction>> getStatement(int clientId);
}
