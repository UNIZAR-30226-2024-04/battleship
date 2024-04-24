import 'package:battleship/colocarBarcos.dart';
import 'package:battleship/defender.dart';
import 'package:battleship/registro.dart';
import 'package:flutter/material.dart';
import 'ajustes.dart';
import 'atacar.dart';
import 'flota.dart';
import 'habilidades.dart';
import 'juego.dart';
import 'login.dart';
import 'authProvider.dart';
import 'comun.dart';
import 'botones.dart';
import 'destino.dart';
import 'perfil.dart';
import 'recContrasena.dart';
import 'social.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Principal(),
      routes: {
        '/InicioSesion': (context) => InicioSesion(),
        '/Perfil': (context) => Juego().perfilJugador,
        '/Principal': (context) => Principal(),
        '/ColocarBarcos': (context) => const ColocarBarcos(),
        '/Habilidades': (context) => Habilidades(),
        '/Flota': (context) => Flota(),
        '/Ajustes': (context) => Ajustes(),
        '/Social': (context) => Social(),
        '/Registrarse': (context) => Registro(),
        'RecuperarContrasena': (context) => RecuperacionContrasena(),
        '/Atacar': (context) => Atacar(),
        '/Defender': (context) => Defender(),
        '/Destino': (context) => DestinoManager.getDestino(),
      },
    );
  }
}


class Principal extends StatelessWidget {
  final AuthProvider _authProvider = AuthProvider();

  Principal({super.key});

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
            const SizedBox(
              width: 250,
              height: 250,
              child: Image(image: AssetImage('images/portada.png')),
            ),
            const Spacer(),
            buildActionButton(context, () => _handleCompetitivaPressed(context, _authProvider), "Partida Competitiva"),
            const SizedBox(height: 10),
            buildActionButton(context, () => _handleAmistosaPressed(context, _authProvider), "Partida Amistosa"),
            const SizedBox(height: 10),
            buildActionButton(context, () => _handleIndividualPressed(context, _authProvider), "Partida Individual"),
            const SizedBox(height: 10),
            buildActionButton(context, () => _handleTorneosPressed(context, _authProvider), "Torneos"),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  void _handleCompetitivaPressed(BuildContext context, AuthProvider authProvider) {
    DestinoManager.setDestino(const ColocarBarcos());
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/InicioSesion');
    } else {
      Navigator.pushNamed(context, '/ColocarBarcos');
    }
  }

  void _handleAmistosaPressed(BuildContext context, AuthProvider authProvider) {
    DestinoManager.setDestino(const ColocarBarcos());
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/InicioSesion');
    } else {
      Navigator.pushNamed(context, '/ColocarBarcos');
    }
  }

void _handleIndividualPressed(BuildContext context, AuthProvider authProvider) {
    DestinoManager.setDestino(const ColocarBarcos());
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/InicioSesion');
    } else {
      Navigator.pushNamed(context, '/ColocarBarcos');
    }
  }

  void _handleTorneosPressed(BuildContext context, AuthProvider authProvider) {
    DestinoManager.setDestino(const ColocarBarcos());
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/InicioSesion');
    } else {
      Navigator.pushNamed(context, '/ColocarBarcos');
    }
  }

}