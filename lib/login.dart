import 'package:flutter/material.dart';
import 'registro.dart';
import 'recContrasena.dart';
import 'botones.dart';
import 'main.dart';
import 'authProvider.dart';
import 'comun.dart';


class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final AuthProvider _authProvider = AuthProvider();

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
            const Spacer(),
            _buildLogin(context, () => _handlePressed(context, _authProvider)),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }


  Widget _buildLogin(BuildContext context, VoidCallback? onPressed) {
    return Column(
      children: [
        buildTitle('Iniciar Sesión', 28),

        const SizedBox(height: 10.0),
        buildEntryButton('Email', 'Introduzca la dirección de correo', Icons.email, _emailController),
        buildEntryAstButton('Contraseña', 'Introduzca la contraseña', Icons.lock, _passwordController),
        buildTextButton(context, () => _handleRecContrasenaPressed(context), 'Olvidé la contraseña'),
        const SizedBox(height: 10.0),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomCheckbox(
              value: _rememberMe,
              onChanged: (bool value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
            const SizedBox(width: 8.0),
            const Text('Recordarme', style: TextStyle(color: Colors.white),
            ),
          ],
        ),

        const SizedBox(height: 20), // Espacio entre los botones

        buildActionButton(context, onPressed, "Iniciar Sesión"),

        const SizedBox(height: 20), // Espacio entre los botones    

        buildTextButton(context, () => _handleRegistrarsePressed(context), '¿No tienes una cuenta? Regístrate')
      ],
    );
  }

  void _handleRegistrarsePressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registro()),
    );
  }

  void _handleRecContrasenaPressed(BuildContext context) {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecuperacionContrasena()),
    );
  }

  void _handlePressed(BuildContext context, AuthProvider authProvider) {
    if(_authProvider.authenticate(_emailController.text, _passwordController.text)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Principal()),
      );
    }
  }
}

