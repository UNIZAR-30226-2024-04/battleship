import 'package:battleship/destino.dart';
import 'package:battleship/juego.dart';
import 'package:battleship/main.dart';
import 'package:flutter/material.dart';
import 'barco.dart';
import 'comun.dart';
import 'defender.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Atacar extends StatefulWidget {
  String urlDisparar = 'http://localhost:8080/partida/realizarDisparo';

  Atacar({super.key});

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
            const Spacer(),
            _construirBarcosRestantes(),
            _construirTableroConBarcosAtacable(),   
            _construirHabilidades(),
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTitle('Barcos restantes del rival: ${Juego().getBarcosRestantesOponente()}', 16),
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
                          Juego().tablero_oponente.barcos[i].getImagePath(), 
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


  Widget _construirHabilidades() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < Juego().getHabilidadesJugador().length; i++)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!Juego().getHabilidadesJugador()[i].disponible()) return;
                            Juego().getHabilidadesUtilizadasJugador()[i] = true;
                            Juego().habilidadSeleccionadaEnTurno = true;
                            Juego().indexHabilidad = i;
                          });
                          print('Habilidad ${Juego().getHabilidadesOponente()[i].nombre} clicada');
                        },
                        child: Opacity(
                          opacity: !Juego().getHabilidadesJugador()[i].disponible() ? 0.3 : 1.0,
                          child: Image.asset(
                            Juego().getHabilidadesJugador()[i].getImagePath(), 
                            width: 50, 
                            height: 50,
                          ),
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
            ),// CASILLAS ATACADAS Y OCUPADAS (BACKEND)
            child: Juego().tablero_oponente.casillasAtacadas[rowIndex][j] ? Image.asset('images/redCross.png', fit: BoxFit.cover) : Image.asset('images/dot.png', fit: BoxFit.cover),
          ),
        ),
      );
    }
    return Row(children: casillas);
  }


  Widget _construirTableroConBarcosMina(Function(int, int) onTap) {
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
            children: buildTableroClicable(onTap),
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
                'images/${barcosOponente[i].nombre}.png',
                width: barcosOponente[i].getWidth(Juego().tablero_oponente.casillaSize),
                height: barcosOponente[i].getHeight(Juego().tablero_oponente.casillaSize),
              ),
            ),
      ],
    );
  }

  Future<bool> dispararCoordenada(int i, int j) async {
      var response = await http.post(
        Uri.parse(widget.urlDisparar),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'codigo': Juego().codigo,
          'jugador': Juego().turno,
          'i': i,
          'j': j,
        }),
      );

    var data = jsonDecode(response.body);

    print(data);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //var tableroInicial = data['tableroInicial'];
      print(data);
      if (data != null) {
        print("DISPARO REALIZADO");
        return true;
      }
      return false;
    } else {
      return false;
    }
  }





  void _handleTap(int i, int j) {
    print("TURNO: ${Juego().turno}");
    dispararCoordenada(i, j);
    print("HE DISPARADO EN: $i $j");
    Juego().disparosPendientes--;
    //Juego().actualizarPartida();
    print("HE ACTUALIZADO LA PARTIDA");
  
    // BACKENDDDDDDDDDDDDDDDDDDDD
    // Si la casilla tiene un barco.
    if(true) { // casillas ocupadas
      Juego().actualizarBarcosRestantes();
      if(!Juego().habilidadSeleccionadaEnTurno) {
        Juego().disparosPendientes++;
      }
      if(Juego().juegoTerminado()) {
        print("¡Juego terminado!");
        print("¡Ganador: ${Juego().getGanador()}!");
        Juego().reiniciarPartida();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Principal(),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      }
    }

    if (Juego().disparosPendientes == 0) {
      Juego().contabilizarAtaque();
      Juego().callbackAtaque();
      Juego().disparosPendientes = 1;
      Juego().habilidadSeleccionadaEnTurno = false;
      Juego().cambiarTurno();
      DestinoManager.setDestino(const Defender());
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const Defender(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }
}
