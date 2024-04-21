import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'juego.dart';

class AuthProvider with ChangeNotifier {
  final String _urlInicioSesion = 'http://localhost:8080/perfil/iniciarSesion';
  final String _urlRegistro = 'http://localhost:8080/perfil/registrarUsuario';
  bool _isLoggedIn = false;
  String mensajeError = "";
  String tokenSesion = "";

  bool get isLoggedIn => _isLoggedIn;
  String get email => Juego().perfilJugador.email;
  String get password => Juego().perfilJugador.password;
  String get name => Juego().perfilJugador.name;

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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("RESPUESTA OK");
      print(data);
      if (data != null) {
        print("DATA NO NULL");
        print(data['token']);
        tokenSesion = data['token'];
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



    // Verificar si la cadena ya está en formato JSON
    dynamic responseBody;
    try {
      responseBody = jsonDecode(response.body);
      print("La cadena ya está en formato JSON");

      if (responseBody.containsKey('message')) {
        mensajeError = responseBody['message'];
      }
      
    } catch (e) {
      print("La cadena no está en formato JSON");
      mensajeError = response.body;
    }

    if (response.statusCode == 200) {
      print("RESPUESTA OK");
      print(responseBody);
      if (responseBody != null) {
        tokenSesion = responseBody['token'];
        print("REGISTRO CORRECTO");
        return true;
      }
    } else {
      print("RESPUESTA NO OK");
      return false;
    }
    
    return false;
  }


  Future<bool> login(String name, String password, BuildContext context) async {
    try {
      bool response = await loginDB(name, password);

      if(response) {
        _isLoggedIn = true;
        Juego().perfilJugador.name = name;
        Juego().perfilJugador.password = password;
        Juego().tokenSesion = tokenSesion;
        notifyListeners(); // Notifica a los listeners que la variable ha cambiado
        return true;
      } else {
        const snackBar = SnackBar(
          content: Text(
            'Credenciales incorrectas',
            style: TextStyle(color: Colors.red),
          ),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        mensajeError = "";
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    );
    return regex.hasMatch(email);
  }


  Future<bool> signUp(String name, String password, String email, BuildContext context) async {
    bool response = await signUpDB(name, password, email);

    if(!isValidEmail(email)) {
      const snackBar = SnackBar(
        content: Text(
          'El email no es válido',
          style: TextStyle(color: Colors.red),
        ),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      mensajeError = "";

      return false;
    }

    if(mensajeError != "") {
      final snackBar = SnackBar(
        content: Text(
          mensajeError,
          style: TextStyle(color: Colors.red),
        ),
        behavior: SnackBarBehavior.floating,  
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      mensajeError = "";
      return false;
    }


    print("RESPUESTA: ");
    print(response);

    if(response) {
      _isLoggedIn = true;
      Juego().perfilJugador.name = name;
      Juego().perfilJugador.password = password;
      Juego().perfilJugador.email = email;
      Juego().tokenSesion = tokenSesion;
      mensajeError = "";
      notifyListeners(); // Notifica a los listeners que la variable ha cambiado
      return true;
    }

    else {
      const snackBar = SnackBar(
        content: Text(
          'La contraseña debe tener al menos 8 caracteres, 1 minúscula, 1 mayúscula, 1 dígito y un caracter especial',
          style: TextStyle(color: Colors.red),
        ),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      mensajeError = "";
    }

    return false;
  }
  void logOut() {
    _isLoggedIn = false;
    mensajeError = "";
    notifyListeners();
  }
}
