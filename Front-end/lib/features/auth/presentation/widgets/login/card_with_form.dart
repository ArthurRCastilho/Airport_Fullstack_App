import 'package:api_aeroporto/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/login/form_login.dart';
import 'package:flutter/material.dart';

class CardWithForm extends StatelessWidget {
  const CardWithForm({
    super.key,
    required this.formKey,
    required this.viewModel,
  });

  final GlobalKey<FormState> formKey;
  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormLogin(formKey: formKey, viewModel: viewModel),
      ),
    );
  }
}