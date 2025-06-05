import 'package:api_aeroporto/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:api_aeroporto/features/auth/presentation/views/register_screen.dart';
import 'package:flutter/material.dart';

class TextButtonForRegister extends StatelessWidget {
  const TextButtonForRegister({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ainda não tem conta?'),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text(
              'Cadastrar-se',
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
