import 'dart:convert';
import 'dart:io';

import '../repositories/client_repository.dart';
import '../repositories/transaction_repository.dart';

class NewTransactionUseCase {
  final TransactionRepository transactionRepository;
  final ClientRepository clientRepository;
  NewTransactionUseCase(this.clientRepository, this.transactionRepository);

  Future<int> execute(int clientId, String body) async {
    final client = await clientRepository.getClientByID(clientId);

    if (client == null) {
      return HttpStatus.notFound;
    }

    final Map<String, dynamic> transaction = jsonDecode(body);
    int transactionValue = transaction['valor'];

    int newBalance = transaction['tipo'] == "d"
        ? (client.saldo - transactionValue)
        : (client.saldo + transactionValue);

    if (newBalance < -client.limite) {
      return HttpStatus.unprocessableEntity;
    }

    client.saldo = newBalance;
    await clientRepository.updateClient(client);

    await transactionRepository.createTransaction(clientId, transaction);
    return HttpStatus.ok;
  }
}
