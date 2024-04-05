import 'package:battleship/colocarBarcos.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'authProvider.dart';
import 'comun.dart';
import 'botones.dart';
import 'destino.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Principal(),
      ),
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
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const InicioSesion(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const ColocarBarcos(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }

  void _handleAmistosaPressed(BuildContext context, AuthProvider authProvider) {
    DestinoManager.setDestino(const ColocarBarcos());
    if (!authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const InicioSesion(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const ColocarBarcos(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }

void _handleIndividualPressed(BuildContext context, AuthProvider authProvider) {
    DestinoManager.setDestino(const ColocarBarcos());
    if (!authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const InicioSesion(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const ColocarBarcos(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }

  void _handleTorneosPressed(BuildContext context, AuthProvider authProvider) {
    DestinoManager.setDestino(const ColocarBarcos());
    if (!authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const InicioSesion(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const ColocarBarcos(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }

}