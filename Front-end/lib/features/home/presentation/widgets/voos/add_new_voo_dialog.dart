import 'package:api_aeroporto/features/home/presentation/viewmodels/voos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddNewVooDialog extends StatelessWidget {
  const AddNewVooDialog({super.key, required this.mounted});

  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Consumer<VoosViewModel>(
      builder: (context, viewModel, child) {
        return AlertDialog(
          title: const Text('Novo Voo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: viewModel.origemController,
                  decoration: const InputDecoration(
                    labelText: 'Origem',
                    hintText: 'Ex: São Paulo',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: viewModel.destinoController,
                  decoration: const InputDecoration(
                    labelText: 'Destino',
                    hintText: 'Ex: Rio de Janeiro',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Data e Hora de Partida'),
                  subtitle: Text(
                    viewModel.dataHoraPartida != null
                        ? DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(viewModel.dataHoraPartida!)
                        : 'Selecione a data e hora',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 365),
                      ),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        viewModel.setDataHoraPartida(
                          DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: viewModel.selectedPortaoId,
                  decoration: const InputDecoration(
                    labelText: 'Portão',
                    hintText: 'Selecione um portão',
                  ),
                  items:
                      viewModel.portoesDisponiveis.map((portao) {
                        return DropdownMenuItem(
                          value: portao.id,
                          child: Text('Portão ${portao.codigo}'),
                        );
                      }).toList(),
                  onChanged: viewModel.setSelectedPortaoId,
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
                final success = await viewModel.saveNewVoo();
                if (success && mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Voo criado com sucesso!',
                        selectionColor: Colors.green,
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child:
                  viewModel.isSavingVoo
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
