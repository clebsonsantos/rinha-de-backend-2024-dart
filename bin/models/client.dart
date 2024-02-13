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
    final client = clientRow.toColumnMap();
    return Client(
        id: int.parse(client['id']),
        nome: client['nome'],
        limite: int.parse(client['limite']));
  }
}
