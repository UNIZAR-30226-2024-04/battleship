import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'defender.dart';

class Atacar extends StatefulWidget {
  const Atacar({Key? key}) : super(key: key);

  @override
  _AtacarState createState() => _AtacarState();
}

class _AtacarState extends State<Atacar> {

  @override
  void initState() {
    super.initState();
    var barcos = Juego().tablero_jugador.barcos;
  }

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
            buildTitle('¡Ataca a tu rival!', 28),
            _construirTableroConBarcosAtacable(),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

Widget _construirTableroConBarcosAtacable() {
  List<Widget> children = [];

  children.add(
    SizedBox(
      width: Juego().tablero_jugador.boardSize + Juego().tablero_jugador.casillaSize,
      height: Juego().tablero_jugador.boardSize + Juego().tablero_jugador.casillaSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: Juego().buildTableroClicable(_handleTap),
      ),
    ),
  );

  print(Juego().tablero_jugador.casillasAtacadas);
  

  // Construye las cruces para todas las posiciones atacadas
  for (int i = 0; i < Juego().tablero_jugador.numFilas - 1; i++) {
    for (int j = 0; j < Juego().tablero_jugador.numColumnas - 1; j++) {
      if (Juego().tablero_jugador.casillasAtacadas[i][j]) {
        children.add(
          Positioned(
            top: j * Juego().tablero_jugador.casillaSize,
            left: i * Juego().tablero_jugador.casillaSize,
            child: Image.asset(
              'images/redCross.png',
              width: Juego().tablero_jugador.casillaSize,
              height: Juego().tablero_jugador.casillaSize,
            ),
          ),
        );
      }
    }
  }

  return Stack(children: children);
}


  void _handleTap(int i, int j) {
    Juego().tablero_jugador.casillasAtacadas[i][j] = true;
    print('INTENTO CRUZ');
    print(Juego().tablero_jugador.casillasAtacadas);
  }
}
