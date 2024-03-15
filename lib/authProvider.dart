import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  // Singleton instance
  static final AuthProvider _instance = AuthProvider._internal();

  factory AuthProvider() {
    return _instance;
  }

  AuthProvider._internal();

  // TO-DO :)
  bool authenticate(String email, String password) {
    if (email == 'usuario@example.com' && password == 'contrasena') {
      _isLoggedIn = true;
      notifyListeners(); // Notifica a los listeners que la variable ha cambiado
      return true;
    } else {
      return false;
    }
  }

  // TO-DO :)
  bool signUp(String email, String password, String name) {
    if (email == 'usuario@example.com' && password == 'contrasena' && name == 'pepillo') {
      _isLoggedIn = true;
      notifyListeners(); // Notifica a los listeners que la variable ha cambiado
      return true;
    } else {
      return false;
    }
  }
}
