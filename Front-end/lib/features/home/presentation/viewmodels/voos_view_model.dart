import 'package:api_aeroporto/features/home/domain/models/portao.dart';
import 'package:flutter/material.dart';
import 'package:api_aeroporto/features/home/domain/models/voo.dart';
import 'package:api_aeroporto/features/auth/data/services/token_service.dart';
import 'package:api_aeroporto/core/const/api_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoosViewModel extends ChangeNotifier {
  final TokenService _tokenService = TokenService();

  List<Voo> _voos = [];
  List<Voo> get voos => _voos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  final _origemController = TextEditingController();
  final _destinoController = TextEditingController();
  DateTime? _dataHoraPartida;
  String? _selectedPortaoId;
  List<Portao> _portoesDisponiveis = [];
  bool _isSavingVoo = false;

  TextEditingController get origemController => _origemController;
  TextEditingController get destinoController => _destinoController;
  DateTime? get dataHoraPartida => _dataHoraPartida;
  String? get selectedPortaoId => _selectedPortaoId;
  List<Portao> get portoesDisponiveis => _portoesDisponiveis;
  bool get isSavingVoo => _isSavingVoo;

  @override
  void dispose() {
    _origemController.dispose();
    _destinoController.dispose();
    super.dispose();
  }

  Future<void> loadVoos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        _error = 'Token não encontrado';
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiUrl.baseUrl}/${ApiUrl.voosUrl}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _voos = data.map((json) => Voo.fromJson(json)).toList();
      } else {
        _error = 'Erro ao carregar voos: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Erro ao carregar voos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPortoesDisponiveis() async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        _error = 'Token não encontrado';
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiUrl.baseUrl}/${ApiUrl.portoesUrl}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _portoesDisponiveis =
            data
                .map((json) => Portao.fromJson(json))
                .where((portao) => portao.disponivel)
                .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao carregar portões disponíveis: $e');
    }
  }

  void resetForm() {
    _origemController.clear();
    _destinoController.clear();
    _dataHoraPartida = null;
    _selectedPortaoId = null;
    _isSavingVoo = false;
    notifyListeners();
  }

  void setDataHoraPartida(DateTime dateTime) {
    _dataHoraPartida = dateTime;
    notifyListeners();
  }

  void setSelectedPortaoId(String? portaoId) {
    _selectedPortaoId = portaoId;
    notifyListeners();
  }

  Future<bool> saveNewVoo() async {
    if (_origemController.text.isEmpty ||
        _destinoController.text.isEmpty ||
        _dataHoraPartida == null ||
        _selectedPortaoId == null) {
      _error = 'Preencha todos os campos';
      notifyListeners();
      return false;
    }

    _isSavingVoo = true;
    notifyListeners();

    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        _error = 'Token não encontrado';
        return false;
      }

      // Encontrar o maior número de voo
      final maiorNumeroVoo =
          _voos.isEmpty
              ? 0
              : _voos
                  .map((v) => v.numeroVoo)
                  .reduce((a, b) => a > b ? a : b);

      final response = await http.post(
        Uri.parse('${ApiUrl.baseUrl}/${ApiUrl.voosUrl}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'numeroVoo': maiorNumeroVoo + 1,
          'origem': _origemController.text,
          'destino': _destinoController.text,
          'dataHoraPartida': _dataHoraPartida!.toIso8601String(),
          'portaoId': _selectedPortaoId,
          'status': 'programado',
        }),
      );

      if (response.statusCode == 201) {
        await loadVoos();
        return true;
      } else {
        _error = 'Erro ao criar voo: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      _error = 'Erro ao criar voo: $e';
      return false;
    } finally {
      _isSavingVoo = false;
      notifyListeners();
    }
  }

  Future<bool> atualizarStatusVoo(String vooId, String novoStatus) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        _error = 'Token não encontrado';
        return false;
      }

      final response = await http.patch(
        Uri.parse(
          '${ApiUrl.baseUrl}/${ApiUrl.voosUrl}/$vooId/${ApiUrl.statusVoo}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'status': novoStatus}),
      );

      if (response.statusCode == 200) {
        await loadVoos(); // Recarrega a lista de voos
        return true;
      } else {
        _error = 'Erro ao atualizar status do voo: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      _error = 'Erro ao atualizar status do voo: $e';
      return false;
    }
  }
}
