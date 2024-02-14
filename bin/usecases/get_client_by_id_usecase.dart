import '../models/client.dart';
import '../repositories/client_repository.dart';

class GetClientByID {
  final ClientRepository clientRepository;
  GetClientByID(this.clientRepository);

  Future<Client?> execute(int clientId) async {
    if (clientId == 0) {
      throw Exception("The field @clientId is required");
    }

    return await clientRepository.getClientByID(clientId);
  }
}
