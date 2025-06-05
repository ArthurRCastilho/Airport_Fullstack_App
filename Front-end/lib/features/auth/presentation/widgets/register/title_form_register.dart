import 'package:flutter/material.dart';

class TitleFormRegister extends StatelessWidget {
  const TitleFormRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.person_add, size: 80, color: Colors.blue),
        const SizedBox(height: 24),
        const Text(
          'Cadastro de Usuário',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
