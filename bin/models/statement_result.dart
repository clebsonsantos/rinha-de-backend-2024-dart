class StatementResult {
  Map<String, dynamic> toJSON(Map<String, dynamic> json) {
    var transactions = List<Map<String, dynamic>>.from(
        json['resultado']['ultimas_transacoes']);
    if (transactions[0]['tipo'] == null) {
      transactions = [];
    }
    return {
      'saldo': Map<String, dynamic>.from(json['resultado']['saldo']),
      'ultimas_transacoes': transactions
    };
  }
}
