import 'package:api_aeroporto/features/home/domain/models/voo.dart';

class Passageiro {
  final String? statusCheckin;
  final String id;
  final String nome;
  final String cpf;
  final Voo? voo;

  Passageiro({
    required this.statusCheckin,
    required this.id,
    required this.nome,
    required this.cpf,
    required this.voo,
  });

  factory Passageiro.fromJson(Map<String, dynamic> json) {
    final vooJson = json['vooId'];
    final Voo? parsedVoo =
        vooJson != null && vooJson is Map<String, dynamic>
            ? Voo.fromJson(vooJson)
            : null;

    return Passageiro(
      statusCheckin: json['statusCheckin'],
      id: json['_id'],
      nome: json['nome'],
      cpf: json['cpf'],
      voo: parsedVoo,
    );
  }
}
