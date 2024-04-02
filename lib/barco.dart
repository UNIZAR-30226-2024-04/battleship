import 'package:flutter/material.dart';

class Barco {
  String _nombre = "barco";
  Offset _barcoPosition = const Offset(0.0, 0.0);
  double _barcoSize = 0.0;
  bool _esRotado = false;
  int _longitud = 0;
  Offset _barcoPositionCached = const Offset(0.0, 0.0);

  Barco(String nombre, Offset barcoPosition, int longitud, double barcoSize, bool esRotado) {
    _nombre = nombre;
    _barcoPosition = barcoPosition;
    _longitud = longitud;
    _barcoSize = barcoSize;
    _esRotado = esRotado;
    _barcoPositionCached = barcoPosition;
  }

  void _catchPosition() {
    _barcoPositionCached = _barcoPosition;
  }

  void _resetPosition() {
    _barcoPosition = _barcoPositionCached;
  }

  List<List<int>> getCasillasOcupadas(Offset position) {
    List<List<int>> casillasOcupadas = [];

    if (_esRotado) {
      for (int i = 0; i < _longitud; i++) {
        casillasOcupadas.add([position.dx.toInt(), (position.dy + i).toInt()]);
      }
    }
    else {
      for (int i = 0; i < _longitud; i++) {
        casillasOcupadas.add([(position.dx + i).toInt(), position.dy.toInt()]);
      }
    }

    return casillasOcupadas;
  }

  bool casillaOcupadaPorMiBarco(int fila, int columna) {
    List<List<int>> casillasOcupadas = getCasillasOcupadas(_barcoPositionCached);
    for (int i = 0; i < casillasOcupadas.length; i++) {
      if (casillasOcupadas[i][0] == fila && casillasOcupadas[i][1] == columna) {
        return true;
      }
    }
    return false;
  }


  // Método que devuelve una matriz de casillas ocupadas por el barco. Si una de las casillas que
  // ocupa el barco está ocupada por otro barco, se considera que el barco no puede ser colocado
  // en esa posición y devuelve la matriz sin modificar, devolviendo el estado interno del barco al cacheado.
void updateOcupadas(List<List<bool>> casillasOcupadas) {
  List<List<int>> casillasOcupadasNuevas = getCasillasOcupadas(_barcoPosition);

  // Buscar conflictos con el resto de barcos.
  for (int i = 0; i < casillasOcupadasNuevas.length; i++) {
    int fila = casillasOcupadasNuevas[i][0];
    int columna = casillasOcupadasNuevas[i][1];

    // Si la casilla está ocupada por otro barco distinto de mí.
    if (casillasOcupadas[fila][columna] && !casillaOcupadaPorMiBarco(fila, columna)) {
      _resetPosition();
      return;
    }
  }

  // Liberar las casillas ocupadas por el barco en la posición anterior.
  List<List<int>> casillasOcupadasAntiguas = getCasillasOcupadas(_barcoPositionCached);
  for (int i = 0; i < casillasOcupadasAntiguas.length; i++) {
    int fila = casillasOcupadasAntiguas[i][0];
    int columna = casillasOcupadasAntiguas[i][1];
    casillasOcupadas[fila][columna] = false;
  }

  // Inserción correcta del barco. Reservar las casillas.
  for (int i = 0; i < casillasOcupadasNuevas.length; i++) {
    int fila = casillasOcupadasNuevas[i][0];
    int columna = casillasOcupadasNuevas[i][1];
    casillasOcupadas[fila][columna] = true;
  }

  // Actualizar la posición cacheada del barco.
  _catchPosition();
}

  // Getters
  String get nombre => _nombre;
  Offset get barcoPosition => _barcoPosition;
  int get longitud => _longitud;
  double get barcoSize => _barcoSize;
  bool get esRotado => _esRotado;
  double getWidth(double casillaSize) => esRotado ? casillaSize : _longitud * casillaSize;
  double getHeight(double casillaSize) => esRotado ? _longitud * casillaSize : casillaSize;

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