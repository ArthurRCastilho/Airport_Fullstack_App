import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_aeroporto/core/const/api_url.dart';
import 'package:api_aeroporto/features/home/domain/models/voo.dart';

class VoosRepository {
  Future<List<Voo>> getVoos(String token) async {
    final response = await http.get(
      Uri.parse('${ApiUrl.baseUrl}/${ApiUrl.voosUrl}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Voo.fromJson(json)).toList();
    } else {
      throw Exception(
        json.decode(response.body)['message'] ?? 'Erro ao buscar voos',
      );
    }
  }
}
