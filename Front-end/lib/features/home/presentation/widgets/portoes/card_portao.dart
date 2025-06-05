import 'package:api_aeroporto/features/home/domain/models/portao.dart';
import 'package:flutter/material.dart';

class CardPortao extends StatelessWidget {
  const CardPortao({super.key, required this.portao});

  final Portao portao;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(
          Icons.door_front_door,
          color: portao.disponivel ? Colors.green : Colors.red,
        ),
        title: Text('Portão ${portao.codigo}'),
        subtitle: Text(
          portao.disponivel ? 'Disponível' : 'Ocupado',
          style: TextStyle(
            color: portao.disponivel ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
