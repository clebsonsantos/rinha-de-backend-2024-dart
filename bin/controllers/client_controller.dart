import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import '../repositories/transaction_repository.dart';

class ClientController {
  final TransactionRepository transactionRepository;

  ClientController(this.transactionRepository);

  FutureOr<Response> createTransactionToClient(Request request) async {
    try {
      int clientID = int.parse(request.url.pathSegments[1]);
      final body = await request.readAsString();
      final Map<String, dynamic> transaction = jsonDecode(body);
      await transactionRepository.createTransaction(clientID, transaction);

      return Response(201,
          body: jsonEncode({"limite": 100000, "saldo": -9098}),
          headers: {HttpHeaders.contentTypeHeader: "application/json"});
    } catch (e) {
      print(e.toString());
      return Response.internalServerError(
        body: jsonEncode({"error": e.toString()}),
      );
    }
  }
}
