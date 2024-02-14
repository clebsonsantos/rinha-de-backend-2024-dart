import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import '../usecases/get_client_by_id_usecase.dart';
import '../usecases/get_statement_by_id_usecase.dart';
import '../usecases/new_transaction_usecase.dart';

class ClientController {
  final NewTransactionUseCase _newTransaction;
  final GetClientByIDUseCase _getClientByID;
  final GetStatementByIdUseCase _getStatementByIdUseCase;

  ClientController(
      this._newTransaction, this._getClientByID, this._getStatementByIdUseCase);

  FutureOr<Response> createTransactionToClient(Request request) async {
    try {
      int clientId = int.parse(request.url.pathSegments[1]);

      final body = await request.readAsString();

      final result = await _newTransaction.execute(clientId, body);

      if (result != HttpStatus.ok) {
        return Response(result,
            headers: {HttpHeaders.contentTypeHeader: "application/json"});
      }

      final client = await _getClientByID.execute(clientId);
      return Response(HttpStatus.ok,
          body: jsonEncode(client!.toJson()),
          headers: {HttpHeaders.contentTypeHeader: "application/json"});
    } catch (e) {
      print(e);
      return Response.internalServerError();
    }
  }

  FutureOr<Response> getStatements(Request request) async {
    try {
      int clientId = int.parse(request.url.pathSegments[1]);

      final result = await _getStatementByIdUseCase.execute(clientId);

      if (result is int) {
        return Response(result,
            headers: {HttpHeaders.contentTypeHeader: "application/json"});
      }

      return Response(HttpStatus.ok,
          body: jsonEncode(result),
          headers: {HttpHeaders.contentTypeHeader: "application/json"});
    } catch (e) {
      print(e);
      return Response.internalServerError();
    }
  }
}
