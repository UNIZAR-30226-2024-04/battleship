import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'juego.dart';

class AuthProvider with ChangeNotifier {
  final String _urlInicioSesion = 'http://localhost:8080/perfil/iniciarSesion';
  final String _urlRegistro = 'http://localhost:8080/perfil/registrarUsuario';
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  String get email => Juego().getPerfilJugador().email;
  String get password => Juego().getPerfilJugador().password;
  String get name => Juego().getPerfilJugador().name;

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

  Future<bool> loginDB(String nombre, String password) async {
    var uri = Uri.parse(_urlInicioSesion);
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': nombre,
        'contraseña': password,
      }),
    );

    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("RESPUESTA OK");
      print(data);
      if (data != null) {
        print("LOGIN CORRECTO");
        return true;
      }

      return false;
    } else {
      return false;
    }
  }


  Future<bool> signUpDB(String nombre, String password, String email) async {
    var uri = Uri.parse(_urlRegistro);
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': nombre,
        'contraseña': password,
        'correo': email,
      }),
    );

    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("RESPUESTA OK");
      print(data);
      if (data != null) {
        print("REGISTRO CORRECTO");
        return true;
      }

      return false;
    } else {
      return false;
    }
  }


  Future<bool> login(String name, String password) async {
    bool response = await loginDB(name, password);

    if(response) {
        _isLoggedIn = true;
        Juego().getPerfilJugador().name = name;
        Juego().getPerfilJugador().password = password;
        notifyListeners(); // Notifica a los listeners que la variable ha cambiado
        return true;
    }

    print("Credenciales incorrectas");

    return false;
  }

  Future<bool> signUp(String name, String password, String email) async {
    bool response = await signUpDB(name, password, email);

    if(response) {
        _isLoggedIn = true;
        Juego().getPerfilJugador().name = name;
        Juego().getPerfilJugador().password = password;
        Juego().getPerfilJugador().email = email;
        notifyListeners(); // Notifica a los listeners que la variable ha cambiado
        return true;
    }

    print("Credenciales incorrectas");

    return false;
  }
  void logOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
