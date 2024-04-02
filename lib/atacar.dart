import 'package:battleship/destino.dart';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'defender.dart';

class Atacar extends StatefulWidget {
  const Atacar({super.key});

  @override
  _AtacarState createState() => _AtacarState();
}

class _AtacarState extends State<Atacar> {

  @override
  void initState() {
    super.initState();
  }

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
        body: Column(
          children: [
            buildHeader(context),
            buildTitle('¡Ataca a tu rival!', 28),
            _construirTableroConBarcosAtacable(),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _construirTableroConBarcosAtacable() {
    List<Widget> children = [];

    children.add(
      SizedBox(
        width: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
        height: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildTableroClicable(_handleTap),
        ),
      ),
    );  



    return Stack(children: children);
  }


  List<Widget> buildTableroClicable(Function(int, int) onTap) {
    List<Widget> filas = [];
    // Añade una fila adicional para las etiquetas de las coordenadas
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().tablero_oponente.numFilas; i++) {
      filas.add(buildFilaCasillasClicables(i, onTap));
    }
    return filas;
  }

  Widget buildFilaCoordenadas() {
    List<Widget> coordenadas = [];
    // Etiqueta de columna vacía para compensar la columna de coordenadas
    coordenadas.add(SizedBox(
      width: Juego().tablero_oponente.casillaSize,
      height: Juego().tablero_oponente.casillaSize,
    ));
    // Etiquetas de columna
    for (int j = 1; j < Juego().tablero_oponente.numColumnas; j++) {
      coordenadas.add(
        Container(
          width: Juego().tablero_oponente.casillaSize,
          height: Juego().tablero_oponente.casillaSize,
          alignment: Alignment.center,
          child: Text(
            String.fromCharCode(65 + j - 1),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Row(children: coordenadas);
  }
  


  Widget buildFilaCasillasClicables(int rowIndex, Function(int, int) onTap) {
    List<Widget> casillas = [];
    // Etiqueta de fila
    casillas.add(
      Container(
        width: Juego().tablero_oponente.casillaSize,
        height: Juego().tablero_oponente.casillaSize,
        alignment: Alignment.center,
        child: Text(
          rowIndex.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    for (int j = 1; j < Juego().tablero_oponente.numColumnas; j++) {
      casillas.add(
        GestureDetector(
          onTap: () {
            onTap(j, rowIndex);
          },
          child: Container(
            width: Juego().tablero_oponente.casillaSize,
            height: Juego().tablero_oponente.casillaSize,
            decoration: BoxDecoration(
              color: const Color.fromARGB(128, 116, 181, 213),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Juego().tablero_oponente.casillasAtacadas[rowIndex][j] ? Image.asset('images/redCross.png', fit: BoxFit.cover) : Image.asset('images/dot.png', fit: BoxFit.cover),
          ),
        ),
      );
    }
    return Row(children: casillas);
  }


  void _handleTap(int i, int j) {
    setState(() {
      Juego().tablero_oponente.casillasAtacadas[i][j] = true;
    });

    // Si la casilla tiene un barco.
    if(Juego().tablero_oponente.casillasOcupadas[i][j]) {
      setState(() {
        Juego().actualizarBarcosRestantes();
      });
    }
    else {
      setState(() {
        Juego().cambiarTurno();
      });
      DestinoManager.setDestino(const Defender());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Defender()),
      );
    }
  }
}
