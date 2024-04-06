import 'dart:async';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'barco.dart';
import 'atacar.dart';
import 'destino.dart';

class Defender extends StatefulWidget {
  const Defender({super.key});

  @override
  _DefenderState createState() => _DefenderState();
}

class _DefenderState extends State<Defender> {

  @override
  void initState() {
    super.initState();
    iniciarTransicionAutomatica();
  }

  void iniciarTransicionAutomatica() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        Juego().contabilizarAtaque();
        Juego().callbackAtaque();
        Juego().disparosPendientes = 1;
        Juego().habilidadSeleccionadaEnTurno = false;
        Juego().cambiarTurno();
      });
      DestinoManager.setDestino(Atacar());
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Atacar(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    });
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
            const Spacer(),
            _construirBarcosRestantes(),
            _construirTableroConBarcosDefensa(),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _construirBarcosRestantes() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTitle('Tus barcos restantes: ${Juego().getBarcosRestantesOponente()}', 16),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < Juego().tablero_oponente.barcos.length; i++) 
                if (Juego().barcosRestantes_oponente[i]) 
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          'images/${Juego().tablero_oponente.barcos[i].nombre}.png', 
                          width: 50, 
                          height: 50,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5), 
                        child: Text(
                          Juego().tablero_oponente.barcos[i].longitud.toString(),
                          style: const TextStyle(
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

  Widget _construirTableroConBarcosDefensa() {
    List<bool> barcosRestantesOponente = Juego().barcosRestantes_oponente;
    List<Barco> barcosOponente = Juego().barcos_oponente;

    // Construir una lista con las posiciones de los barcos hundidos para poner una cruz.
    List<List<int>> casillasConCruz = [];
    for(int i = 0; i < Juego().numBarcos; i++) {
      if(!barcosRestantesOponente[i]) {
        casillasConCruz += barcosOponente[i].getCasillasOcupadas(barcosOponente[i].barcoPosition);
      }
    }

    return Stack(
      children: [
        SizedBox(
          width: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
          height: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildTablero(),
          ),
        ),
        for(int i = 0; i < casillasConCruz.length; i++)
          Positioned(
            top: casillasConCruz[i][0] * Juego().tablero_oponente.casillaSize,
            left: casillasConCruz[i][1] * Juego().tablero_oponente.casillaSize,
            child: Column(
              children: [
                Image.asset(
                  'images/redCross.png',
                  width: Juego().tablero_oponente.casillaSize,
                  height: Juego().tablero_oponente.casillaSize,
                ),
              ],
            ),
          ),

        for (int i = 0; i < Juego().numBarcos; i++)
          if (!contiene(casillasConCruz, barcosOponente[i].barcoPosition))
            Positioned(
              top: barcosOponente[i].barcoPosition.dx * Juego().tablero_oponente.casillaSize,
              left: barcosOponente[i].barcoPosition.dy * Juego().tablero_oponente.casillaSize,
              child: Image.asset(
                barcosOponente[i].getImagePath(),
                width: barcosOponente[i].getWidth(Juego().tablero_oponente.casillaSize),
                height: barcosOponente[i].getHeight(Juego().tablero_oponente.casillaSize),
                fit: BoxFit.fill,
              ),
            ),
      ],
    );
  }

  List<Widget> buildTablero() {
    List<Widget> filas = [];
    // Añade una fila adicional para las etiquetas de las coordenadas
    filas.add(buildFilaCoordenadas());
    for (int i = 0; i < Juego().tablero_oponente.numFilas - 1; i++) {
      filas.add(buildFilaCasillas(i));
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

  Widget buildFilaCasillas(int rowIndex) {
    List<Widget> casillas = [];
    // Etiqueta de fila
    casillas.add(
      Container(
        width: Juego().tablero_oponente.casillaSize,
        height: Juego().tablero_oponente.casillaSize,
        alignment: Alignment.center,
        child: Text(
          (rowIndex + 1).toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    // Casillas del tablero
    for (int j = 0; j < Juego().tablero_oponente.numColumnas - 1; j++) {
      casillas.add(Container(
        width: Juego().tablero_oponente.casillaSize,
        height: Juego().tablero_oponente.casillaSize,
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 116, 181, 213),
          border: Border.all(color: Colors.black, width: 1),
        ),
      ));
    }
    return Row(children: casillas);
  }
}
