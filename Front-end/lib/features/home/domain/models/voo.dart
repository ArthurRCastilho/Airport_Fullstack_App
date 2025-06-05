import 'package:api_aeroporto/features/home/domain/models/portao.dart';

class Voo {
  final String id;
  final int numeroVoo;
  final String origem;
  final String destino;
  final DateTime dataHoraPartida;
  final String status;
  final Portao? portao;

  Voo({
    required this.id,
    required this.numeroVoo,
    required this.origem,
    required this.destino,
    required this.dataHoraPartida,
    required this.status,
    required this.portao,
  });

  factory Voo.fromJson(Map<String, dynamic> json) {
    final portaoJson = json['portaoId'];
    final Portao? parsedPortao =
        portaoJson != null && portaoJson is Map<String, dynamic>
            ? Portao.fromJson(portaoJson)
            : null;

    return Voo(
      id: json['_id'],
      numeroVoo: json['numeroVoo'],
      origem: json['origem'],
      destino: json['destino'],
      dataHoraPartida: DateTime.parse(json['dataHoraPartida']),
      status: json['status'],
      portao: parsedPortao,
    );
  }
}
