import 'package:flutter/material.dart';
import 'package:api_aeroporto/features/home/presentation/views/portoes_view.dart';
import 'package:api_aeroporto/features/home/presentation/views/voos_view.dart';
import 'package:api_aeroporto/features/home/presentation/views/passageiros_view.dart';
import 'package:api_aeroporto/features/auth/data/services/token_service.dart';
import 'dart:convert';

class HomeViewModel extends ChangeNotifier {
  final TokenService _tokenService = TokenService();
  int _currentScreen = 0;
  bool _isAdmin = false;

  int get currentScreen => _currentScreen;
  bool get canManagePortoes => _isAdmin;

  String get currentScreenTitle {
    switch (_currentScreen) {
      case 0:
        return 'Portões';
      case 1:
        return 'Voos';
      case 2:
        return 'Passageiros';
      default:
        return 'Sistema de Voos';
    }
  }

  void setCurrentScreen(int index) {
    _currentScreen = index;
    notifyListeners();
  }

  final List<Widget> _pages = [
    const PortoesView(),
    const VoosView(),
    const PassageirosView(),
  ];

  List<Widget> get pages => _pages;

  final List<String> _appBarTitles = [
    'Todos os Portões',
    'Todos os Voos',
    'Todos os Passageiros',
  ];

  String get currentAppBarTitle => _appBarTitles[_currentScreen];

  final List<String> _actionButtonMessages = [
    'Botão de Portões funcionando!',
    'Botão de Voos funcionando!',
    'Botão de Passageiros funcionando!',
  ];

  String get currentActionButtonMessage =>
      _actionButtonMessages[_currentScreen];

  Future<void> checkUserPermission() async {
    try {
      final token = await _tokenService.getToken();
      if (token != null) {
        // Decodificar o token JWT para obter o cargo
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final normalized = base64Url.normalize(payload);
          final decoded = utf8.decode(base64Url.decode(normalized));
          final Map<String, dynamic> payloadMap = json.decode(decoded);
          _isAdmin = payloadMap['cargo'] == 'admin';
          notifyListeners();
        }
      }
    } catch (e) {
      print('Erro ao verificar permissão do usuário: $e');
      _isAdmin = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _tokenService.removeToken();
    _isAdmin = false;
    notifyListeners();
  }

  String getActionButtonMessage() {
    return currentActionButtonMessage;
  }
}
