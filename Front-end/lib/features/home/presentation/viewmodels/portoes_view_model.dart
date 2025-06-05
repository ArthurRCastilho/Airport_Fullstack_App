import 'package:flutter/material.dart';
import 'package:api_aeroporto/features/home/data/repositories/portoes_repository.dart';
import 'package:api_aeroporto/features/home/domain/models/portao.dart';
import 'package:api_aeroporto/features/auth/data/services/token_service.dart';

class PortoesViewModel extends ChangeNotifier {
  final PortoesRepository _repository = PortoesRepository();
  final TokenService _tokenService = TokenService();

  List<Portao> _portoes = [];
  List<Portao> get portoes => _portoes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _showAddPortaoForm = false;
  final TextEditingController _newPortaoCodigoController =
      TextEditingController();
  bool _newPortaoDisponivel = true;
  bool _isSavingPortao = false;

  bool get showAddPortaoForm => _showAddPortaoForm;
  TextEditingController get newPortaoCodigoController =>
      _newPortaoCodigoController;
  bool get newPortaoDisponivel => _newPortaoDisponivel;
  bool get isSavingPortao => _isSavingPortao;

  Future<void> loadPortoes() async {
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

      _portoes = await _repository.getPortoes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('Erro ao carregar portões: $_error');

      if (_error!.contains('Token inválido ou expirado') ||
          _error!.contains('Token não encontrado')) {
        // erro já setado
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  void openAddPortaoForm() {
    _showAddPortaoForm = true;
    _newPortaoCodigoController.clear();
    _newPortaoDisponivel = true;
    notifyListeners();
  }

  void closeAddPortaoForm() {
    _showAddPortaoForm = false;
    _newPortaoCodigoController.clear();
    notifyListeners();
  }

  void setNewPortaoDisponivel(bool value) {
    _newPortaoDisponivel = value;
    notifyListeners();
  }

  Future<bool> saveNewPortao() async {
    if (_newPortaoCodigoController.text.isEmpty) {
      _error = 'Por favor, insira o código do portão';
      notifyListeners();
      return false;
    }

    try {
      _isSavingPortao = true;
      _error = null;
      notifyListeners();

      final novoPortao = await _repository.createPortao(
        _newPortaoCodigoController.text,
        _newPortaoDisponivel,
      );

      _portoes.add(novoPortao);
      closeAddPortaoForm();
      return true;
    } catch (e) {
      _error = e.toString();
      if (_error!.contains('token')) {
        _error = 'Sessão expirada. Por favor, faça login novamente.';
      }
      return false;
    } finally {
      _isSavingPortao = false;
      notifyListeners();
    }
  }

  void resetForm() {
    _newPortaoCodigoController.clear();
    _newPortaoDisponivel = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _newPortaoCodigoController.dispose();
    super.dispose();
  }
}
