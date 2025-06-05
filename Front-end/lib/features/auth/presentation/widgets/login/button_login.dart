import 'package:api_aeroporto/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';

class ButtonLogin extends StatefulWidget {
  const ButtonLogin({
    super.key,
    required this.viewModel,
    required this.formKey,
    required this.onSuccess,
  });

  final LoginViewModel viewModel;
  final GlobalKey<FormState> formKey;
  final Function() onSuccess;

  @override
  State<ButtonLogin> createState() => _ButtonLoginState();
}

class _ButtonLoginState extends State<ButtonLogin> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          final success = await widget.viewModel.handleLogin();
          if (success) {
            widget.onSuccess();
          } else if (!success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.viewModel.errorMessage ?? 'Erro ao cadastrar',
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child:
            widget.viewModel.isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
      ),
    );
  }
}
