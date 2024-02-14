import 'dart:io';

import '../repositories/client_repository.dart';
import '../repositories/transaction_repository.dart';

class GetStatementByIdUseCase {
  final TransactionRepository transactionRepository;
  final ClientRepository clientRepository;
  GetStatementByIdUseCase(this.transactionRepository, this.clientRepository);

  Future<Object> execute(int clientId) async {
    if (clientId == 0) {
      throw Exception("The field @clientId is required");
    }

    final client = await clientRepository.getClientByID(clientId);

    if (client == null) {
      return HttpStatus.notFound;
    }

    final result = await transactionRepository.getStatement(clientId);
    return result;
  }
}
