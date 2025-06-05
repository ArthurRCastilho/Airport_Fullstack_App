import 'package:api_aeroporto/features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/register/button_register_user.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/register/custom_dropdown_button.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/register/custom_text_form_field_register.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/register/text_button_for_login.dart';
import 'package:api_aeroporto/features/auth/presentation/widgets/register/title_form_register.dart';
import 'package:api_aeroporto/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';

class FormRegister extends StatelessWidget {
  const FormRegister({
    super.key,
    required this.formKey,
    required this.viewModel,
  });

  final GlobalKey<FormState> formKey;
  final RegisterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleFormRegister(),
            CustomTextFormFieldRegister(
              viewModel: viewModel,
              controller: viewModel.nameController,
              labelText: 'Nome',
              prefixIcon: Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextFormFieldRegister(
              viewModel: viewModel,
              controller: viewModel.emailController,
              labelText: 'email',
              prefixIcon: Icon(Icons.email),
              validator: viewModel.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextFormFieldRegister(
              viewModel: viewModel,
              controller: viewModel.passwordController,
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock),
              validator: viewModel.validatePassword,
              suffixIcon: IconButton(
                onPressed: viewModel.togglePasswordVisibility,
                icon: Icon(
                  viewModel.isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropwdownButton(viewModel: viewModel),
            const SizedBox(height: 24),
            ButtonRegisterUser(
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
            TextButtonForLogin(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
