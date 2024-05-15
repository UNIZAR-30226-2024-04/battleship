import 'dart:async';
import 'package:battleship/authProvider.dart';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'barco.dart';
import 'serverRoute.dart';

class Flota extends StatefulWidget {
  const Flota({super.key});

  @override
  _FlotaState createState() => _FlotaState();
}

class _FlotaState extends State<Flota> {
  Map<Barco, bool> _draggingStates = {};
  ServerRoute server_route = ServerRoute();

  @override
  void initState() {
    super.initState();

    var barcos = Juego().miTablero.barcos;
    _draggingStates = {
      for (var barco in barcos) barco: false,
    };
  }

  Future<bool> moverBarco(Barco barco, bool rotar) async {
    return await Juego().moverBarco(server_route.urlMoverBarcoInicial, barco.barcoPosition, rotar, AuthProvider().name, Juego().miTablero.barcos.indexOf(barco));
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
            buildTitle('¡Coloca tu flota!', 28),
            _construirTableroConBarcosEditable(),
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
          width: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
          height: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildTablero(),
          ),
        ),
        for (var barco in Juego().miTablero.barcos)
          Positioned(
            top: barco.barcoPosition.dx * Juego().miTablero.casillaSize,
            left: barco.barcoPosition.dy * Juego().miTablero.casillaSize,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      barco.catchPosition();
                      barco.rotate();
                      late Future<bool> response = moverBarco(barco, true);
                      _construirTableroConBarcosEditable();
                      response.then((value) {
                        if(!value) {
                          setState(() {
                            barco.resetPosition();
                          });
                        }
                      });
                    });
                  },
                  onPanStart: (details) {
                    setState(() {
                      _draggingStates[barco] = true;
                      barco.catchPosition();
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      // ¡¡ GestureDetector interpreta (columna, fila) en lugar de (fila, columna) !!
                      var newDx = (barco.barcoPosition.dx + details.delta.dy / Juego().miTablero.casillaSize);
                      var newDy = (barco.barcoPosition.dy + details.delta.dx / Juego().miTablero.casillaSize);

                      barco.barcoPosition = Offset(newDx, newDy);
                      barco.barcoPosition = Juego().boundPosition(barco.barcoPosition, barco.getHeight(Juego().miTablero.casillaSize), barco.getWidth(Juego().miTablero.casillaSize));
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      barco.barcoPosition = Offset(barco.barcoPosition.dx.roundToDouble(), barco.barcoPosition.dy.roundToDouble());
                      barco.barcoPosition = Juego().boundPosition(barco.barcoPosition, barco.getHeight(Juego().miTablero.casillaSize), barco.getWidth(Juego().miTablero.casillaSize));
                      _draggingStates[barco] = false;
                      late Future<bool> response = moverBarco(barco, false);
                      _construirTableroConBarcosEditable();
                      response.then((value) {
                        if(!value) {
                          setState(() {
                            barco.resetPosition();
                          });
                        }
                      });
                    });
                  },
                  child: Opacity(
                    opacity: _draggingStates[barco] ?? false ? 0.5 : 1.0,
                    child: Image.asset(
                      barco.getImagePath(),
                      width: barco.getWidth(Juego().miTablero.casillaSize),
                      height: barco.getHeight(Juego().miTablero.casillaSize),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> buildTablero() {
    List<Widget> filas = [];
    // Añade una fila adicional para las etiquetas de las coordenadas
    filas.add(buildFilaCoordenadas());
    for (int i = 0; i < Juego().miTablero.numFilas - 1; i++) {
      filas.add(buildFilaCasillas(i));
    }
    return filas;
  }

    Widget buildFilaCoordenadas() {
    List<Widget> coordenadas = [];
    // Etiqueta de columna vacía para compensar la columna de coordenadas
    coordenadas.add(SizedBox(
      width: Juego().miTablero.casillaSize,
      height: Juego().miTablero.casillaSize,
    ));
    // Etiquetas de columna
    for (int j = 1; j < Juego().miTablero.numColumnas; j++) {
      coordenadas.add(
        Container(
          width: Juego().miTablero.casillaSize,
          height: Juego().miTablero.casillaSize,
          alignment: Alignment.center,
          child: Text(
            String.fromCharCode(65 + j - 1),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Row(children: coordenadas);
  }

  Widget buildFilaCasillas(int rowIndex) {
    List<Widget> casillas = [];
    // Etiqueta de fila
    casillas.add(
      Container(
        width: Juego().miTablero.casillaSize,
        height: Juego().miTablero.casillaSize,
        alignment: Alignment.center,
        child: Text(
          (rowIndex + 1).toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    // Casillas del tablero
    for (int j = 0; j < Juego().miTablero.numColumnas - 1; j++) {
      casillas.add(Container(
        width: Juego().miTablero.casillaSize,
        height: Juego().miTablero.casillaSize,
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 116, 181, 213),
          border: Border.all(color: Colors.black, width: 1),
        ),
      ));
    }
    return Row(children: casillas);
  }
}
