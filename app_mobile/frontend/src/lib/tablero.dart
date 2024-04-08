import 'barco.dart';

class Tablero {
  final int _numFilas = 11;
  final int _numColumnas = 11;
  double _casillaSize = 0.0;
  double _boardSize = 0.0;
  List<Barco> _barcos = [];
  // Matriz de casillas atacadas por el jugador
  List<List<bool>> _casillasAtacadas = List.generate(11, (_) => List.filled(11, false));

  Tablero() {
    _casillasAtacadas = List.generate(_numFilas + 1, (_) => List.filled(_numColumnas + 1, false));
    _boardSize = 374.0;
    _casillaSize = _boardSize / _numFilas;
    _barcos = [];
  }

  //Getters
  int get numFilas => _numFilas;
  int get numColumnas => _numColumnas;
  double get casillaSize => _casillaSize;
  double get boardSize => _boardSize;
  List<Barco> get barcos => _barcos;
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

  set casillasAtacadas(List<List<bool>> casillasAtacadas) {
    _casillasAtacadas = casillasAtacadas;
  }
}
