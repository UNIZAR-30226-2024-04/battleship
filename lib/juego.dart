import 'package:battleship/tablero.dart';
import 'package:flutter/material.dart';

class Juego {
  Tablero tablero_jugador = Tablero();
  Tablero tablero_rival = Tablero();

  // Instancia privada y estática del singleton
  static final Juego _singleton = Juego._internal();

  // Constructor privado
  Juego._internal() {
    tablero_jugador = Tablero();
    tablero_rival = Tablero();
  }

  // Constructor de fábrica
  factory Juego() {
    return _singleton;
  }

  List<Widget> buildTablero() {
    List<Widget> filas = [];
    // Añade una fila adicional para las etiquetas de las coordenadas
    filas.add(buildFilaCoordenadas());
    for (int i = 0; i < Juego().tablero_jugador.numFilas - 1; i++) {
      filas.add(buildFilaCasillas(i));
    }
    return filas;
  }


  List<Widget> buildTableroClicable(Function(int, int) onTap) {
    List<Widget> filas = [];
    // Añade una fila adicional para las etiquetas de las coordenadas
    filas.add(buildFilaCoordenadas());
    for (int i = 0; i < Juego().tablero_jugador.numFilas - 1; i++) {
      filas.add(buildFilaCasillasClicables(i, onTap));
    }
    return filas;
  }

  Widget buildFilaCoordenadas() {
    List<Widget> coordenadas = [];
    // Etiqueta de columna vacía para compensar la columna de coordenadas
    coordenadas.add(Container(
      width: Juego().tablero_jugador.casillaSize,
      height: Juego().tablero_jugador.casillaSize,
    ));
    // Etiquetas de columna
    for (int j = 1; j < Juego().tablero_jugador.numColumnas; j++) {
      coordenadas.add(
        Container(
          width: Juego().tablero_jugador.casillaSize,
          height: Juego().tablero_jugador.casillaSize,
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

  Widget buildFilaCasillas(int rowIndex) {
    List<Widget> casillas = [];
    // Etiqueta de fila
    casillas.add(
      Container(
        width: Juego().tablero_jugador.casillaSize,
        height: Juego().tablero_jugador.casillaSize,
        alignment: Alignment.center,
        child: Text(
          (rowIndex + 1).toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    // Casillas del tablero
    for (int j = 0; j < Juego().tablero_jugador.numColumnas - 1; j++) {
      casillas.add(Container(
        width: Juego().tablero_jugador.casillaSize,
        height: Juego().tablero_jugador.casillaSize,
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 116, 181, 213),
          border: Border.all(color: Colors.black, width: 1),
        ),
      ));
    }
    return Row(children: casillas);
  }

  Widget buildFilaCasillasClicables(int rowIndex, Function(int, int) onTap) {
    List<Widget> casillas = [];
    // Etiqueta de fila
    casillas.add(
      Container(
        width: tablero_jugador.casillaSize,
        height: tablero_jugador.casillaSize,
        alignment: Alignment.center,
        child: Text(
          (rowIndex + 1).toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    for (int j = 0; j < tablero_jugador.numColumnas - 1; j++) {
      casillas.add(
        GestureDetector(
          onTap: () => onTap(rowIndex, j),
          child: Container(
            width: tablero_jugador.casillaSize,
            height: tablero_jugador.casillaSize,
            decoration: BoxDecoration(
              color: const Color.fromARGB(128, 116, 181, 213),
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
        ),
      );
    }
    return Row(children: casillas);
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