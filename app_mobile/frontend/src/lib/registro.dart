import 'package:flutter/material.dart';
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
    Navigator.pushNamed(context, '/InicioSesion');
  }


  Future<void> _handlePressed(BuildContext context, AuthProvider authProvider) async {
    if(_passwordController.text != _passwordConfController.text) {
      showErrorSnackBar(context, 'Las contraseñas no coinciden');
    }
    else if(await _authProvider.signUp(_nameController.text, _passwordController.text, _emailController.text, context)) {
      showSuccessSnackBar(context, 'Usuario registrado correctamente');
      Navigator.pushNamed(context, '/Principal');
    }
  }
}
