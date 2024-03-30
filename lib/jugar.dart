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
  static const int _numFilas = 10;
  static const int _numColumnas = 10;
  bool _isDragging = false;
  static double _casillaSize = 0.0;
  static double _boardSize = 360.0;
  List<Barco> barcos = [];

  @override
  void initState() {
    super.initState();
    _casillaSize = _boardSize / _numFilas;
    Barco barco1 = Barco('barco1', Offset(0, 0), 3, 3*_casillaSize);
    Barco barco2 = Barco('barco2', Offset(2, 2), 2, 2*_casillaSize);
    barcos = [barco1, barco2];
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
            Stack(
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
                    top: barco.barcoPosition.dy,
                    left: barco.barcoPosition.dx,
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          _isDragging = true;
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          barco.barcoPosition += details.delta;
                          barco.barcoPosition = _boundPosition(barco.barcoPosition, barco.barcoSize);
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          _isDragging = false;
                        });
                      },
                      child: Opacity(
                        opacity: _isDragging ? 0.5 : 1.0,
                        child: Image.asset(
                          'images/'+barco.nombreBaseBarco+'.png',
                            width: barco.barcoSize,
                          height: _casillaSize,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
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

  Offset _boundPosition(Offset newPosition, double barcoSize) {
    double x = (newPosition.dx / _casillaSize).round() * _casillaSize;
    double y = (newPosition.dy / _casillaSize).round() * _casillaSize;

    x = x.clamp(0.0, _boardSize - barcoSize);
    y = y.clamp(0.0, _boardSize - _casillaSize);

    return Offset(x, y);
  }
}
