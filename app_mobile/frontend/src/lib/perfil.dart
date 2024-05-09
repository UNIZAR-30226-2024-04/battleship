import 'package:battleship/error.dart';
import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'botones.dart';
import 'comun.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';

class Perfil extends StatefulWidget {
  String _email = '';
  String _password = '';
  String _name = '';
  String pais = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _privacyController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repNewPasswordController = TextEditingController();
  final bool _rememberMe = false;
  final AuthProvider _authProvider = AuthProvider();
  int partidasJugadas = 0;
  int partidasGanadas = 0;
  int partidasPerdidas = 0;
  int barcosHundidos = 0;
  int barcosPerdidos = 0;
  double ratioVictorias = 0;
  int puntos = 0;
  int trofeos = 0;
  int disparosAcertados = 0;
  int disparosFallados = 0;
 
  MensajeErrorModel mensajeErrorModel = MensajeErrorModel.getInstance();

  Perfil({String name = "", super.key, int turno = 1}) {
    if (name != "") {
      _name = name;
    }
  }


  @override
  _PerfilState createState() => _PerfilState();

  void updateState() {
    createState();
  }

  // Gettters
  String get email => _email;
  String get password => _password;
  String get name => _name;

  // Setters
  set email(String email) {
    _email = email;
  }
  
  set password(String password) {
    _password = password;
  }

  set name(String name) {
    _name = name;
  }
}

class _PerfilState extends State<Perfil> {
  ServerRoute serverRoute = ServerRoute();

  @override
  void initState() {
    super.initState();
    actualizarEstadisticasPerfil(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildUserInfo(),
                    _buildStats(),
                    _buildSettings(),
                    buildActionButton(context, () => _handlePressedSaveChanges(context, AuthProvider()), 'Guardar cambios'),
                    const SizedBox(height: 10),
                    buildActionButton(context, () => _handlePressedLogOut(context, AuthProvider()), 'Cerrar Sesión'),
                    buildTextButton(context, () => _handleEliminarCuentaPressed(context), 'Eliminar cuenta'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  Future<void> actualizarEstadisticasPerfil(String nombrePerfil) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlObtenerPerfil),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombreId': widget._name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        widget.trofeos = data['trofeos'];
        widget.puntos = data['puntosExperiencia'];
        widget.partidasJugadas = data['partidasJugadas'];
        widget.partidasGanadas = data['partidasGanadas'];
        widget.partidasPerdidas = widget.partidasJugadas - widget.partidasGanadas;
        if (widget.partidasJugadas == 0) {
          widget.ratioVictorias = 0;
        } 
        else {
          widget.ratioVictorias = widget.partidasGanadas / widget.partidasJugadas;
        }
        widget.barcosHundidos = data['barcosHundidos'];
        widget.barcosPerdidos = data['barcosPerdidos'];
        widget.disparosAcertados = data['disparosAcertados'];
        widget.disparosFallados = data['disparosFallados'];
        widget.pais = data['pais'];
      });

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }


  void eliminarCuenta() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlEliminarUsuario),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombreId': widget._name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data != null) {
        AuthProvider().logOut();
      }

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  void _handleEliminarCuentaPressed(BuildContext context) {
    eliminarCuenta();
    Navigator.pushNamed(context, '/Principal');
  }


  Widget _buildUserInfo() {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        buildTitle('Nombre usuario', 28),
        buildTitle('Seguidores', 14),
        buildTitle('Siguiendo', 14),
      ],
    );
  }

  Widget _buildStats() {
    return Column(
      children: [
        _buildStatRow('PUNTOS: ${widget.puntos}'),
        _buildStatRow('TOTAL PARTIDAS: ${widget.partidasJugadas}'),
        _buildStatRow('VICTORIAS: ${widget.partidasGanadas}'),
        _buildStatRow('DERROTAS: ${widget.partidasPerdidas}'),
        _buildStatRow('BARCOS HUNDIDOS: ${widget.barcosHundidos}'),
        _buildStatRow('RATIO VICTORIAS: ${widget.ratioVictorias}'),
        _buildStatRow('DISPAROS ACERTADOS: ${widget.disparosAcertados}'),
        _buildStatRow('DISPAROS FALLADOS: ${widget.disparosFallados}'),
      ],
    );
  }

  Widget _buildStatRow(String label) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePressedLogOut(BuildContext context, AuthProvider authProvider) {
    authProvider.logOut();
    Navigator.pushNamed(context, '/Principal');
  }

  void _handlePressedSaveChanges(BuildContext context, AuthProvider authProvider) {
    if (widget._oldPasswordController.text.isEmpty && widget._newPasswordController.text.isEmpty && widget._repNewPasswordController.text.isEmpty) {
      widget._oldPasswordController.text = widget.password;
      widget._newPasswordController.text = widget.password;
      widget._repNewPasswordController.text = widget.password;
    }
    else {
      if (widget._oldPasswordController.text != widget.password) {
        showErrorSnackBar(context, 'La contraseña antigua no coincide con la actual');
        return;
      }
      if (widget._newPasswordController.text != widget._repNewPasswordController.text) {
        showErrorSnackBar(context, 'Las contraseñas no coinciden');
        return;
      }
    }
    if (widget._emailController.text.isEmpty) {
      widget._emailController.text = widget.email;
    }
    else if(!isValidEmail(widget._emailController.text)) {
      showErrorSnackBar(context, 'El email no es válido');
      return;
    }
    if (widget._paisController.text.isEmpty) {
      widget._paisController.text = widget.pais;
    }
    Future<bool> res = authProvider.modificarPerfil(widget.name, widget._newPasswordController.text, widget._emailController.text, widget._paisController.text);
    res.then((value) {
      if (value) {
        widget.email = widget._emailController.text;
        widget.password = widget._newPasswordController.text;
        showSuccessSnackBar(context, 'Perfil modificado correctamente');
      } else {
        showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
      }
    }).catchError((error) {
      showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
    });
  }

  Widget _buildSettings() {
    return Column(
      children: [
        buildEntryButton('Email', 'Introduzca el email', Icons.email, widget._emailController),
        buildEntryAstButton('Contraseña', 'Introduzca la contraseña actual', Icons.lock, widget._oldPasswordController),
        buildEntryAstButton('Contraseña', 'Introduzca la contraseña nueva', Icons.lock, widget._newPasswordController),
        buildEntryAstButton('Contraseña', 'Repita la contraseña nueva', Icons.lock, widget._repNewPasswordController),
        buildDropdownButton(context, 'Nacionalidad', ['España', 'Portugal', 'Francia'], widget._paisController, defaultValue: widget.pais),
        buildDropdownButton(context, 'Privacidad del perfil', ['Público', 'Privado'], widget._privacyController),
      ],
    );
  }
}

