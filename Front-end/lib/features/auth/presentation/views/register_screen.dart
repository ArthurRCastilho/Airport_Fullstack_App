import 'package:api_aeroporto/features/auth/presentation/widgets/register/card_with_register_form.dart';
import 'package:api_aeroporto/shared/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: CardWithRegisterForm(
            formKey: formKey,
            viewModel: viewModel,
          ),
        ),
      ),
    );
  }
}
