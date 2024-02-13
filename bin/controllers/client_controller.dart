import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import '../repositories/client_repository.dart';
import '../repositories/transaction_repository.dart';

class ClientController {
  final TransactionRepository transactionRepository;
  final ClientRepository clientRepository;

  ClientController(this.transactionRepository, this.clientRepository);

  FutureOr<Response> createTransactionToClient(Request request) async {
    try {
      int clientId = int.parse(request.url.pathSegments[1]);

      final client = await clientRepository.getClientByID(clientId);
      if (client == null) {
        return Response(HttpStatus.notFound,
            headers: {HttpHeaders.contentTypeHeader: "application/json"});
      }

      final body = await request.readAsString();
      final Map<String, dynamic> transaction = jsonDecode(body);
      await transactionRepository.createTransaction(clientId, transaction);

      return Response(HttpStatus.ok,
          body: jsonEncode({"limite": 100000, "saldo": -9098}),
          headers: {HttpHeaders.contentTypeHeader: "application/json"});
    } catch (e) {
      print(e.toString());
      return Response.internalServerError();
    }
  }
}
