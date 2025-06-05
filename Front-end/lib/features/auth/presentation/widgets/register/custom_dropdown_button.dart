import 'package:api_aeroporto/features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'package:flutter/material.dart';

class CustomDropwdownButton extends StatelessWidget {
  const CustomDropwdownButton({
    super.key,
    required this.viewModel,
  });

  final RegisterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: viewModel.selectedRole,
      decoration: const InputDecoration(
        labelText: 'Cargo',
        prefixIcon: Icon(Icons.work),
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: 'admin',
          child: Text('Administrador'),
        ),
        DropdownMenuItem(
          value: 'funcionario',
          child: Text('Funcionário'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          viewModel.setRole(value);
        }
      },
    );
  }
}
