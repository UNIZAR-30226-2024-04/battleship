import 'package:battleship/authProvider.dart';
import 'package:battleship/botones.dart';
import 'package:battleship/main.dart';
import 'package:flutter/material.dart';
import 'comun.dart';

class Ajustes extends StatelessWidget {
  final TextEditingController _idiomaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  Ajustes({super.key});

@override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/fondo.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            buildHeader(context),
            buildTitle('Ajustes', 28),
            const Spacer(),
            _buildAjustes(context),
            const Spacer(),
            buildActions(context)
          ],
        ),
      ),
    );
  }

  Widget _buildAjustes(BuildContext context) {
    return Container(
      child: Column(
        children: [
          buildDropdownButton(context, 'Idioma', ['Español', 'Inglés', 'Alemán'], _idiomaController),
          buildEntryButton('Email', 'Introduzca el email', Icons.email, _emailController),
          buildEntryAstButton('Contraseña', 'Introduzca la contraseña', Icons.lock, _contrasenaController),
          buildActionButton(context, () => _handlePressed(context, AuthProvider()), 'Cerrar Sesión'),
        ],
      ),
    );
  }


  void _handlePressed(BuildContext context, AuthProvider authProvider) {
    authProvider.logOut();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Principal(),
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }
}