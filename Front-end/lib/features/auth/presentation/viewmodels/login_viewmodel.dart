import 'package:flutter/material.dart';
import 'package:api_aeroporto/features/auth/data/repositories/auth_repository.dart';
import 'package:api_aeroporto/features/auth/data/services/token_service.dart';
import 'package:api_aeroporto/features/auth/domain/models/user.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final TokenService _tokenService = TokenService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;
  String? errorMessage;
  User? loggedUser;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
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

  Future<bool> handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage = 'Todos os campos devem ser preenchidos';
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _repository.login(
        email: emailController.text,
        senha: passwordController.text,
      );

      print('Login bem-sucedido: $result');

      loggedUser = User.fromJson(result['funcionario']);
      await _tokenService.saveToken(result['token']);

      // Limpar campos após sucesso
      emailController.clear();
      passwordController.clear();
      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      print(errorMessage);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
