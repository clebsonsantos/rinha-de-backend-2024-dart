import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import '../usecases/new_transaction.dart';

class ClientController {
  final NewTransactionUseCase newTransaction;

  ClientController(this.newTransaction);

  FutureOr<Response> createTransactionToClient(Request request) async {
    try {
      int clientId = int.parse(request.url.pathSegments[1]);

      final body = await request.readAsString();

      final result = await newTransaction.execute(clientId, body);

      if (result != HttpStatus.ok) {
        return Response(result,
            headers: {HttpHeaders.contentTypeHeader: "application/json"});
      }

      return Response(HttpStatus.ok,
          body: jsonEncode({"limite": 100000, "saldo": -9098}),
          headers: {HttpHeaders.contentTypeHeader: "application/json"});
    } catch (e) {
      print(e);
      return Response.internalServerError();
    }
  }
}
