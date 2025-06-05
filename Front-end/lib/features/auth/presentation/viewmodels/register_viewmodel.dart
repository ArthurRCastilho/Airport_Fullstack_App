import 'package:flutter/material.dart';
import 'package:api_aeroporto/features/auth/data/repositories/auth_repository.dart';
import 'package:api_aeroporto/features/auth/data/services/token_service.dart';
import 'package:api_aeroporto/features/auth/domain/models/user.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final TokenService _tokenService = TokenService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedRole = 'funcionario';
  bool isPasswordVisible = false;
  bool isLoading = false;
  String? errorMessage;
  User? registeredUser;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void setRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pop(context);
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    if (value.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu email';
    }
    if (!value.contains('@')) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  Future<bool> handleRegister() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      errorMessage = 'Todos os campos devem ser preenchidos';
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _repository.register(
        nome: nameController.text,
        email: emailController.text,
        senha: passwordController.text,
        cargo: selectedRole,
      );

      print('Registro bem-sucedido: $result');
      registeredUser = User.fromJson(result['funcionario']);

      // Salvar o token
      await _tokenService.saveToken(result['token']);

      // Limpar campos após sucesso
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      print('Erro ao fazer cadastro: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
