import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import '../../bin/usecases/new_transaction_usecase.dart';
import '../../bin/repositories/client_repository.dart';
import '../../bin/repositories/transaction_repository.dart';
import '../../bin/models/client.dart';

class MockClientRepository extends Mock implements ClientRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group('NewTransactionUseCase Tests', () {
    late NewTransactionUseCase useCase;
    late MockClientRepository mockClientRepository;
    late MockTransactionRepository mockTransactionRepository;

    setUp(() {
      mockClientRepository = MockClientRepository();
      mockTransactionRepository = MockTransactionRepository();
      useCase = NewTransactionUseCase(
          mockClientRepository, mockTransactionRepository);
    });

    test('Successful Transaction', () async {
      const clientId = 1;
      final transactionBody = '{"valor": 500, "tipo": "c"}';
      final client =
          Client(id: clientId, nome: 'Test Client', limite: 1000, saldo: 1000);

      when(mockClientRepository.getClientByID(clientId))
          .thenAnswer((_) async => client);

      final result = await useCase.execute(clientId, transactionBody);

      expect(result, equals(HttpStatus.ok));
      expect(client.saldo, equals(1500));
      verify(mockClientRepository.updateClient(client)).called(1);
      verify(mockTransactionRepository.createTransaction(
              clientId, jsonDecode(transactionBody)))
          .called(1);
    });

    test('Unprocessable Entity - Insufficient Balance', () async {
      final clientId = 1;
      final body = '{"valor": 100000, "tipo": "d", "descricao": "Descrição"}';
      final client =
          Client(id: clientId, nome: 'Test Client', limite: 1000, saldo: 1000);

      when(mockClientRepository.getClientByID(clientId))
          .thenAnswer((_) async => client);

      final response = await useCase.execute(clientId, body);

      expect(response, equals(HttpStatus.unprocessableEntity));
      expect(client.saldo, equals(1000));
      verifyNever(mockClientRepository.updateClient(client));
      verifyNever(mockTransactionRepository.createTransaction(
          clientId, jsonDecode(body)));
    });
  });
}
