import 'package:api_aeroporto/features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'package:flutter/material.dart';

class TextButtonForLogin extends StatelessWidget {
  const TextButtonForLogin({super.key, required this.viewModel});

  final RegisterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Já possui conta?'),
          TextButton(
            onPressed: () => viewModel.navigateToLogin(context),
            child: const Text(
              'Logar-se',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
