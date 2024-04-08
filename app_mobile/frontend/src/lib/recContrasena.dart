import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'botones.dart';
import 'comun.dart';

class RecuperacionContrasena extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final AuthProvider _authProvider = AuthProvider();

  RecuperacionContrasena({super.key});

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
            _buildRec(context, () => _handlePressed(context, _authProvider)),
            const Spacer(),
            buildActions(context)
          ],
        ),
      ),
    );
  }


  Widget _buildRec(BuildContext context, VoidCallback? onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildTitle('Recuperación de contraseña', 25),
        const SizedBox(height: 30), 
        buildEntryButton('Email', 'Introduzca la dirección de correo', Icons.email, _emailController),
        
        const SizedBox(height: 20), 

        buildActionButton(context, onPressed, "Enviar mensaje"),
      ],
    );
  }

  Future<void> _handlePressed(BuildContext context, AuthProvider authProvider) async {
    // TODO: Implementar recuperación de contraseña
  }
}

