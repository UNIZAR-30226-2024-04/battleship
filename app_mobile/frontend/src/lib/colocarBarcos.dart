import 'package:battleship/authProvider.dart';
import 'package:battleship/destino.dart';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'botones.dart';
import 'comun.dart';
import 'barco.dart';
import 'atacar.dart';

class ColocarBarcos extends StatefulWidget {
  const ColocarBarcos({super.key});

  @override
  _ColocarBarcosState createState() => _ColocarBarcosState();
}

class _ColocarBarcosState extends State<ColocarBarcos> {
  Map<Barco, bool> _draggingStates = {};
  late Future<void> _barcosFuture;

  @override
  void initState() {
    super.initState();

    var barcos = Juego().tablero_jugador.barcos;
    _draggingStates = {
      for (var barco in barcos) barco: false,
    };

    _barcosFuture = inicializarBarcosJugador();
  }

  Future<void> inicializarBarcosJugador() async {
    await Juego().inicializarBarcosJugador();
  }

  Future<bool> moverBarco(Barco barco, bool rotar) async {
    print("VOY A MOVER BARCO CON POSICION: ${barco.barcoPosition} Y ROTAR: $rotar Y NOMBRE: ${AuthProvider().name} Y INDEX: ${Juego().tablero_jugador.barcos.indexOf(barco)}");
    return await Juego().moverBarco(Juego().urlMoverBarcoInicial, barco.barcoPosition, rotar, AuthProvider().name, Juego().tablero_jugador.barcos.indexOf(barco));
  }

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
            buildTitle('¡Coloca tu flota!', 28),
            FutureBuilder<void>(
              future: _barcosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Mientras espera que se complete la inicialización de los barcos, puedes mostrar un indicador de carga.
                  return const CircularProgressIndicator();
                } else {
                  // Una vez que se complete la inicialización, construir el tablero con los barcos.
                  return _construirTableroConBarcosEditable();
                }
              },
            ),
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
            children: buildTablero(),
          ),
        ),
        for (var barco in Juego().tablero_jugador.barcos)
          Positioned(
            top: barco.barcoPosition.dx * Juego().tablero_jugador.casillaSize,
            left: barco.barcoPosition.dy * Juego().tablero_jugador.casillaSize,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      barco.catchPosition();
                      barco.rotate();
                      late Future<bool> response = moverBarco(barco, true);
                      FutureBuilder<void>(
                        future: _barcosFuture,
                        builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Mientras espera que se complete la inicialización de los barcos, puedes mostrar un indicador de carga.
                              return const CircularProgressIndicator();
                            } else {
                              // Una vez que se complete la inicialización, construir el tablero con los barcos.
                              return _construirTableroConBarcosEditable();
                            }
                        },
                      );
                      response.then((value) {
                        if(!value) {
                          setState(() {
                            print("VOY A RESETEAR POSICION");
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
                      var newDx = (barco.barcoPosition.dx + details.delta.dy / Juego().tablero_jugador.casillaSize);
                      var newDy = (barco.barcoPosition.dy + details.delta.dx / Juego().tablero_jugador.casillaSize);

                      barco.barcoPosition = Offset(newDx, newDy);
                      barco.barcoPosition = Juego().boundPosition(barco.barcoPosition, barco.getHeight(Juego().tablero_jugador.casillaSize), barco.getWidth(Juego().tablero_jugador.casillaSize));
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      barco.barcoPosition = Offset(barco.barcoPosition.dx.roundToDouble(), barco.barcoPosition.dy.roundToDouble());
                      barco.barcoPosition = Juego().boundPosition(barco.barcoPosition, barco.getHeight(Juego().tablero_jugador.casillaSize), barco.getWidth(Juego().tablero_jugador.casillaSize));
                      _draggingStates[barco] = false;
                      late Future<bool> response = moverBarco(barco, false);
                      FutureBuilder<void>(
                        future: _barcosFuture,
                        builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Mientras espera que se complete la inicialización de los barcos, puedes mostrar un indicador de carga.
                              return const CircularProgressIndicator();
                            } else {
                              // Una vez que se complete la inicialización, construir el tablero con los barcos.
                              return _construirTableroConBarcosEditable();
                            }
                        },
                      );
                      response.then((value) {
                        if(!value) {
                          setState(() {
                            print("VOY A RESETEAR POSICION");
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
                      width: barco.getWidth(Juego().tablero_jugador.casillaSize),
                      height: barco.getHeight(Juego().tablero_jugador.casillaSize),
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
    for (int i = 0; i < Juego().tablero_jugador.numFilas - 1; i++) {
      filas.add(buildFilaCasillas(i));
    }
    return filas;
  }

    Widget buildFilaCoordenadas() {
    List<Widget> coordenadas = [];
    // Etiqueta de columna vacía para compensar la columna de coordenadas
    coordenadas.add(SizedBox(
      width: Juego().tablero_jugador.casillaSize,
      height: Juego().tablero_jugador.casillaSize,
    ));
    // Etiquetas de columna
    for (int j = 1; j < Juego().tablero_jugador.numColumnas; j++) {
      coordenadas.add(
        Container(
          width: Juego().tablero_jugador.casillaSize,
          height: Juego().tablero_jugador.casillaSize,
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
        width: Juego().tablero_jugador.casillaSize,
        height: Juego().tablero_jugador.casillaSize,
        alignment: Alignment.center,
        child: Text(
          (rowIndex + 1).toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    // Casillas del tablero
    for (int j = 0; j < Juego().tablero_jugador.numColumnas - 1; j++) {
      casillas.add(Container(
        width: Juego().tablero_jugador.casillaSize,
        height: Juego().tablero_jugador.casillaSize,
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 116, 181, 213),
          border: Border.all(color: Colors.black, width: 1),
        ),
      ));
    }
    return Row(children: casillas);
  }

  void _handlePressed(BuildContext context) {
    Juego().crearPartida();
    DestinoManager.setDestino(Atacar());
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Atacar(),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }
}
