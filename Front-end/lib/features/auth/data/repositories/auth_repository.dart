import 'dart:convert';
import 'package:api_aeroporto/core/const/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:api_aeroporto/features/auth/data/services/token_service.dart';

class AuthRepository {
  final String baseUrl = ApiUrl.baseUrl;
  final String registerUrl = ApiUrl.registerUrl;
  final String loginUrl = ApiUrl.loginUrl;
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> register({
    required String nome,
    required String email,
    required String senha,
    required String cargo,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$registerUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'cargo': cargo,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Erro ao cadastrar',
      );
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$loginUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Erro ao fazer login',
      );
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final token = await _tokenService.getToken();
    if (token == null) {
      throw Exception('Usuário não autenticado');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Falha ao obter informações do usuário: ${response.body}',
      );
    }
  }
}
