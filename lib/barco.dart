import 'package:flutter/material.dart';

class Barco {
  static String? _nombre = "";
  static Offset _barcoPosition = Offset(0.0, 0.0);
  static double _barcoSize = 0.0;
  static bool _esRotado = false;
  static int _longitud = 0;

  Barco(String nombre, Offset barcoPosition, int longitud, double barcoSize, bool esRotado) {
    _nombre = nombre;
    _barcoPosition = barcoPosition;
    _longitud = longitud;
    _barcoSize = barcoSize;
    _esRotado = esRotado;
    // Mostrar por consola
    print("Barco: " + _nombre! + " en posición: " + _barcoPosition.toString() + " con " + _longitud.toString() + " partes y tamaño: " + _barcoSize.toString());
  }

  // Getters
  String get nombre => _nombre!;
  Offset get barcoPosition => _barcoPosition;
  int get numPartesBarco => _longitud;
  double get barcoSize => _barcoSize;
  bool get esRotado => _esRotado;
  double getWidth(double _casillaSize) => esRotado ? _casillaSize : _longitud * _casillaSize;
  double getHeight(double _casillaSize) => esRotado ? _longitud * _casillaSize : _casillaSize;

  //Setters
  set barcoPosition(Offset barcoPosition) {
    _barcoPosition = barcoPosition;
  }

  set numPartesBarco(int longitud) {
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