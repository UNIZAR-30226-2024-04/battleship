import 'package:flutter/material.dart';
import 'login.dart';
import 'main.dart';
import 'authProvider.dart';
import 'comun.dart';
import 'botones.dart';


class Registro extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();
  final AuthProvider _authProvider = AuthProvider();

  Registro({super.key});

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
            _buildSignUp(context, () => _handlePressed(context, _authProvider)),
            const Spacer(),
            buildActions(context)
          ],
        ),
      ),
    );
  }


  Widget _buildSignUp(BuildContext context, VoidCallback? onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Registrarse',
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
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Nombre',
                hintText: 'Introduzca el nombre de usuario',
                suffixIcon: const Icon(Icons.person),
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
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 300, // Ancho deseado
            child: TextField(
              controller: _passwordConfController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Confirmar contraseña',
                hintText: 'Repita la contraseña',
                suffixIcon: const Icon(Icons.lock),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20), // Espacio entre los botones

        buildActionButton(context, onPressed, "Confirmar"),

        const SizedBox(height: 20), // Espacio entre los botones    

        buildTextButton(context, () => _handleIniciarSesionPressed(context), '¿Ya tienes una cuenta? Inicia sesión'),
      ],
    );
  }

  void _handleIniciarSesionPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InicioSesion()),
    );
  }


  void _handlePressed(BuildContext context, AuthProvider authProvider) {
    if(_passwordController.text != _passwordConfController.text) {
      const snackBar = SnackBar(
        content: Text(
          'Las contraseñas no coinciden',
          style: TextStyle(color: Colors.red),
        ),
        behavior: SnackBarBehavior.floating, // Mostrar el SnackBar en la parte superior
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else if(_authProvider.signUp(_emailController.text, _passwordController.text, _nameController.text)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Principal()),
      );
    }
  }
}
