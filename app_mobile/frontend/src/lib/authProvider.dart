import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'comun.dart';
import 'juego.dart';
import 'error.dart';

class AuthProvider with ChangeNotifier {
  final String _urlInicioSesion = 'http://localhost:8080/perfil/iniciarSesion';
  final String _urlRegistro = 'http://localhost:8080/perfil/registrarUsuario';
  final String _urlModificarDatosPersonales = 'http://localhost:8080/perfil/modificarDatosPersonales';
  bool _isLoggedIn = false;
  String tokenSesion = "";

  MensajeErrorModel mensajeErrorModel = MensajeErrorModel.getInstance();

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


  Future<bool> modificarPerfil(String nombre, String password, String email, String pais) async {
    var uri = Uri.parse(_urlModificarDatosPersonales);
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': nombre,
        'contraseña': password,
        'correo': email,
        'pais': pais,
      }),
    );

    print(response.body);

    // Verificar si la cadena ya está en formato JSON
    dynamic responseBody;
    try {
      responseBody = jsonDecode(response.body);
      print("La cadena ya está en formato JSON");

      if (responseBody.containsKey('message')) {
        mensajeErrorModel.setMensaje(responseBody['message']);
      }
      
    } catch (e) {
      print("La cadena no está en formato JSON");
      mensajeErrorModel.setMensaje(response.body);
    }

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("RESPUESTA OK");
      print(data);
      if (data != null) {
        print("DATOS MODIFICADOS CORRECTAMENTE");
        mensajeErrorModel.cleanErrorMessage();
        return true;
      }

      return false;
    } else {
      return false;
    }
  }

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
        mensajeErrorModel.setMensaje(responseBody['message']);
      }
      
    } catch (e) {
      print("La cadena no está en formato JSON");
      mensajeErrorModel.setMensaje(response.body);
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
        Juego().setSession(name, "", password, tokenSesion);
        print("USUARIO EN JUEGO:${Juego().perfilJugador.name}");
        notifyListeners(); // Notifica a los listeners que la variable ha cambiado
        return true;
      } else {
        showErrorSnackBar(context, 'Credenciales incorrectas');
        mensajeErrorModel.cleanErrorMessage();
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String password, String email, BuildContext context) async {
    bool response = await signUpDB(name, password, email);

    if(!isValidEmail(email)) {
      showErrorSnackBar(context, 'El email no es válido');
      mensajeErrorModel.cleanErrorMessage();

      return false;
    }

    if(mensajeErrorModel.mensaje != "") {
      showErrorSnackBar(context, mensajeErrorModel.mensaje);
      mensajeErrorModel.cleanErrorMessage();
      return false;
    }


    print("RESPUESTA: ");
    print(response);

    if(response) {
      _isLoggedIn = true;
      Juego().setSession(name, email, password, tokenSesion);
      mensajeErrorModel.cleanErrorMessage();
      notifyListeners(); // Notifica a los listeners que la variable ha cambiado
      return true;
    }
    else {
      showErrorSnackBar(context, mensajeErrorModel.mensaje);
      mensajeErrorModel.cleanErrorMessage();
    }

    return false;
  }
  void logOut() {
    _isLoggedIn = false;
    mensajeErrorModel.cleanErrorMessage();
    notifyListeners();
  }
}
