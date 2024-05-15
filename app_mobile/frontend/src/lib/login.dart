import 'package:battleship/destino.dart';
import 'package:battleship/principal.dart';
import 'package:flutter/material.dart';
import 'juego.dart';
import 'botones.dart';
import 'authProvider.dart';
import 'comun.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthProvider _authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Juego().colorFondo,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            buildHeader(context),
            const Spacer(),
            _buildLogin(context, () async => await _handlePressed(context, _authProvider)),
            const Spacer(),
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
        buildEntryButton('Nombre', 'Introduzca su nombre', Icons.person, _nombreController),
        buildEntryAstButton('Contraseña', 'Introduzca la contraseña', Icons.lock, _passwordController),
        const SizedBox(height: 20),
        buildActionButton(context, onPressed, "Iniciar Sesión"),
        const SizedBox(height: 20),    
        buildTextButton(context, () => _handleRegistrarsePressed(context), '¿No tienes una cuenta? Regístrate')
      ],
    );
  }

  void _handleRegistrarsePressed(BuildContext context) {
    Navigator.pushNamed(context, '/Registrarse');
  }

  Future<void> _handlePressed(BuildContext context, AuthProvider authProvider) async {
    if(await _authProvider.login(_nombreController.text, _passwordController.text, context)) {
      if(Juego().codigo != -1) {
        await Juego().cargarPartida(context);
      }
      else {
        DestinoManager.setDestino(Principal());
      }
      Navigator.pushNamed(context, DestinoManager.getRutaDestino());
    }
    else {
      showErrorSnackBar(context, "Credenciales incorrectas");
    }
  }
}
