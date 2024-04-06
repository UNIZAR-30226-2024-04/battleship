import 'package:flutter/material.dart';

class Barco {
  String _nombre = "barco";
  Offset _barcoPosition = const Offset(0.0, 0.0);
  bool _esRotado = false;
  int _longitud = 0;
  Offset _barcoPositionCached = const Offset(0.0, 0.0);
  bool _esRotadoCached = false;
  bool _hundido = false;

  Barco(String nombre, Offset barcoPosition, int longitud, bool esRotado, bool hundido) {
    _nombre = nombre;
    _barcoPosition = barcoPosition;
    _longitud = longitud;
    _esRotado = esRotado;
    _barcoPositionCached = barcoPosition;
    _hundido = hundido;
  }

  // MOstrar información del barco
  void showInfo() {
    print("Nombre: $_nombre");
    print("Posición: $_barcoPosition");
    print("Longitud: $_longitud");
    print("Rotado: $_esRotado");
  }

  void catchPosition() {
    _barcoPositionCached = _barcoPosition;
    _esRotadoCached = _esRotado;
  }

  void resetPosition() {
    _barcoPosition = _barcoPositionCached;
    _esRotado = _esRotadoCached;
  }

  List<List<int>> getCasillasOcupadas(Offset position) {
    List<List<int>> casillasOcupadas = [];

    if (_esRotado) {
      for (int i = 0; i < _longitud; i++) {
        casillasOcupadas.add([(position.dx + i).toInt(), position.dy.toInt()]);
      }
    }
    else {
      for (int i = 0; i < _longitud; i++) {
        casillasOcupadas.add([position.dx.toInt(), (position.dy + i).toInt()]);
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

  // Getters
  String get nombre => _nombre;
  Offset get barcoPosition => _barcoPosition;
  int get longitud => _longitud;
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

  set nombre(String nombre) {
    _nombre = nombre;
  }

  set esRotado(bool esRotado) {
    _esRotado = esRotado;
  }

  String getImagePath() {
    if(!_esRotado) {
      return 'images/' + _nombre + '.png';
    }
    else {
      return 'images/' + _nombre + '_rotado.png';
    }
  }

  void rotate() {
    _esRotado = !_esRotado;
  }
}