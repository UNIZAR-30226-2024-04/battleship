import 'package:flutter/material.dart';
import 'comun.dart';

class Jugar extends StatelessWidget {
  const Jugar({superKey, Key? key});

  @override
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHeader(context),
              const Spacer(),
              SizedBox(
                width: 360, // Ancho del tablero
                height: 360, // Altura del tablero
                child: Column(
                  children: _buildTablero(10, 10, 2, 2, 2, 5, 2, 'barco2'),
                ),
              ),
              const Spacer(),
              buildActions(context)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTablero(int numFilas, int numColumnas, int i0, int j0, int i1, int j1, int numPartes, String nombreBaseBarco) {
    List<Widget> filas = [];
    for (int i = 0; i < numFilas; i++) {
      filas.add(_buildFilaCasillas(numColumnas, i, i0, j0, i1, j1, numPartes, nombreBaseBarco));
    }
    return filas;
  }

  Widget _buildFilaCasillas(int numColumnas, int filaActual, int i0, int j0, int i1, int j1, int numPartes, String nombreBaseBarco) {
    List<Widget> casillas = [];
    int numParte = 0;
    for (int j = 0; j < numColumnas; j++) {
      bool esBarco = (filaActual >= i0 && filaActual <= i1 && j >= j0 && j <= j1);
      if (esBarco) {
        casillas.add(Container(
          width: 36, // Ancho de la casilla
          height: 36, // Altura de la casilla
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/${nombreBaseBarco}_$numParte.png'), fit: BoxFit.cover),
            color: const Color.fromARGB(128, 116, 181, 213), // Color de fondo de la casilla con opacidad reducida
            border: Border.all(color: Colors.black, width: 1), // Borde negro grueso
          ),
        ));
        numParte ++;
      } else {
        casillas.add(Container(
          width: 36, // Ancho de la casilla
          height: 36, // Altura de la casilla
          decoration: BoxDecoration(
            color: const Color.fromARGB(128, 116, 181, 213), // Color de fondo de la casilla con opacidad reducida
            border: Border.all(color: Colors.black, width: 1), // Borde negro grueso
          ),
        ));
      }
    }
    return Row(children: casillas);
  }
}