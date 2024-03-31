import 'dart:html';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'barco.dart';

class Jugar extends StatefulWidget {
  const Jugar({Key? key}) : super(key: key);

  @override
  _JugarState createState() => _JugarState();
}

class _JugarState extends State<Jugar> {
  static int _numFilas = 0;
  static int _numColumnas = 0;
  Map<Barco, bool> _draggingStates = {};
  static double _casillaSize = 0.0;
  static double _boardSize = 0.0;
  List<Barco> barcos = [];

  @override
  void initState() {
    super.initState();
    _numFilas = 10;
    _numColumnas = 10;
    _boardSize = 360.0;
    _casillaSize = _boardSize / _numFilas;
    //Barco barco1 = Barco('acorazado', Offset(0, 0), 3, 3*_casillaSize, false);
    Barco barco2 = Barco('destructor_rotado', Offset(2.0, 2.0), 3, 3*_casillaSize, true);
    //Barco barco3 = Barco('patrullero', Offset(3, 2), 2, 2*_casillaSize, false);
    //Barco barco4 = Barco('portaaviones', Offset(5, 5), 2, 2*_casillaSize, false);
    //Barco barco5 = Barco('submarino_rotado', Offset(6, 6), 2, 2*_casillaSize, true);
    barcos = [barco2];
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
            const Spacer(),
            _construirTableroConBarcos(),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }


  Widget _construirTableroConBarcos() {
    return Stack(
      children: [
        SizedBox(
          width: _boardSize, // Ancho del tablero
          height: _boardSize, // Altura del tablero
          child: Column(
            children: _buildTablero(),
          ),
        ),
        for (Barco barco in barcos)
          Positioned(
            top: barco.barcoPosition.dy*_casillaSize,
            left: barco.barcoPosition.dx*_casillaSize,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _draggingStates[barco] = true;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  barco.barcoPosition += details.delta;
                  barco.barcoPosition = _boundPosition(barco.barcoPosition, barco.barcoSize, barco.esRotado);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _draggingStates[barco] = false;
                });
              },
              child: Opacity(
                opacity: _draggingStates[barco] ?? false ? 0.5 : 1.0,
                child: Image.asset(
                  'images/'+barco.nombre+'.png',
                  width: barco.getWidth(_casillaSize),
                  height: barco.getHeight(_casillaSize),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildTablero() {
    List<Widget> filas = [];
    for (int i = 0; i < _numFilas; i++) {
      filas.add(_buildFilaCasillas());
    }
    return filas;
  }

  Widget _buildFilaCasillas() {
    List<Widget> casillas = [];

    for (int j = 0; j < _numColumnas; j++) {
      casillas.add(Container(
        width: _casillaSize, // Ancho de la casilla
        height: _casillaSize, // Altura de la casilla
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 116, 181, 213), // Color de fondo de la casilla con opacidad reducida
          border: Border.all(color: Colors.black, width: 1), // Borde negro grueso
        ),
      ));
    }

    return Row(children: casillas);
  }

  Offset _boundPosition(Offset newPosition, double barcoSize, bool esRotado) {
    double x, y;

    if (!esRotado) {
      x = newPosition.dx.clamp(0.0, _boardSize - barcoSize);
      y = newPosition.dy.clamp(0.0, _boardSize - _casillaSize);
    } else {
      x = newPosition.dx.clamp(0.0, _boardSize - _casillaSize);
      y = newPosition.dy.clamp(0.0, _boardSize - barcoSize);
    }

    return Offset(x, y);
  }
}
