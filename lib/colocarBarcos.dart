import 'package:battleship/destino.dart';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'botones.dart';
import 'comun.dart';
import 'barco.dart';
import 'atacar.dart';

class ColocarBarcos extends StatefulWidget {
  const ColocarBarcos({Key? key}) : super(key: key);

  @override
  _ColocarBarcosState createState() => _ColocarBarcosState();
}

class _ColocarBarcosState extends State<ColocarBarcos> {
  Map<Barco, bool> _draggingStates = {};

  @override
  void initState() {
    super.initState();

    var barcos = Juego().tablero_jugador.barcos;
    _draggingStates = {
      for (var barco in barcos) barco: false,
    };
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
            buildTitle('¡Coloca tu flota!', 28),
            _construirTableroConBarcosEditable(),
            const Spacer(),
            buildActionButton(context, () => _handlePressed(context), "Comenzar"),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _construirTableroConBarcosEditable() {
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
        for (var barco in Juego().tablero_jugador.barcos)
          Positioned(
            top: barco.barcoPosition.dy * Juego().tablero_jugador.casillaSize,
            left: barco.barcoPosition.dx * Juego().tablero_jugador.casillaSize,
            child: Column(
              children: [
                GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _draggingStates[barco] = true;
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      var newDx = (barco.barcoPosition.dx + details.delta.dx / Juego().tablero_jugador.casillaSize);
                      var newDy = (barco.barcoPosition.dy + details.delta.dy / Juego().tablero_jugador.casillaSize);

                      barco.barcoPosition = Offset(newDx, newDy);
                      barco.barcoPosition = Juego().boundPosition(barco.barcoPosition, barco.getHeight(Juego().tablero_jugador.casillaSize), barco.getWidth(Juego().tablero_jugador.casillaSize));
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      barco.barcoPosition = Offset(barco.barcoPosition.dx.roundToDouble(), barco.barcoPosition.dy.roundToDouble());
                      barco.barcoPosition = Juego().boundPosition(barco.barcoPosition, barco.getHeight(Juego().tablero_jugador.casillaSize), barco.getWidth(Juego().tablero_jugador.casillaSize));
                      _draggingStates[barco] = false;
                      barco.updateOcupadas(Juego().tablero_jugador.casillasOcupadas);
                    });
                  },
                  child: Opacity(
                    opacity: _draggingStates[barco] ?? false ? 0.5 : 1.0,
                    child: Image.asset(
                      'images/' + barco.nombre + '.png',
                      width: barco.getWidth(Juego().tablero_jugador.casillaSize),
                      height: barco.getHeight(Juego().tablero_jugador.casillaSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _handlePressed(BuildContext context) {
    print('Comenzar button pressed');
    DestinoManager.setDestino(const Atacar());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Atacar()),
    );
  }
}
