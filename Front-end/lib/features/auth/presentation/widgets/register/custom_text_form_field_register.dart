import 'package:api_aeroporto/features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'package:flutter/material.dart';

class CustomTextFormFieldRegister extends StatelessWidget {
  const CustomTextFormFieldRegister({
    super.key,
    required this.viewModel,
    required this.controller,
    this.obscureText,
    required this.labelText,
    required this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
  });

  final RegisterViewModel viewModel;
  final TextEditingController controller;
  final bool? obscureText;
  final String labelText;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
