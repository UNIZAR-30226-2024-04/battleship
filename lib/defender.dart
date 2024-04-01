import 'package:battleship/atacar.dart';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'botones.dart';
import 'comun.dart';

class Defender extends StatefulWidget {
  const Defender({Key? key}) : super(key: key);

  @override
  _DefenderState createState() => _DefenderState();
}

class _DefenderState extends State<Defender> {
  late List<List<bool>> _ataques;

  @override
  void initState() {
    super.initState();

    var barcos = Juego().tablero_jugador.barcos;
    _ataques = List.generate(Juego().tablero_jugador.boardSize.toInt(), (_) => List.filled(Juego().tablero_jugador.boardSize.toInt(), false));
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
    return Stack(
      children: [
        SizedBox(
          width: Juego().tablero_jugador.boardSize + Juego().tablero_jugador.casillaSize,
          height: Juego().tablero_jugador.boardSize + Juego().tablero_jugador.casillaSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Juego().buildTablero(),
          ),
        ),
        for (var i = 0; i < Juego().tablero_jugador.boardSize; i++)
          for (var j = 0; j < Juego().tablero_jugador.boardSize; j++)
            Positioned(
              top: i * Juego().tablero_jugador.casillaSize,
              left: j * Juego().tablero_jugador.casillaSize,
              child: GestureDetector(
                onTap: () => _handleTap(i, j),
                child: Container(
                  width: Juego().tablero_jugador.casillaSize,
                  height: Juego().tablero_jugador.casillaSize,
                  color: Colors.transparent,
                  child: _ataques[i][j]
                      ? Icon(Juego().tablero_jugador.barcos.any((barco) => barco.barcoPosition.dx == j && barco.barcoPosition.dy == i) ? Icons.close : Icons.circle, color: Colors.white)
                      : null,
                ),
              ),
            ),
      ],
    );
  }

  void _handleTap(int i, int j) {
    setState(() {
      _ataques[i][j] = true;
    });

    // Navegar a la pantalla "Defender"
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Atacar()),
    );
  }
}
