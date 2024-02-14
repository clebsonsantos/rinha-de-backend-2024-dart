import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import '../usecases/get_client_by_id_usecase.dart';
import '../usecases/new_transaction_usecase.dart';

class ClientController {
  final NewTransactionUseCase newTransaction;
  final GetClientByID getClientByID;

  ClientController(this.newTransaction, this.getClientByID);

  FutureOr<Response> createTransactionToClient(Request request) async {
    try {
      int clientId = int.parse(request.url.pathSegments[1]);

      final body = await request.readAsString();

      final result = await newTransaction.execute(clientId, body);

      if (result != HttpStatus.ok) {
        return Response(result,
            headers: {HttpHeaders.contentTypeHeader: "application/json"});
      }

      final client = await getClientByID.execute(clientId);
      return Response(HttpStatus.ok,
          body: jsonEncode(client!.toJson()),
          headers: {HttpHeaders.contentTypeHeader: "application/json"});
    } catch (e) {
      print(e);
      return Response.internalServerError();
    }
  }
}
