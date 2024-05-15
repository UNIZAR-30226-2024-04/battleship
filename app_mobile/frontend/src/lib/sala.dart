import 'package:battleship/destino.dart';
import 'package:flutter/material.dart';
import 'atacar.dart';
import 'comun.dart';
import 'defender.dart';
import 'juego.dart';

class Sala extends StatefulWidget {
  const Sala({super.key});

  @override
  _SalaState createState() => _SalaState();
}

class _SalaState extends State<Sala> {
  late Future<void> salaEncontrada;

  @override
  void initState() {
    super.initState();
    if(Juego().codigo == -1) {
      bool amistosa = false;
      if (Juego().modalidadPartida == "AMISTOSA") {
        amistosa = true;
      }
      salaEncontrada = buscarOCrearSala(amistosa);
    }
  }

  Future<void> buscarOCrearSala(bool amistosa) async {
    if(Juego().bioma != 'Bermudas') {
      Juego().clima = 'Calma';
    }
    else {
      Juego().clima = 'Tormenta';
    }
    if(Juego().torneo) {
      if (await Juego().buscarTorneo()) {
        DestinoManager.setDestino(const Defender());
        Navigator.pushNamed(context, '/Defender');
      } else {
        await Juego().crearTorneo();
        DestinoManager.setDestino(const Atacar());
        Navigator.pushNamed(context, '/Atacar');
      }
    }
    else {
      if (await Juego().buscarSala(amistosa)) {
        DestinoManager.setDestino(const Defender());
        Navigator.pushNamed(context, '/Defender');
      } else {
        await Juego().crearSala(amistosa);
        DestinoManager.setDestino(const Atacar());
        Navigator.pushNamed(context, '/Atacar');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: salaEncontrada,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: Juego().colorFondo,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                'Buscando rival ...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  decoration: TextDecoration.none,
                ),
              ),
                SizedBox(height: 20.0),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Juego().colorFondo,
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildHeader(context, ponerPerfil: false),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
