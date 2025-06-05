import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_aeroporto/core/const/api_url.dart';
import 'package:api_aeroporto/features/auth/data/services/token_service.dart';
import 'package:api_aeroporto/features/home/domain/models/portao.dart';

class PortoesRepository {
  final String baseUrl = ApiUrl.baseUrl;
  final String portoesUrl = ApiUrl.portoesUrl;
  final TokenService _tokenService = TokenService();

  Future<List<Portao>> getPortoes() async {
    final token = await _tokenService.getToken();
    if (token == null) {
      throw Exception('Usuário não autenticado');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$portoesUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Portao.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar portões: ${response.body}');
    }
  }

  Future<Portao> createPortao(String codigo, bool disponivel) async {
    final token = await _tokenService.getToken();
    if (token == null) {
      throw Exception('Usuário não autenticado');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/$portoesUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'codigo': codigo, 'disponivel': disponivel}),
    );

    if (response.statusCode == 201) {
      return Portao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao criar portão: ${response.body}');
    }
  }
}
