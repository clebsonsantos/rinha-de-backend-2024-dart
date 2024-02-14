import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../../bin/models/client.dart';
import '../../bin/repositories/client_repository.dart';
import '../../bin/usecases/get_client_by_id_usecase.dart';

class MockClientRepository extends Mock implements ClientRepository {}

void main() {
  group('GetClientByID Tests', () {
    final mockClientRepository = MockClientRepository();
    final getClientByID = GetClientByIDUseCase(mockClientRepository);

    test('GetClientByID - Valid Client ID', () async {
      when(mockClientRepository.getClientByID(1))
          .thenAnswer((invocation) async {
        final clientId = invocation.positionalArguments[0] as int;
        return Client(id: clientId, nome: 'Cliente', limite: 1000, saldo: 500);
      });

      final clientId = 1;
      final result = await getClientByID.execute(clientId);

      expect(result, isNotNull);
      expect(result?.id, equals(clientId));
      expect(result?.nome, equals('Cliente'));
      expect(result?.limite, equals(1000));
      expect(result?.saldo, equals(500));
    });

    test('GetClientByID - Invalid Client ID', () async {
      when(mockClientRepository.getClientByID(1)).thenAnswer((_) async => null);

      final clientId = 0;

      expect(() => getClientByID.execute(clientId), throwsException);
    });
  });
}
