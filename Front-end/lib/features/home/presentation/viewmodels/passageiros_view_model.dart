import 'package:flutter/material.dart';
import 'package:api_aeroporto/features/home/data/repositories/passageiros_repository.dart';
import 'package:api_aeroporto/features/home/domain/models/passageiro.dart';
import 'package:api_aeroporto/features/home/domain/models/voo.dart';
import 'package:api_aeroporto/features/auth/data/services/token_service.dart';
import 'package:api_aeroporto/core/const/api_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PassageirosViewModel extends ChangeNotifier {
  final PassageirosRepository _repository = PassageirosRepository();
  final TokenService _tokenService = TokenService();

  List<Passageiro> _passageiros = [];
  List<Passageiro> get passageiros => _passageiros;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Controllers e estados para o formulário
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  String? _selectedVooId;
  List<Voo> _voosDisponiveis = [];
  bool _isSavingPassageiro = false;

  TextEditingController get nomeController => _nomeController;
  TextEditingController get cpfController => _cpfController;
  String? get selectedVooId => _selectedVooId;
  List<Voo> get voosDisponiveis => _voosDisponiveis;
  bool get isSavingPassageiro => _isSavingPassageiro;

  bool _validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

    // Validação do primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int resto = 11 - (soma % 11);
    int digitoVerificador1 = resto > 9 ? 0 : resto;

    if (digitoVerificador1 != int.parse(cpf[9])) return false;

    // Validação do segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    resto = 11 - (soma % 11);
    int digitoVerificador2 = resto > 9 ? 0 : resto;

    return digitoVerificador2 == int.parse(cpf[10]);
  }

  String? Function(String?) get cpfValidator => (String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    final cpf = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Validação do primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int resto = 11 - (soma % 11);
    int digitoVerificador1 = resto > 9 ? 0 : resto;

    if (digitoVerificador1 != int.parse(cpf[9])) {
      return 'CPF inválido';
    }

    // Validação do segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    resto = 11 - (soma % 11);
    int digitoVerificador2 = resto > 9 ? 0 : resto;

    if (digitoVerificador2 != int.parse(cpf[10])) {
      return 'CPF inválido';
    }

    return null;
  };

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<void> loadPassageiros() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final token = await _tokenService.getToken();
      if (token == null) {
        _error = 'Token não encontrado. Faça login novamente.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _passageiros = await _repository.getPassageiros(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('Erro ao carregar passageiros: $_error');

      if (_error!.contains('Token inválido ou expirado') ||
          _error!.contains('Token não encontrado')) {
        // erro já setado
        // a view vai observar o erro para navegar
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadVoosDisponiveis() async {
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
        _voosDisponiveis =
            data
                .map((json) => Voo.fromJson(json))
                .where((voo) => voo.status == 'programado')
                .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao carregar voos disponíveis: $e');
    }
  }

  void resetForm() {
    _nomeController.clear();
    _cpfController.clear();
    _selectedVooId = null;
    _isSavingPassageiro = false;
    notifyListeners();
  }

  void setSelectedVooId(String? vooId) {
    _selectedVooId = vooId;
    notifyListeners();
  }

  Future<bool> saveNewPassageiro() async {
    if (_nomeController.text.isEmpty ||
        _cpfController.text.isEmpty ||
        _selectedVooId == null) {
      _error = 'Preencha todos os campos';
      notifyListeners();
      return false;
    }

    // Validar CPF antes de enviar
    if (!_validarCPF(_cpfController.text)) {
      _error = 'CPF inválido';
      notifyListeners();
      return false;
    }

    _isSavingPassageiro = true;
    notifyListeners();

    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        _error = 'Token não encontrado';
        return false;
      }

      // Remover pontos e traços do CPF
      final cpfLimpo = _cpfController.text.replaceAll(
        RegExp(r'[^\d]'),
        '',
      );

      final body = {
        'nome': _nomeController.text,
        'cpf': cpfLimpo,
        'vooId': _selectedVooId,
      };

      print('Enviando dados para API: $body');

      final response = await http.post(
        Uri.parse('${ApiUrl.baseUrl}/${ApiUrl.passageirosUrl}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      print('Resposta da API: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 201) {
        await loadPassageiros();
        return true;
      } else {
        final errorBody = json.decode(response.body);
        _error =
            'Erro ao criar passageiro: ${errorBody['message'] ?? response.statusCode}';
        return false;
      }
    } catch (e) {
      print('Erro detalhado: $e');
      _error = 'Erro ao criar passageiro: $e';
      return false;
    } finally {
      _isSavingPassageiro = false;
      notifyListeners();
    }
  }

  Future<void> atualizarStatusCheckin(String passageiroId) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        _error = 'Token não encontrado';
        notifyListeners();
        return;
      }

      final url = Uri.parse(
        '${ApiUrl.baseUrl}/${ApiUrl.passageirosUrl}/$passageiroId/${ApiUrl.statusCheckinPassageiro}',
      );

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': 'realizado'}),
      );

      if (response.statusCode == 200) {
        // Atualiza a lista de passageiros após o sucesso
        await loadPassageiros();
      } else {
        _error = 'Erro ao atualizar status do check-in: ${response.body}';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Erro ao atualizar status do check-in: $e';
      notifyListeners();
    }
  }
}
