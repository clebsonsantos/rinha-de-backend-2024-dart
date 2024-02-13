import 'package:postgres/postgres.dart';

class Client {
  Client({
    required this.id,
    required this.nome,
    required this.limite,
  });

  final int id;
  final String nome;
  final int limite;

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as int,
      nome: json['nome'] as String,
      limite: json['limite'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'limite': limite,
    };
  }

  factory Client.convertRowToClient(PostgreSQLResultRow clientRow) {
    return Client(
        id: int.parse(clientRow.toColumnMap()['id']),
        nome: clientRow.toColumnMap()['nome'],
        limite: int.parse(clientRow.toColumnMap()['limite']));
  }
}
