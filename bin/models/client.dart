import 'package:postgres/postgres.dart';

class Client {
  Client({
    required this.id,
    required this.nome,
    required this.limite,
    required this.saldo,
  });

  final int id;
  final String nome;
  final int limite;
  int saldo;

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as int,
      nome: json['nome'] as String,
      limite: json['limite'] as int,
      saldo: json['saldo'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limite': limite,
      'saldo': saldo,
    };
  }

  factory Client.convertRowToClient(PostgreSQLResultRow clientRow) {
    final client = clientRow.toColumnMap();
    return Client(
        id: client['id'],
        nome: client['nome'],
        limite: client['limite'],
        saldo: client['saldo']);
  }
}
