import 'package:flutter/material.dart';
import 'barco.dart';

class Tablero {
  final int _numFilas = 11;
  final int _numColumnas = 11;
  double _casillaSize = 0.0;
  double _boardSize = 0.0;
  List<Barco> _barcos = [];
  // Matriz de casillas ocupadas por los barcos
  List<List<bool>> _casillasOcupadas = List.generate(11, (_) => List.filled(11, false));
  // Matriz de casillas atacadas por el jugador
  List<List<bool>> _casillasAtacadas = List.generate(11, (_) => List.filled(11, false));

  Tablero() {
    _casillasOcupadas = List.generate(_numFilas + 1, (_) => List.filled(_numColumnas + 1, false));
    _casillasAtacadas = List.generate(_numFilas + 1, (_) => List.filled(_numColumnas + 1, false));
    _boardSize = 363.0;
    _casillaSize = _boardSize / _numFilas;
    Barco barco1 = Barco('acorazado', const Offset(1, 2), 3, 3*_casillaSize, false);
    Barco barco2 = Barco('destructor_rotado', const Offset(7, 3), 3, 3*_casillaSize, true);
    Barco barco3 = Barco('patrullero', const Offset(2, 3), 2, 2*_casillaSize, false);
    Barco barco4 = Barco('portaaviones', const Offset(5, 5), 2, 2*_casillaSize, false);
    Barco barco5 = Barco('submarino_rotado', const Offset(6, 6), 2, 2*_casillaSize, true);
    _barcos = [barco1, barco2, barco3, barco4, barco5];

    // Actualizar la matriz de casillas ocupadas
    for (var barco in _barcos) {
      barco.updateOcupadas(_casillasOcupadas);
    }
  }

  //Getters
  int get numFilas => _numFilas;
  int get numColumnas => _numColumnas;
  double get casillaSize => _casillaSize;
  double get boardSize => _boardSize;
  List<Barco> get barcos => _barcos;
  List<List<bool>> get casillasOcupadas => _casillasOcupadas;
  List<List<bool>> get casillasAtacadas => _casillasAtacadas;

  // Setters
  set casillaSize(double casillaSize) {
    _casillaSize = casillaSize;
  }

  set boardSize(double boardSize) {
    _boardSize = boardSize;
  }

  set barcos(List<Barco> barcos) {
    _barcos = barcos;
  }

  set casillasOcupadas(List<List<bool>> casillasOcupadas) {
    _casillasOcupadas = casillasOcupadas;
  }

  set casillasAtacadas(List<List<bool>> casillasAtacadas) {
    _casillasAtacadas = casillasAtacadas;
  }

  void updateCasillasOcupadas() {
    for (var barco in _barcos) {
      barco.updateOcupadas(_casillasOcupadas);
    }
  }
}
