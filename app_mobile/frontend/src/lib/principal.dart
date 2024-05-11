import 'package:battleship/defender.dart';
import 'package:flutter/material.dart';
import 'atacar.dart';
import 'juego.dart';
import 'comun.dart';
import 'botones.dart';
import 'destino.dart';
import 'sala.dart';

class Principal extends StatelessWidget {
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
            const SizedBox(height: 30),
            const SizedBox(
              width: 195,
              height: 195,
              child: Image(image: AssetImage('images/portada.png')),
            ),
            const Spacer(),
            buildActionButton(context, () => _handleCompetitivaPressed(context), "Partida Competitiva"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleAmistosaPressed(context), "Partida Amistosa"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleIndividualPressed(context), "Partida Individual"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleTorneoPressed(context), "Torneo"),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  void _handleCompetitivaPressed(BuildContext context) async {
    Juego().modalidadPartida = "COMPETITIVA";
    print("CODIGO: " + Juego().codigo.toString());
    if (Juego().codigo != -1) {
      await Juego().cargarPartida(context);
    }
    else {
      DestinoManager.setDestino(const Sala());
    }
    Navigator.pushNamed(context, DestinoManager.getRutaDestino());
  }

  void _handleAmistosaPressed(BuildContext context) async {
    Juego().modalidadPartida = "AMISTOSA";
    if (Juego().codigo != -1) {
      await Juego().cargarPartida(context);
    }
    else {
      DestinoManager.setDestino(const Sala());
    }
    Navigator.pushNamed(context, DestinoManager.getRutaDestino());
  }

  Future<void> _handleIndividualPressed(BuildContext context) async {
    DestinoManager.setDestino(const Atacar());
    Juego().modalidadPartida = "INDIVIDUAL";
    if (Juego().codigo == -1) {
      await Juego().crearPartida();
      DestinoManager.setDestino(const Atacar());
    } 
    else {
      await Juego().cargarPartida(context);
    }
    Navigator.pushNamed(context, DestinoManager.getRutaDestino());
    }
  }

  Future<void> _handleTorneoPressed(BuildContext context) async {
    DestinoManager.setDestino(const Atacar());
    Juego().modalidadPartida = "TORNEO";
    await Juego().cargarPartida(context);
    if (Juego().codigo == -1) {
      await Juego().crearPartida();
    }
    DestinoManager.setDestino(const Atacar());
    Navigator.pushNamed(context, '/Atacar');
}