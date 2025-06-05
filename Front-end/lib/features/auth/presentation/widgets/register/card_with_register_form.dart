import 'package:api_aeroporto/features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/register/form_register.dart';
import 'package:flutter/material.dart';

class CardWithRegisterForm extends StatelessWidget {
  const CardWithRegisterForm({
    super.key,
    required this.formKey,
    required this.viewModel,
  });

  final GlobalKey<FormState> formKey;
  final RegisterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: FormRegister(formKey: formKey, viewModel: viewModel),
    );
  }
}