import 'package:api_aeroporto/features/home/presentation/viewmodels/portoes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPortaoDialog extends StatelessWidget {
  const AddPortaoDialog({
    super.key,
    required this.mounted,
  });

  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Consumer<PortoesViewModel>(
      builder: (context, viewModel, child) {
        return AlertDialog(
          title: const Text('Novo Portão'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: viewModel.newPortaoCodigoController,
                decoration: const InputDecoration(
                  labelText: 'Código do Portão',
                  hintText: 'Ex: Z6',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Disponível:'),
                  const SizedBox(width: 8),
                  Switch(
                    value: viewModel.newPortaoDisponivel,
                    onChanged: viewModel.setNewPortaoDisponivel,
                  ),
                ],
              ),
            ],
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
                final success = await viewModel.saveNewPortao();
                if (success && mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Portão criado com sucesso!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child:
                  viewModel.isSavingPortao
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
