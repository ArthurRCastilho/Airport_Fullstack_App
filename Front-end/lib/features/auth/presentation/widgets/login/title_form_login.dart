import 'package:flutter/material.dart';

class TitleFormLogin extends StatelessWidget {
  const TitleFormLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.flight_takeoff, size: 80, color: Colors.blue),
        const SizedBox(height: 24),
        const Text(
          'Bem-vindo ao Sistema de Voos',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
