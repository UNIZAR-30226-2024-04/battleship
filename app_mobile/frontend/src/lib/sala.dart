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
    if (await Juego().buscarSala()) {
      print("SALA ENCONTRADA");
      Juego().anfitrion = false;
      DestinoManager.setDestino(const Defender());
      Navigator.pushNamed(context, '/Defender');
    } else {
      await Juego().crearSala(amistosa);
      Juego().anfitrion = true;
      print("SALA CREADA");
      DestinoManager.setDestino(const Atacar());
      Navigator.pushNamed(context, '/Atacar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: salaEncontrada,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/fondo.jpg'),
                fit: BoxFit.cover,
              ),
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
