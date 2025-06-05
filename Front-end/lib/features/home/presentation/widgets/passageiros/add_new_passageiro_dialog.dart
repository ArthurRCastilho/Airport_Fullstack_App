import 'package:api_aeroporto/features/home/presentation/viewmodels/passageiros_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewPassageiroDialog extends StatelessWidget {
  const AddNewPassageiroDialog({
    super.key,
    required this.mounted,
  });

  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Consumer<PassageirosViewModel>(
      builder: (context, viewModel, child) {
        return AlertDialog(
          title: const Text('Novo Passageiro'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: viewModel.nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    hintText: 'Ex: João Silva',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    hintText: 'Ex: 000.111.222-33',
                  ),
                  validator: viewModel.cpfValidator,
                  autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: viewModel.selectedVooId,
                  decoration: const InputDecoration(
                    labelText: 'Voo',
                    hintText: 'Selecione um voo programado',
                  ),
                  isExpanded: true,
                  items:
                      viewModel.voosDisponiveis.map((voo) {
                        return DropdownMenuItem(
                          value: voo.id,
                          child: Text(
                            'Voo ${voo.numeroVoo} - ${voo.origem} para ${voo.destino}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                  onChanged: viewModel.setSelectedVooId,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                viewModel.resetForm();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final success = await viewModel.saveNewPassageiro();
                if (success && mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Passageiro criado com sucesso!',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        viewModel.error ??
                            'Erro ao criar passageiro',
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child:
                  viewModel.isSavingPassageiro
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                      : const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
