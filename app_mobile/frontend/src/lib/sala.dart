import 'package:flutter/material.dart';
import 'comun.dart';
import 'juego.dart';

class Sala extends StatefulWidget {
  const Sala({super.key});

  @override
  _SalaState createState() => _SalaState();
}

class _SalaState extends State<Sala> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)), // Espera un segundo
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
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
                    FutureBuilder(
                      future: iniciarSala(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const Text('Esperando a que otro jugador se una', style: TextStyle(color: Colors.white, fontSize: 20));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> iniciarSala() async {
    bool res =  await Juego().buscarSala();
    if (!res) {
      Juego().crearSala();
    }
  }
}
