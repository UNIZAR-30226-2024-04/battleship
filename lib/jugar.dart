import 'package:flutter/material.dart';

class Jugar extends StatefulWidget {
  const Jugar({Key? key}) : super(key: key);

  @override
  _JugarState createState() => _JugarState();
}

class _JugarState extends State<Jugar> {
  static const String _nombreBaseBarco = 'barco1';
  static const int _numFilas = 10;
  static const int _numColumnas = 10;
  late Offset _barcoPosition;
  static const int _numPartesBarco = 3;
  static double _barcoSize = 0.0;
  bool _isDragging = false;
  static double _casillaSize = 0.0;
  static const double _boardSize = 360.0;

  @override
  void initState() {
    super.initState();
    _barcoPosition = Offset(0, 0); // Inicializa la posición del barco
     _casillaSize = _boardSize / _numFilas;
    _barcoSize = _numPartesBarco * _casillaSize;
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  Positioned(
                    top: _barcoPosition.dy,
                    left: _barcoPosition.dx,
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          _isDragging = true;
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _barcoPosition += details.delta;
                          _barcoPosition = _boundPosition(_barcoPosition);
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
                          'images/$_nombreBaseBarco.png',
                          width: _barcoSize,
                          height: _casillaSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
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

  Offset _boundPosition(Offset newPosition) {
    double x = (newPosition.dx / _casillaSize).round() * _casillaSize;
    double y = (newPosition.dy / _casillaSize).round() * _casillaSize;

    x = x.clamp(0.0, _boardSize - _barcoSize);
    y = y.clamp(0.0, _boardSize - _casillaSize);

    return Offset(x, y);
  }
}
