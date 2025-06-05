import 'package:api_aeroporto/features/auth/presentation/widgets/login/card_with_form.dart';
import 'package:api_aeroporto/shared/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: CardWithForm(formKey: formKey, viewModel: viewModel),
        ),
      ),
    );
  }
}
