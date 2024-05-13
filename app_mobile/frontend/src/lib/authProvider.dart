import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'comun.dart';
import 'juego.dart';
import 'error.dart';
import 'dart:html';
import 'serverRoute.dart';

/*
 * Clase que gestiona la autenticación del usuario.
 */
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String tokenSesion = "";
  ServerRoute serverRoute = ServerRoute();

  MensajeErrorModel mensajeErrorModel = MensajeErrorModel.getInstance();

  bool get isLoggedIn => _isLoggedIn;
  String get email => Juego().miPerfil.email;
  String get password => Juego().miPerfil.password;
  String get name => Juego().miPerfil.name;

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

  /*
   * Método que permite modificar el perfil del usuario.
   */
  Future<bool> modificarPerfil(String nombre, String password, String email, String pais) async {
    var uri = Uri.parse(serverRoute.urlModificarDatosPersonales);
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

    // Verificar si la cadena ya está en formato JSON
    dynamic responseBody;
    try {
      responseBody = jsonDecode(response.body);

      if (responseBody.containsKey('message')) {
        mensajeErrorModel.setMensaje(responseBody['message']);
      }
      
    } catch (e) {
      mensajeErrorModel.setMensaje(response.body);
    }

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data != null) {
        mensajeErrorModel.cleanErrorMessage();
        return true;
      }

      return false;
    }
    else {
      return false;
    }
  }

  /*
   * Método que permite iniciar sesión en la base de datos.
   */
  Future<bool> loginDB(String nombre, String password) async {
    var uri = Uri.parse(serverRoute.urlInicioSesion);
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
      if (data != null) {
        tokenSesion = data['token'];
        return true;
      }

      return false;
    }
    else {
      return false;
    }
  }

  /*
   * Método que permite registrar un usuario en la base de datos.
   */
  Future<bool> signUpDB(String nombre, String password, String email) async {
    var uri = Uri.parse(serverRoute.urlRegistro);
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

      if (responseBody.containsKey('message')) {
        mensajeErrorModel.setMensaje(responseBody['message']);
      }
      
    } catch (e) {
      mensajeErrorModel.setMensaje(response.body);
    }

    if (response.statusCode == 200) {
      if (responseBody != null) {
        tokenSesion = responseBody['token'];
        return true;
      }
    }
    else {
      return false;
    }
    
    return false;
  }


  /*
   * Método que permite iniciar sesión en la aplicación.
   */
  Future<bool> login(String name, String password, BuildContext context) async {
    try {
      bool response = await loginDB(name, password);

      if(response) {
        _isLoggedIn = true;
        Juego().setSession(name, "", password, tokenSesion);
        await Juego().cargarPartida(context);
        document.cookie = 'usuario=$name';
        document.cookie = 'tokenSesion=$tokenSesion';
        print(tokenSesion);
        notifyListeners(); // Notifica a los listeners que la variable ha cambiado
        return true;
      }
      else {
        // Mostrar mensaje de error 
        showErrorSnackBar(context, 'Credenciales incorrectas');
        mensajeErrorModel.cleanErrorMessage();
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  /*
   * Método que permite registrar un usuario en la aplicación.
   */
  Future<bool> signUp(String name, String password, String email, BuildContext context) async {
    bool response = await signUpDB(name, password, email);

    // Si el email no es válido, mostrar mensaje de error.
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

    if(response) {
      _isLoggedIn = true;
      Juego().setSession(name, email, password, tokenSesion);
      await Juego().cargarPartida(context);
      document.cookie = 'usuario=$name';
      document.cookie = 'tokenSesion=$tokenSesion';
      mensajeErrorModel.cleanErrorMessage();
      notifyListeners();      // Notifica a los listeners que la variable ha cambiado
      return true;
    }
    else {
      showErrorSnackBar(context, mensajeErrorModel.mensaje);
      mensajeErrorModel.cleanErrorMessage();
    }

    return false;
  }

  /*
   * Método que permite cerrar sesión en la aplicación.
   */
  void logOut() {
    _isLoggedIn = false;
    mensajeErrorModel.cleanErrorMessage();
    notifyListeners();
  }
}
