import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _name = 'usuario1';
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  String get email => _email;
  String get password => _password;
  String get name => _name;

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
    if (email == '1' && password == '1') {
      _email = email;
      _password = password;
      _isLoggedIn = true;
      notifyListeners(); // Notifica a los listeners que la variable ha cambiado
      return true;
    } else {
      return false;
    }
  }

  // TO-DO :)
  bool signUp(String email, String password, String name) {
    if (email == '1' && password == '1' && name == 'pepillo') {
      _email = email;
      _password = password;
      _name = name;
      _isLoggedIn = true;
      notifyListeners(); // Notifica a los listeners que la variable ha cambiado
      return true;
    } else {
      return false;
    }
  }

  void logOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
