import 'package:api_aeroporto/features/home/domain/models/voo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/voos_view_model.dart';

class CardVoo extends StatelessWidget {
  const CardVoo({
    super.key,
    required this.voo,
    required this.formattedDate,
  });

  final Voo voo;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeViewModel, VoosViewModel>(
      builder: (context, homeViewModel, voosViewModel, child) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Row(
              children: [
                Expanded(child: Text('Voo ${voo.numeroVoo}')),
                if (homeViewModel.canManagePortoes)
                  if (voo.status == 'programado')
                    IconButton(
                      icon: const Icon(Icons.flight_takeoff),
                      tooltip: 'Iniciar Embarque',
                      onPressed: () async {
                        final success = await voosViewModel
                            .atualizarStatusVoo(voo.id, 'embarque');
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Status do voo atualizado para embarque',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                voosViewModel.error ??
                                    'Erro ao atualizar status',
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    )
                  else if (voo.status == 'embarque')
                    IconButton(
                      icon: const Icon(Icons.check_circle),
                      tooltip: 'Concluir Voo',
                      onPressed: () async {
                        final success = await voosViewModel
                            .atualizarStatusVoo(voo.id, 'concluido');
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Status do voo atualizado para concluído',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                voosViewModel.error ??
                                    'Erro ao atualizar status',
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Origem: ${voo.origem}'),
                Text('Destino: ${voo.destino}'),
                Text('Partida: $formattedDate'),
                Text('Status: ${voo.status}'),
                Text('Portão: ${voo.portao?.codigo ?? 'Não atribuído'}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
