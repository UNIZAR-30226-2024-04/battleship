import 'package:flutter/material.dart';

class Barco {
  static String? _nombreBaseBarco = "";
  static Offset _barcoPosition = Offset(0, 0);
  static int _numPartesBarco = 0;
  static double _barcoSize = 0.0;

  Barco(String nombreBaseBarco, Offset barcoPosition, int numPartesBarco, double barcoSize) {
    _nombreBaseBarco = nombreBaseBarco;
    _barcoPosition = barcoPosition;
    _numPartesBarco = numPartesBarco;
    _barcoSize = barcoSize;
  }

  // Getters
  String get nombreBaseBarco => _nombreBaseBarco!;
  Offset get barcoPosition => _barcoPosition;
  int get numPartesBarco => _numPartesBarco;
  double get barcoSize => _barcoSize;

  //Setters
  set barcoPosition(Offset barcoPosition) {
    _barcoPosition = barcoPosition;
  }

  set numPartesBarco(int numPartesBarco) {
    _numPartesBarco = numPartesBarco;
  }

  set barcoSize(double barcoSize) {
    _barcoSize = barcoSize;
  }

  set nombreBaseBarco(String nombreBaseBarco) {
    _nombreBaseBarco = nombreBaseBarco;
  }
}