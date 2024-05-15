import 'dart:async';
import 'dart:convert';
import 'package:battleship/barco.dart';
import 'package:battleship/botones.dart';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'comun.dart';
import 'serverRoute.dart';
import 'package:http/http.dart' as http;

class Mina extends StatefulWidget {
  const Mina({super.key});

  @override
  _MinaState createState() => _MinaState();
}
//
class _MinaState extends State<Mina> {
  ServerRoute serverRoute = ServerRoute();

  @override
  void initState() {
    super.initState();

    Juego().socket.on('disconnect', (_) {
      print('Conexión cerrada');
    });

    Juego().socket.on('abandono', (data) {
      if(data[1] != Juego().miPerfil.name) {
        Juego().reiniciarPartida();
        showSuccessSnackBar(context, '¡Has ganado la partida por abandono de tu oponente!');
        Navigator.pushNamed(context, '/Principal');
      }
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Juego().colorFondo,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            buildHeader(context, ponerPerfil: false),
            const SizedBox(height: 20),
            _construirBarcosRestantes(),
            _construirTableroConBarcosAtacable(),
            const Spacer(),
            buildActionButton(context, () {
              // Caso partida contra IA
              if(Juego().modalidadPartida == "INDIVIDUAL") {
                Juego().abandonarPartida(context);
                Juego().reiniciarPartida();
                Navigator.pushNamed(context, '/Principal');
              }
              else {
                Juego().abandonarPartidaMulti(context);
                Juego().reiniciarPartida();
                Navigator.pushNamed(context, '/Principal');
              }
            }, "Abandonar partida"),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /*
   * Construir tablero con barcos atacables.
   */
  Widget _construirTableroConBarcosAtacable() {
    return SizedBox(
      width: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
      height: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildTableroClicable(_handleTap),
      ),
    );
  }

  /*
   * Construir widget en el que se indican los barcos restantes del rival.
   */
  Widget _construirBarcosRestantes() {
    List<Barco> barcosRestantes = Juego().obtenerBarcosRestantesRival();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTitle('Barcos restantes del rival: ${Juego().barcosRestantesRival}', 16),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < barcosRestantes.length; i++)  
                Column(
                  children: [
                    // Imagen de los barcos restantes.
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        'images/${barcosRestantes[i].nombre}.png', 
                        width: 50, 
                        height: 50,
                      ),
                    ),
                    // Longitud de los barcos restantes.
                    Padding(
                      padding: const EdgeInsets.all(5), 
                      child: Text(
                        barcosRestantes[i].longitud.toString(),
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

  List<Widget> buildTableroClicable(Function(int, int) onTap) {
    List<Widget> filas = [];
    filas.add(buildTableroConBarcosHundidos(onTap));
    return filas;
  }

  Widget buildFilaCoordenadas() {
    List<Widget> coordenadas = [];
    coordenadas.add(SizedBox(
      width: Juego().miTablero.casillaSize,
      height: Juego().miTablero.casillaSize,
    ));

    // Etiquetas de columna
    for (int j = 1; j < Juego().miTablero.numColumnas; j++) {
      coordenadas.add(
        Container(
          width: Juego().miTablero.casillaSize,
          height: Juego().miTablero.casillaSize,
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
  
  Widget buildFilaCasillas(int rowIndex, Function(int, int) onTap) {
    List<Widget> casillas = [];
    casillas.add(
      Container(
        width: Juego().miTablero.casillaSize,
        height: Juego().miTablero.casillaSize,
        alignment: Alignment.center,
        child: Text(
          rowIndex.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    // Casillas del tablero
    for (int j = 1; j < Juego().miTablero.numColumnas; j++) {
      String imagePath = 'images/dot.png';
      if(Juego().minasColocadasPorMi.contains(Offset(rowIndex.toDouble(), j.toDouble()))){
        imagePath = 'images/mineSymbol.png';
      }

      casillas.add(
        GestureDetector(
          onTap: () async {
            await onTap(rowIndex, j);
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushNamed(context, '/Defender');
            });
          },
          child: Container(
            width: Juego().miTablero.casillaSize,
            height: Juego().miTablero.casillaSize,
            decoration: BoxDecoration(
              color: const Color.fromARGB(128, 116, 181, 213),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(children: casillas);
  }

  Widget buildTableroConBarcosHundidos(Function(int, int) onTap) {
    List<Barco> barcosRestantes = Juego().obtenerMisBarcosRestantes();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildTablero(onTap),
        ),
        for (var barco in Juego().miTablero.barcos)
          Positioned(
            top: barco.barcoPosition.dx * Juego().miTablero.casillaSize,
            left: barco.barcoPosition.dy * Juego().miTablero.casillaSize,
            child: Column(
              children: [
                GestureDetector(
                  child: Image.asset(
                    barco.getImagePath(),
                    width: barco.getWidth(Juego().miTablero.casillaSize),
                    height: barco.getHeight(Juego().miTablero.casillaSize),
                    fit: BoxFit.fill,
                    color: barcosRestantes.contains(barco) ? null : Colors.black.withOpacity(0.5),
                    colorBlendMode: barcosRestantes.contains(barco) ? null : BlendMode.darken,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> buildTablero(Function(int, int) onTap) {
    List<Widget> filas = [];
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().miTablero.numFilas; i++) {
      filas.add(buildFilaCasillas(i, onTap));
    }
    return filas;
  }

  Future<void> _handleTap(int i, int j) async {
    // Mostrar mina
    setState(() {
      Juego().minasColocadasPorMi.add(Offset(i.toDouble(), j.toDouble()));
    });

    if(Juego().modalidadPartida == "INDIVIDUAL") {
      await colocarMina(i, j);
    } else {
      await colocarMinaMulti(i, j);
    }
  }



/**************************************************************************************************************/
/*                                                                                                            */
/*                                              PARTIDA VS IA                                                 */
/*                                                                                                            */
/// ***********************************************************************************************************

  // Habilidad MINA
  Future<List<bool>> colocarMina(int i, int j) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlColocarMina),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': AuthProvider().name,
        'i': i,
        'j': j,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var coordenadas = data['minaColocada'];
      var turnosIA = data['turnosIA'];
      bool fin = data['finPartida'];
      bool acertado = false;
 
      // Procesar disparo de la IA.
      for (var elemento in turnosIA) {
        acertado = acertado || procesarTurnoIA(elemento);
      }

      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Funcion que procesa el turno de la IA
  bool procesarTurnoIA(turnoIA) {
    var elemento = turnoIA;
    var disparo = elemento['disparoRealizado'];
    var iReal = disparo['i'];
    var jReal = disparo['j'];
    Offset disparoCoordenadas = Offset(iReal as double, jReal as double);
    bool finPartida = elemento['finPartida'];
    var estado = disparo['estado'];
    bool acertado = estado == 'Tocado' || estado == 'Hundido';
    bool hundido = estado == 'Hundido';

    if(finPartida) {  //Si finaliza la partida
      final snackBar = SnackBar(
        content: Text(
          '¡Ganador: ${Juego().getGanador()}!',
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Juego().reiniciarPartida();
      Navigator.pushNamed(context, '/Principal');
    }

    if (acertado) {
      // Actualizar disparos acertados del rival.
      setState(() {
        Juego().disparosAcertadosRival.add(disparoCoordenadas);
      });
    }
    else {
      // Actualizar disparos fallados del rival.
      setState(() {
        Juego().disparosFalladosRival.add(disparoCoordenadas);
      });
    }

    if (hundido) {
      // Actualizar barcos hundidos del rival.
      setState(() {
        Juego().misBarcosRestantes--;
        if (elemento.containsKey('barcoCoordenadas')) {
          var barcoCoordenadas = elemento['barcoCoordenadas'];
          Barco barcoHundido = Juego().buscarBarcoHundidoDisparo(barcoCoordenadas);
          Juego().barcosHundidosPorRival.add(barcoHundido);
        }
      });
    }
    return acertado;
  }

/**************************************************************************************************************/
/*                                                                                                            */
/*                                              PARTIDA MULTI                                                 */
/*                                                                                                            */
/// ***********************************************************************************************************

  // Colocar mina multi
  Future<void> colocarMinaMulti(int i, int j) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlColocarMinaMulti),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': AuthProvider().name,
        'i': i,
        'j': j,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var coordenadas = data['minaColocada'];
      var turnos = data['turnos'];
      bool fin = data['finPartida'];
      bool acertado = false;

      if(fin) {
        final snackBar = SnackBar(
          content: Text(
            '¡Ganador: ${Juego().getGanador()}!',
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Juego().reiniciarPartida();
        Navigator.pushNamed(context, '/Principal');
      }
      
      // Procesamos el disparo rival en Defender.
    } else {
      throw Exception('Failed to load data');
    }
  }


}
