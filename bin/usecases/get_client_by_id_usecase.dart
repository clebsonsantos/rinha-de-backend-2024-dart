import '../models/client.dart';
import '../repositories/client_repository.dart';

class GetClientByIDUseCase {
  final ClientRepository clientRepository;
  GetClientByIDUseCase(this.clientRepository);

  Future<Client?> execute(int clientId) async {
    if (clientId == 0) {
      throw Exception("The field @clientId is required");
    }

    return await clientRepository.getClientByID(clientId);
  }
}
