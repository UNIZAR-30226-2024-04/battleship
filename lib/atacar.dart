import 'package:battleship/destino.dart';
import 'package:battleship/juego.dart';
import 'package:battleship/main.dart';
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
            _construirBarcosRestantes(),
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

  Widget _construirBarcosRestantes() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTitle('Barcos restantes del rival: ${Juego().getBarcosRestantesOponente()}', 16),
          SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < Juego().tablero_oponente.barcos.length; i++) 
                if (Juego().barcosRestantes_oponente[i]) 
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          'images/${Juego().tablero_oponente.barcos[i].nombre}.png', 
                          width: 50, 
                          height: 50,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5), 
                        child: Text(
                          Juego().tablero_oponente.barcos[i].longitud.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildTableroClicable(Function(int, int) onTap) {
    List<Widget> filas = [];
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().tablero_oponente.numFilas; i++) {
      filas.add(buildFilaCasillasClicables(i, onTap));
    }
    return filas;
  }

  Widget buildFilaCoordenadas() {
    List<Widget> coordenadas = [];
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
            setState(() {
              onTap(rowIndex, j);
            });
          },
          child: Container(
            width: Juego().tablero_oponente.casillaSize,
            height: Juego().tablero_oponente.casillaSize,
            decoration: BoxDecoration(
              color: const Color.fromARGB(128, 116, 181, 213),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Juego().tablero_oponente.casillasAtacadas[rowIndex][j] && Juego().tablero_oponente.casillasOcupadas[rowIndex][j] ? Image.asset('images/redCross.png', fit: BoxFit.cover) : Image.asset('images/dot.png', fit: BoxFit.cover),
          ),
        ),
      );
    }
    return Row(children: casillas);
  }


  void _handleTap(int i, int j) {
    Juego().tablero_oponente.casillasAtacadas[i][j] = true;

    // Si la casilla tiene un barco.
    if(Juego().tablero_oponente.casillasOcupadas[i][j]) {
      setState(() {
        Juego().actualizarBarcosRestantes();
      });
      if(Juego().juegoTerminado()) {
        print("¡Juego terminado!");
        print("¡Ganador: ${Juego().getGanador()}!");
        Juego().reiniciarPartida();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Principal()),
        );
      }
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
