import 'package:flutter/material.dart';

class Barco {
  String _nombre = "barco";
  Offset _barcoPosition = Offset(0.0, 0.0);
  double _barcoSize = 0.0;
  bool _esRotado = false;
  int _longitud = 0;
  bool error = false;

  Barco(String nombre, Offset barcoPosition, int longitud, double barcoSize, bool esRotado) {
    _nombre = nombre;
    _barcoPosition = barcoPosition;
    _longitud = longitud;
    _barcoSize = barcoSize;
    _esRotado = esRotado;
  }

  // Método que devuelve una matriz de casillas ocupadas por el barco. Si una de las casillas que
  // ocupa el barco está ocupada por otro barco, se considera que el barco no puede ser colocado
  // en esa posición y devuelve null.
  List<List<bool>>? getOcupadas(int numFilas, int numColumnas, List<List<bool>> ocupadas) {
    List<List<bool>> nuevaOcupadas = List.generate(numFilas, (_) => List.generate(numColumnas, (_) => false));

    for (int i = 0; i < _longitud; i++) {
      int x, y;
      if (_esRotado) {
        x = _barcoPosition.dx.toInt();
        y = (_barcoPosition.dy + i).toInt();
      } else {
        x = (_barcoPosition.dx + i).toInt();
        y = _barcoPosition.dy.toInt();
      }

      // Comprueba si la posición está dentro del tablero
      if (x < 0 || x >= numFilas || y < 0 || y >= numColumnas) {
        return null;
      }

      // Comprueba si la posición ya está ocupada
      if (ocupadas[x][y]) {
        return null;
      }

      nuevaOcupadas[x][y] = true;
    }

    return nuevaOcupadas;
  }


  // Getters
  String get nombre => _nombre;
  Offset get barcoPosition => _barcoPosition;
  int get longitud => _longitud;
  double get barcoSize => _barcoSize;
  bool get esRotado => _esRotado;
  double getWidth(double _casillaSize) => esRotado ? _casillaSize : _longitud * _casillaSize;
  double getHeight(double _casillaSize) => esRotado ? _longitud * _casillaSize : _casillaSize;

  //Setters
  set barcoPosition(Offset barcoPosition) {
    _barcoPosition = barcoPosition;
  }

  set longitud(int longitud) {
    _longitud = longitud;
  }

  set barcoSize(double barcoSize) {
    _barcoSize = barcoSize;
  }

  set nombreBaseBarco(String nombre) {
    _nombre = nombre;
  }

  set esRotado(bool esRotado) {
    _esRotado = esRotado;
  }
}