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
        const Text(
          'Iniciar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5, // Espaciado entre letras
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 300, // Ancho deseado
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Email',
                hintText: 'Introduzca la dirección de correo',
                suffixIcon: const Icon(Icons.email),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 300, // Ancho deseado
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Contraseña',
                hintText: 'Introduzca la contraseña',
                suffixIcon: const Icon(Icons.lock),
              ),
            ),
          ),
        ),

        buildTextButton(context, () => _handleRecContrasenaPressed(context), 'Olvidé la contraseña'),

        const SizedBox(height: 20.0),
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
            const Text(
              'Recordarme',
              style: TextStyle(color: Colors.white),
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

