class Portao {
  final String id;
  final String codigo;
  final bool disponivel;

  Portao({
    required this.id,
    required this.codigo,
    required this.disponivel,
  });

  factory Portao.fromJson(Map<String, dynamic> json) {
    return Portao(
      id: json['_id'],
      codigo: json['codigo'],
      disponivel: json['disponivel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'codigo': codigo, 'disponivel': disponivel};
  }
}
