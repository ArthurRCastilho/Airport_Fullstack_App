import 'package:api_aeroporto/features/home/domain/models/passageiro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/passageiros_view_model.dart';

class CardPassageiro extends StatelessWidget {
  const CardPassageiro({super.key, required this.passageiro});

  final Passageiro passageiro;

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeViewModel, PassageirosViewModel>(
      builder: (context, homeViewModel, passageirosViewModel, child) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(
              Icons.person,
              color:
                  passageiro.statusCheckin == 'realizado'
                      ? Colors.green
                      : Colors.orange,
            ),
            title: Row(
              children: [
                Expanded(child: Text(passageiro.nome)),
                if (homeViewModel.canManagePortoes &&
                    passageiro.statusCheckin == 'pendente' &&
                    passageiro.voo != null &&
                    passageiro.voo!.status == 'embarque')
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    tooltip: 'Realizar Check-in',
                    onPressed: () async {
                      try {
                        await passageirosViewModel.atualizarStatusCheckin(
                          passageiro.id,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Check-in realizado com sucesso!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Erro ao realizar check-in: $e',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CPF: ${passageiro.cpf}'),
                Text('Check-in: ${passageiro.statusCheckin}'),
                if (passageiro.voo != null) ...[
                  Text(
                    'Voo: ${passageiro.voo!.numeroVoo} (${passageiro.voo!.origem} -> ${passageiro.voo!.destino})',
                  ),
                  Text('Status do Voo: ${passageiro.voo!.status}'),
                ],
                if (passageiro.voo == null) ...[
                  const Text('Voo: Não atribuído'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
