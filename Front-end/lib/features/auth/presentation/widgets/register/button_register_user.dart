import 'package:api_aeroporto/features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'package:flutter/material.dart';

class ButtonRegisterUser extends StatefulWidget {
  const ButtonRegisterUser({
    super.key,
    required this.viewModel,
    required this.formKey,
    required this.onSuccess,
  });

  final RegisterViewModel viewModel;
  final GlobalKey<FormState> formKey;
  final Function() onSuccess;

  @override
  State<ButtonRegisterUser> createState() => _ButtonRegisterUserState();
}

class _ButtonRegisterUserState extends State<ButtonRegisterUser> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          print('teste');
          final success = await widget.viewModel.handleRegister();
          if (success) {
            print('teste2');
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
                  'Cadastrar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
      ),
    );
  }
}
