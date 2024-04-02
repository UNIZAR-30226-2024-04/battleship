import 'package:battleship/tablero.dart';
import 'package:flutter/material.dart';
import 'barco.dart';

class Juego {
  Tablero tablero_jugador1 = Tablero();
  Tablero tablero_jugador2 = Tablero();
  int numBarcos = 5;  // Número de barcos que tiene cada jugador
  int barcosRestantesJugador1 = 0;  // Número de barcos que tiene el jugador 1
  int barcosRestantesJugador2 = 0;  // Número de barcos que tiene el jugador 2
  int turno = 1;  // 1: Jugador 1, 2: Jugador 2
  List<bool> barcosJugador1 = [];  // Barcos que tiene el jugador 1
  List<bool> barcosJugador2 = [];  // Barcos que tiene el jugador 2

  // Instancia privada y estática del singleton
  static final Juego _singleton = Juego._internal();

  // Constructor privado
  Juego._internal() {
    tablero_jugador1 = Tablero();
    tablero_jugador2 = Tablero();
    numBarcos = 5;
    barcosRestantesJugador1 = numBarcos;
    barcosRestantesJugador2 = numBarcos;
    turno = 1;
    barcosJugador1 = List.filled(numBarcos, true);
    barcosJugador2 = List.filled(numBarcos, true);
  }

  // Constructor de fábrica
  factory Juego() {
    return _singleton;
  }

  Tablero get tablero_jugador {
    return turno == 1 ? tablero_jugador1 : tablero_jugador2;
  }

  Tablero get tablero_oponente {
    return turno == 1 ? tablero_jugador2 : tablero_jugador1;
  }

  List<bool> get barcosRestantes_jugador {
    return turno == 1 ? barcosJugador1 : barcosJugador2;
  }

  List<bool> get barcosRestantes_oponente {
    return turno == 1 ? barcosJugador2 : barcosJugador1;
  }

  List<Barco> get barcos_jugador {
    return turno == 1 ? tablero_jugador1.barcos : tablero_jugador2.barcos;
  }

  List<Barco> get barcos_oponente {
    return turno == 1 ? tablero_jugador2.barcos : tablero_jugador1.barcos;
  }

  void cambiarTurno() {
    turno = turno == 1 ? 2 : 1;
  }

  bool barcoHundido(Barco barco, Tablero tablero) {
    List<List<int>> casillasOcupadas = barco.getCasillasOcupadas(barco.barcoPosition);
    for (int i = 0; i < casillasOcupadas.length; i++) {
      if (!tablero.casillasAtacadas[casillasOcupadas[i][0]][casillasOcupadas[i][1]]) {
        return false;
      }
    }
    return true;
  }

  void actualizarBarcosRestantes() {
    // Actualiza el número de barcos restantes del jugador 1
    for (int i = 0; i < barcosJugador1.length; i++) {
      if (barcosJugador1[i]) {
        Barco barco = tablero_jugador1.barcos[i];
        if (barcoHundido(barco, tablero_jugador1)) {
          barcosJugador1[i] = false;
          barcosRestantesJugador1--;
        }
      }
    }

    // Actualiza el número de barcos restantes del jugador 2
    for (int i = 0; i < barcosJugador2.length; i++) {
      if (barcosJugador2[i]) {
        Barco barco = tablero_jugador2.barcos[i];
        if (barcoHundido(barco, tablero_jugador2)) {
          barcosJugador2[i] = false;
          barcosRestantesJugador2--;
        }
      }
    }
  }

  Offset boundPosition(Offset position, double height, double width) {
    double dx = position.dx;
    double dy = position.dy;

    // Aseguramos que el barco no se salga por la izquierda o la parte superior del tablero
    dx = dx < 1 ? 1 : dx;
    dy = dy < 1 ? 1 : dy;

    // Aseguramos que el barco no se salga por la derecha o la parte inferior del tablero
    dx = dx + width / Juego().tablero_jugador.casillaSize > Juego().tablero_jugador.numColumnas ? Juego().tablero_jugador.numColumnas - width / Juego().tablero_jugador.casillaSize : dx;
    dy = dy + height / Juego().tablero_jugador.casillaSize > Juego().tablero_jugador.numFilas ? Juego().tablero_jugador.numFilas - height / Juego().tablero_jugador.casillaSize : dy;

    return Offset(dx, dy);
  }
}