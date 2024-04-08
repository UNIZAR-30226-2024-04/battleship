import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'botones.dart';
import 'comun.dart';
import 'habilidad.dart';
import 'main.dart';

class Perfil extends StatefulWidget {
  String _email = '';
  String _password = '';
  String _name = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idiomaController = TextEditingController();
  final TextEditingController _privacyController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repNewPasswordController = TextEditingController();
  final bool _rememberMe = false;
  final AuthProvider _authProvider = AuthProvider();
  List<Habilidad> _habilidades = [];  // habilidades desbloqueadas
  List<Habilidad> _habilidadesSeleccionadas = [];  // habilidades seleccionadas para la partida

  Perfil(name, {super.key, turno = 1}) {
    _name = name;
    _habilidades = [Sonar(turno), Mina(turno), MisilTeledirigido(turno), RafagaDeMisiles(turno), TorpedoRecargado(turno)];
    _habilidadesSeleccionadas = [RafagaDeMisiles(turno), TorpedoRecargado(turno), MisilTeledirigido(turno)];
  }

  @override
  _PerfilState createState() => _PerfilState();

  List<Habilidad> getHabilidadesSeleccionadas() {
    return _habilidadesSeleccionadas;
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
  @override
  void initState() {
    super.initState();
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
                    buildActionButton(context, () => _handlePressed(context, AuthProvider()), 'Cerrar Sesión'),
                  ],
                ),
              ),
            ),
            buildActions(context),
          ],
        ),
      ),
    );
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
        _buildStatRow('PUNTOS: '),
        _buildStatRow('TOTAL PARTIDAS: '),
        _buildStatRow('VICTORIAS: '),
        _buildStatRow('DERROTAS: '),
        _buildStatRow('BARCOS HUNDIDOS: '),
        _buildStatRow('RATIO VICTORIAS: '),
        _buildStatRow('FLOTA FAVORITA: '),
        _buildStatRow('HABILIDAD FAVORITA: '),
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

  void _handlePressed(BuildContext context, AuthProvider authProvider) {
    authProvider.logOut();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Principal(),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      children: [
        buildEntryButton('Nombre', 'Introduzca el nombre', Icons.email, widget._nameController),
        buildEntryButton('Email', 'Introduzca el email', Icons.email, widget._emailController),
        buildEntryAstButton('Contraseña', 'Introduzca la contraseña actual', Icons.lock, widget._oldPasswordController),
        buildEntryAstButton('Contraseña', 'Introduzca la contraseña nueva', Icons.lock, widget._newPasswordController),
        buildEntryAstButton('Contraseña', 'Repita la contraseña nueva', Icons.lock, widget._repNewPasswordController),
        buildDropdownButton(context, 'Nacionalidad', ['España', 'Alemania', 'Italia'], widget._idiomaController),
        buildDropdownButton(context, 'Privacidad del perfil', ['Público', 'Privado'], widget._privacyController),
      ],
    );
  }
}

