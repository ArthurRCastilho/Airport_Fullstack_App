import 'package:api_aeroporto/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/login/button_login.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/login/custom_text_form_field.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/login/text_button_for_register.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/login/title_form_login.dart';
import 'package:api_aeroporto/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';

class FormLogin extends StatelessWidget {
  const FormLogin({
    super.key,
    required this.formKey,
    required this.viewModel,
  });

  final GlobalKey<FormState> formKey;
  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TitleFormLogin(),
          CustomTextFormField(
            viewModel: viewModel,
            controller: viewModel.emailController,
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            keyboardType: TextInputType.emailAddress,
            validator: viewModel.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            viewModel: viewModel,
            controller: viewModel.passwordController,
            labelText: 'Senha',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: viewModel.togglePasswordVisibility,
              icon: Icon(
                viewModel.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
            ),
            validator: viewModel.validatePassword,
          ),
          const SizedBox(height: 24),
          ButtonLogin(
            viewModel: viewModel,
            formKey: formKey,
            onSuccess: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeView(),
                ),
                (route) => false,
              );
            },
          ),
          TextButtonForRegister(viewModel: viewModel),
        ],
      ),
    );
  }
}
