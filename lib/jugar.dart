import 'package:flutter/material.dart';
import 'comun.dart';
import 'barco.dart';

class Jugar extends StatefulWidget {
  const Jugar({Key? key}) : super(key: key);

  @override
  _JugarState createState() => _JugarState();
}

class _JugarState extends State<Jugar> {
  static int _numFilas = 11;
  static int _numColumnas = 11;
  Map<Barco, bool> _draggingStates = {};
  static double _casillaSize = 0.0;
  static double _boardSize = 0.0;
  static List<Barco> barcos = [];
  // Matriz de casillas ocupadas por los barcos
  static List<List<bool>> _casillasOcupadas = List.generate(_numFilas, (_) => List.filled(_numColumnas, false));

  @override
  void initState() {
    super.initState();
    _boardSize = 341.0;
    _casillaSize = _boardSize / _numFilas;
    Barco barco1 = Barco('acorazado', Offset(1, 1), 3, 3*_casillaSize, false);
    Barco barco2 = Barco('destructor_rotado', Offset(3, 3), 3, 3*_casillaSize, true);
    Barco barco3 = Barco('patrullero', Offset(3, 2), 2, 2*_casillaSize, false);
    Barco barco4 = Barco('portaaviones', Offset(5, 5), 2, 2*_casillaSize, false);
    Barco barco5 = Barco('submarino_rotado', Offset(6, 6), 2, 2*_casillaSize, true);
    barcos = [barco1, barco2, barco3, barco4, barco5];
    _draggingStates = {
      for (var barco in barcos) barco: false,
    };
    // Actualizar la matriz de casillas ocupadas
    for (var barco in barcos) {
      _casillasOcupadas = barco.getOcupadas(_numFilas - 1, _numColumnas - 1, _casillasOcupadas)!;
    }
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
          width: _boardSize + _casillaSize,
          height: _boardSize + _casillaSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTablero(),
          ),
        ),
        for (var barco in barcos)
          Positioned(
            top: barco.barcoPosition.dy * _casillaSize,
            left: barco.barcoPosition.dx * _casillaSize,
            child: Column(
              children: [
                GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _draggingStates[barco] = true;
                    });
                    _casillasOcupadas = barco.getOcupadas(_numFilas - 1, _numColumnas - 1, _casillasOcupadas)!;
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      var newDx = (barco.barcoPosition.dx + details.delta.dx / _casillaSize);
                      var newDy = (barco.barcoPosition.dy + details.delta.dy / _casillaSize);

                      barco.barcoPosition = Offset(newDx, newDy);
                      barco.barcoPosition = _boundPosition(barco.barcoPosition, barco.getHeight(_casillaSize), barco.getWidth(_casillaSize), barco.esRotado);
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      barco.barcoPosition = Offset(barco.barcoPosition.dx.roundToDouble(), barco.barcoPosition.dy.roundToDouble());
                      _draggingStates[barco] = false;

                      List<List<bool>>? nuevaOcupadas = barco.getOcupadas(_numFilas - 1, _numColumnas - 1, _casillasOcupadas);
                      if (nuevaOcupadas == null) {
                        print('Error: el barco no puede ser colocado en esa posición');
                        barco.error = true; // Indicador de error
                      }
                      else {
                        _casillasOcupadas = nuevaOcupadas;
                        barco.error = false; // No hay error
                      }
                    });
                  },
                  child: Opacity(
                    opacity: _draggingStates[barco] ?? false ? 0.5 : 1.0,
                    child: Image.asset(
                      'images/' + (barco.error ? barco.nombre + '_rojo' : barco.nombre) + '.png', // Si hay un error, muestra la versión roja del barco
                      width: barco.getWidth(_casillaSize),
                      height: barco.getHeight(_casillaSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }


  List<Widget> _buildTablero() {
    List<Widget> filas = [];
    // Añade una fila adicional para las etiquetas de las coordenadas
    filas.add(_buildFilaCoordenadas());
    for (int i = 0; i < _numFilas - 1; i++) {
      filas.add(_buildFilaCasillas(i));
    }
    return filas;
  }

  Widget _buildFilaCoordenadas() {
    List<Widget> coordenadas = [];
    // Etiqueta de columna vacía para compensar la columna de coordenadas
    coordenadas.add(Container(
      width: _casillaSize,
      height: _casillaSize,
    ));
    // Etiquetas de columna
    for (int j = 1; j <= _numColumnas; j++) {
      coordenadas.add(
        Container(
          width: _casillaSize,
          height: _casillaSize,
          alignment: Alignment.center,
          child: Text(
            String.fromCharCode(65 + j - 1),
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Row(children: coordenadas);
  }

  Widget _buildFilaCasillas(int rowIndex) {
    List<Widget> casillas = [];
    // Etiqueta de fila
    casillas.add(
      Container(
        width: _casillaSize,
        height: _casillaSize,
        alignment: Alignment.center,
        child: Text(
          (rowIndex + 1).toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    // Casillas del tablero
    for (int j = 0; j < _numColumnas; j++) {
      casillas.add(Container(
        width: _casillaSize,
        height: _casillaSize,
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 116, 181, 213),
          border: Border.all(color: Colors.black, width: 1),
        ),
      ));
    }
    return Row(children: casillas);
  }

  Offset _boundPosition(Offset position, double height, double width, bool isRotated) {
    double dx = position.dx;
    double dy = position.dy;

    // Si el barco está rotado, intercambiamos el alto y el ancho
    if (isRotated) {
      double temp = width;
      width = height;
      height = temp;
    }

    // Aseguramos que el barco no se salga por la izquierda o la parte superior del tablero
    dx = dx < 1 ? 1 : dx;
    dy = dy < 1 ? 1 : dy;

    // Aseguramos que el barco no se salga por la derecha o la parte inferior del tablero
    dx = dx + width / _casillaSize > _numColumnas + 1 ? _numColumnas + 1 - width / _casillaSize : dx;
    dy = dy + height / _casillaSize > _numFilas ? _numFilas - height / _casillaSize : dy;
    
    return Offset(dx, dy);
  }
}
