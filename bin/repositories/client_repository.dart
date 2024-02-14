import '../models/client.dart';

abstract class ClientRepository {
  Future<Client?> getClientByID(int clientId);
  Future<void> updateClient(Client client);
}
