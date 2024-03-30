import 'package:flutter/material.dart';
import 'login.dart';
import 'main.dart';
import 'authProvider.dart';
import 'comun.dart';
import 'botones.dart';
import 'destino.dart';


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
        buildTitle('Registrarse', 28),
        buildEntryButton('Nombre', 'Introduzca el nombre de usuario', Icons.person, _nameController),
        buildEntryButton('Email', 'Introduzca la dirección de correo', Icons.email, _emailController),
        buildEntryAstButton('Contraseña', 'Introduzca la contraseña', Icons.lock, _passwordController),
        buildEntryAstButton('Confirmar contraseña', 'Repita la contraseña', Icons.lock, _passwordConfController),
        
        const SizedBox(height: 20), 

        buildActionButton(context, onPressed, "Confirmar"),

        const SizedBox(height: 20),   

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
        MaterialPageRoute(builder: (context) => DestinoManager.getDestino()),
      );
    }
  }
}
