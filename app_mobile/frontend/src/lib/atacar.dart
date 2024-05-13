import 'dart:async';
import 'package:battleship/authProvider.dart';
import 'package:battleship/barco.dart';
import 'package:battleship/botones.dart';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';

class Atacar extends StatefulWidget {
  const Atacar({super.key});

  @override
  _AtacarState createState() => _AtacarState();
}
//
class _AtacarState extends State<Atacar> {
  ServerRoute serverRoute = ServerRoute();
  bool defender = false;
  Offset casillaNiebla = Offset(-1, -1);

  @override
  void initState() {
    super.initState();
    defender = false;

    Juego().socket.emit('entrarSala', Juego().codigo);

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
            buildHeader(context, ponerPerfil: false),
            const SizedBox(height: 20),
            _construirBarcosRestantes(),
            _construirTableroConBarcosAtacable(),
            _construirHabilidades(),
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

  /*
   * Construir widget con las habilidades disponibles del jugador.
   */
Widget _construirHabilidades() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < Juego().habilidades.length; i++)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        // Seleccionar habilidad.
                        onPressed: () {
                          if (Juego().indiceHabilidadSeleccionadaEnTurno != -1) {
                            showErrorSnackBar(context, 'Ya has seleccionado una habilidad para este turno');
                            return;
                          }
                          
                          if(Juego().numHabilidadesUtilizadas > 2) {  // 0, 1, 2
                            showErrorSnackBar(context, 'Ya has utilizado todas tus habilidades para la partida');
                            return;
                          }
                          else {
                            Juego().numHabilidadesUtilizadas ++;
                          }

                          setState(() {
                            Juego().indiceHabilidadSeleccionadaEnTurno = i;
                          });

                          if(Juego().habilidades[i].nombre == 'teledirigido') {
                            _handleTap(0, 0);
                          }

                          if(Juego().habilidades[i].nombre == 'torpedo') {
                            _handleTap(0, 0);
                            Navigator.pushNamed(context, '/Defender');
                          }

                          if(Juego().habilidades[i].nombre == 'mina') {
                            Navigator.pushNamed(context, '/Mina');   
                          } 
                        },

                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),

                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              Juego().habilidades[i].getImagePath(),
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                              color: Juego().indiceHabilidadSeleccionadaEnTurno == i ? Colors.black.withOpacity(0.7) : null,
                              colorBlendMode: Juego().indiceHabilidadSeleccionadaEnTurno == i ? BlendMode.darken : null,
                            ),
                          ],
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

  /*
   * Construir tablero con los barcos hundidos.
   */
  List<Widget> buildTableroClicable(Function(int, int) onTap) {
    List<Widget> filas = [];
    filas.add(buildTableroConBarcosHundidos(onTap));
    return filas;
  }

  /*
   * Construir fila con las coordenadas de las columnas.
   */
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
  
  /*
   * Construir fila con las casillas del tablero.
   */
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
      if (Juego().disparosFalladosPorMi.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        // Si fallo el disparo, coloco una cruz roja en la casilla.
        imagePath = 'images/redCross.png';
      } 
      else if (Juego().disparosAcertadosPorMi.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        // Si acierto el disparo, coloco una explosión en la casilla.
        imagePath = 'images/explosion.png';
      }
      else if (Juego().misDisparosDesviadosArriba.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        // Si el disparo ha sido desviado hacia arriba, coloco una flecha hacia arriba.
        imagePath = 'images/arriba.png';
      }
      else if (Juego().misDisparosDesviadosAbajo.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        // Si el disparo ha sido desviado hacia abajo, coloco una flecha hacia abajo.
        imagePath = 'images/abajo.png';
      }
      else if (Juego().misDisparosDesviadosIzquierda.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        // Si el disparo ha sido desviado hacia la izquierda, coloco una flecha hacia la izquierda.
        imagePath = 'images/izquierda.png';
      }
      else if (Juego().misDisparosDesviadosDerecha.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        // Si el disparo ha sido desviado hacia la derecha, coloco una flecha hacia la derecha.
        imagePath = 'images/derecha.png';
      }
      else if (casillaNiebla == Offset(rowIndex.toDouble(), j.toDouble())){
        // Si hay niebla, coloco una interrogación en la casilla.
        imagePath = 'images/question.png';
        Juego().hayNiebla = false;
      }
      else if (Juego().minasColocadasPorRival.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        // Si hay una mina en la casilla, coloco una mina en la casilla.
        imagePath = 'images/mineSymbol.png';
      }
      else if (Juego().barcosDesveladosSonar.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        // Si hay un barco en la casilla, coloco una imagen de barco en la casilla.
        imagePath = 'images/shipSymbol.png';
      }

      casillas.add(
        GestureDetector(
          onTap: () async {
            await onTap(rowIndex, j);
            if(defender) {
              defender = false;
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushNamed(context, '/Defender');
              });
            }
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
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildTablero(onTap),
        ),
        for (var barco in Juego().barcosHundidosPorMi)  
          Positioned(
            top: barco.barcoPosition.dx * Juego().miTablero.casillaSize,
            left: barco.barcoPosition.dy * Juego().miTablero.casillaSize,
            // Coloco la imagen del barco hundido
            child: Image.asset(
              barco.getImagePath(),
              width: barco.getWidth(Juego().miTablero.casillaSize),
              height: barco.getHeight(Juego().miTablero.casillaSize),
              fit: BoxFit.fill,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
      ],
    );
  }

  /*
   * Construir tablero con las casillas clicables.
   */
  List<Widget> buildTablero(Function(int, int) onTap) {
    List<Widget> filas = [];
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().miTablero.numFilas; i++) {
      filas.add(buildFilaCasillas(i, onTap));
    }
    return filas;
  }

  /*
   * Manejar el disparo sobre una casilla del tablero.
   */
  Future<void> _handleTap(int i, int j) async {
    Juego().misDisparosDesviadosArriba.clear();
    Juego().misDisparosDesviadosAbajo.clear();
    Juego().misDisparosDesviadosIzquierda.clear();
    Juego().misDisparosDesviadosDerecha.clear();
    print("INDICE HABILIDAD SELECCIONADA: " + Juego().indiceHabilidadSeleccionadaEnTurno.toString());
    // Comprobar si ya se ha disparado en esa casilla.
    if (Juego().disparosAcertadosPorMi.contains(Offset(i.toDouble(), j.toDouble())) || 
          Juego().disparosFalladosPorMi.contains(Offset(i.toDouble(), j.toDouble()))) {
      showErrorSnackBar(context, 'Ya has disparado en esa casilla, prueba en otra');
      return;
    }

    bool acertado = false;
    bool fin = false;

    // Si la partida es de tipo "INDIVIDUAL" (contra la IA)
    if (Juego().indiceHabilidadSeleccionadaEnTurno != -1) {
      if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'rafaga') {
        Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
        var result;
        if(Juego().modalidadPartida == "INDIVIDUAL") {
          result = await realizarDisparoRafaga(i, j, Juego().disparosPendientes);
        } else {
          result = await realizarDisparoRafagaMulti(i, j, Juego().disparosPendientes);
        }
        acertado = result[0];
        fin = result[1];
      }
      else if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'teledirigido') {
        Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
        var result;
        if(Juego().modalidadPartida == "INDIVIDUAL") {
          result = await realizarDisparoTeledirigido();
        } else {
          result = await realizarDisparoTeledirigidoMulti();
        }
        acertado = result[0];
        fin = result[1];
      }
      else if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'torpedo') {
        // Si el estado de la habilidad es "recargando", no dispara.
        if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].estado == 'recargando') {
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
          var result;
          if(Juego().modalidadPartida == "INDIVIDUAL") {
            result = await realizarDisparoTorpedo(0, 0, true);
          } else {
            result = await realizarDisparoTorpedoMulti(0, 0, true);
          }
          acertado = result[0];
          fin = result[1];
        }
        else {
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
          var result;
          if(Juego().modalidadPartida == "INDIVIDUAL") {
            result = await realizarDisparoTorpedo(i, j, false);
          } else {
            result = await realizarDisparoTorpedoMulti(i, j, false);
          }
          acertado = result[0];
          fin = result[1];
        }
      }
      else if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'sonar') {
        Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
        var result;
        if(Juego().modalidadPartida == "INDIVIDUAL") {
          result = await usarSonar(i, j);
        } else {
          result = await usarSonarMulti(i, j);
        }
        acertado = result[0];
        fin = result[1];
      }
      else {
        showErrorSnackBar(context, 'Habilidad no válida');
      }
    }

    // Si la casilla señalada tiene un barco (acierta el disparo).
    if(acertado || Juego().disparosPendientes > 1) { // Si acertamos o quedan rafagas
      if(fin) { //Si finaliza la partida
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
    }
    if (!acertado) { // Si falla el disparo
      setState(() {
        Juego().disparosPendientes --;
      });
    }

    if (Juego().disparosPendientes <= 0) {
      setState(() {
        defender = true;
        Juego().disparosPendientes = 1;
      });
      }
    }

/**************************************************************************************************************/
/*                                                                                                            */
/*                                  HABILIDADES SINGLE PLAYER                                                 */
/*                                                                                                            */
/**************************************************************************************************************/

// Habilidad: RÁFAGA
 Future<List<bool>> realizarDisparoRafaga(int i, int j, int restantes) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlDispararRafaga),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': AuthProvider().name,
        'i': i,
        'j': j,
        'misilesRafagaRestantes': restantes,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var disparo = data['disparoRealizado'];
      bool fin = data['finPartida'];
      bool acertado = false;
      var barcoCoordenadas = data['barcoCoordenadas'];
      acertado = procesarDisparo(disparo, [barcoCoordenadas]);
  
      // Procesar disparo de la IA.
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
      for (var elemento in turnosIA) {
        acertado = procesarTurnoIA(elemento);
      }

      return Future.value([acertado, fin]);
    }
    else {
      throw Exception('Failed to load data');
    }
  }

// Habilidad: MISIL TeleDirigido
  Future<List<bool>> realizarDisparoTeledirigido() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlDispararTeledirigido),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': AuthProvider().name,
      }),
    );


    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var disparo = data['disparoRealizado'];
      bool fin = data['finPartida'];
      bool acertado = false;
      var barcoCoordenadas = data['barcoCoordenadas'];
      acertado = procesarDisparo(disparo, [barcoCoordenadas]);

      // Procesar disparo de la IA.
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
      for (var elemento in turnosIA) {
        acertado = procesarTurnoIA(elemento);
      }
      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
    }
  }

// Habilidad: TORPEDO
  Future<List<bool>> realizarDisparoTorpedo(int i, int j, bool turnoRecarga) async {
    var response;
    response = await http.post(
      Uri.parse(serverRoute.urlDispararTorpedo),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': AuthProvider().name,
        'i': i,
        'j': j,
        'turnoRecarga': turnoRecarga,
      }),
    );

    if (response.statusCode == 200) {
      if (turnoRecarga) {
        // Recargar el torpedo, perdemos turno
        return Future.value([false, false]);
      }
      var data = jsonDecode(response.body);
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
      var disparos = data['disparosRealizados'];
      var barcoCoordenadas = data['barcoCoordenadas'];
      bool fin = data['finPartida'];
      bool acertado = false;
      int numAcertados = 0;

      for (var disparo in disparos) {
        if (procesarDisparo(disparo, barcoCoordenadas)) {
          numAcertados++;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
 
      // Procesar disparo de la IA.
      for (var elemento in turnosIA) {
        procesarTurnoIA(elemento);
      }

      setState(() {
        acertado = numAcertados > 0;
      });

      return Future.value([acertado, fin]);
    } 
    else {
      throw Exception('Failed to load data');
    }
  }  

// Habilidad SONAR
Future<List<bool>> usarSonar(int i, int j) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlUsarSonar),
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
      // Procesar barcos detectados por el sonar.
      var matriz = data['sonar'];
      // recorrer la matriz por filas y columnas
      for (int l = 0; l < matriz.length; l++) {
        for (int k = 0; k < matriz[l].length; k++) {
          switch(matriz[l][k]) {
            case 'Barco':
              // colocar la imagen de un barco en la casilla
              Juego().barcosDesveladosSonar.add(Offset((i+l-1).toDouble(), (j+k-1).toDouble()));
              break;
            case 'Agua':
              // No marcamos nada
              break;
            case 'Mina':
              // colocar la imagen de una mina en la casilla
              Juego().minasColocadasPorRival.add(Offset((i+l-1).toDouble(), (j+k-1).toDouble()));
              break;
          }
        }
      }
    return Future.value([false, false]);
    } else {
      throw Exception('Failed to load data');
    }
  }

/**************************************************************************************************************/
/*                                                                                                            */
/*                                                 TURNO IA                                                   */
/*                                                                                                            */
/**************************************************************************************************************/
// Funcion que procesa el turno de la IA
  bool procesarTurnoIA(turnoIA) {
    var elemento = turnoIA;
    var disparo = elemento['disparoRealizado'];
    var iReal = disparo['i'];
    var jReal = disparo['j'];
    Offset disparoCoordenadas = Offset(iReal as double, jReal as double);
    print("CASILLA REAL DE DISPARO: " + disparoCoordenadas.toString());
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

    var disparosRespuestaMina = elemento['disparosRespuestaMina'];
    var barcosHundidosRespuestaMina = elemento['barcosHundidosRespuestaMina'];

    // Procesar disparos de respuesta a minas.
    if (disparosRespuestaMina != null && disparosRespuestaMina.isNotEmpty) {
      print("LA IA HA REALIZADO DISPAROS EN MINA: ");
      print("DISPAROS RESPUESTA AL EXPLOTAR MINA: " + disparosRespuestaMina.toString());
      for (var disparoMina in disparosRespuestaMina) {
        procesarDisparo(disparoMina, [barcosHundidosRespuestaMina]);
      }
    }

    return acertado;
  }
    

/**************************************************************************************************************/
/*                                                                                                            */
/*                                              MOSTRAR MI DISPARO                                            */
/*                                                                                                            */
/**************************************************************************************************************/
// Funcion que procesa mi disparo
 bool procesarDisparo(disparo, barcosCoordenadas) {
    print("DISPARO: ");
    var iReal = disparo['i'];
    var jReal = disparo['j'];
    Offset disparoCoordenadas = Offset(iReal as double, jReal as double);
    var estado = disparo['estado'];
    bool acertado = estado == 'Tocado' || estado == 'Hundido';
    bool hundido = estado == 'Hundido';

    // Comprobar si el disparo ha sido desviado.
    if (disparoCoordenadas != Offset(iReal.toDouble(), jReal.toDouble())) {
      if (disparoCoordenadas.dx > iReal.toDouble()) {
        setState(() {
          Juego().misDisparosDesviadosAbajo.add(Offset(iReal.toDouble(), jReal.toDouble()));
        });
      }
      else if (disparoCoordenadas.dx < iReal.toDouble()) {
        setState(() {
          Juego().misDisparosDesviadosArriba.add(Offset(iReal.toDouble(), jReal.toDouble()));
        });
      }
      else if (disparoCoordenadas.dy > jReal.toDouble()) {
        setState(() {
          Juego().misDisparosDesviadosDerecha.add(Offset(iReal.toDouble(), jReal.toDouble()));
        });
      }
      else if (disparoCoordenadas.dy < jReal.toDouble()) {
        setState(() {
          Juego().misDisparosDesviadosIzquierda.add(Offset(iReal.toDouble(), jReal.toDouble()));
        });
      }
    }

    if (acertado) {
      // Actualizar disparos acertados.
      setState(() {
        Juego().disparosAcertadosPorMi.add(disparoCoordenadas);
      });
    }
    else {
      // Actualizar disparos fallados.
      print("DISPARO FALLADO: " + disparoCoordenadas.toString());
      setState(() {
        Juego().disparosFalladosPorMi.add(disparoCoordenadas);
      });
    }

    if (hundido) {
      // Actualizar barcos hundidos.
      setState(() {
        Juego().barcosRestantesRival--;
        if (barcosCoordenadas != null && barcosCoordenadas.isNotEmpty) {
          // Tomar todos los barcos hundidos
          for (var barcoCoordenadas in barcosCoordenadas) {
            Barco barcoHundido = Juego().buscarBarcoHundidoDisparo(barcoCoordenadas);
            Juego().barcosHundidosPorMi.add(barcoHundido);
          }
        }
      });
    }
    return acertado;
 }

/**************************************************************************************************************/
/*                                                                                                            */
/*                                              PARTIDA VS IA                                                 */
/*                                                                                                            */
/**************************************************************************************************************/

/*
 * Realizar disparo contra la IA.
 */
 Future<List<bool>> realizarDisparoIndividual(int i, int j) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlDisparar),
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

    print("Respuesta de mi disparo: " + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var evento = data['eventoOcurrido'];
      bool fin = data['finPartida'];
      bool acertado = false;
      if (evento == 'Niebla') {
        print("El ultimo disparo no ha llegado a su destino por la niebla.");
        setState(() {
          Juego().hayNiebla = true;
          casillaNiebla = Offset(i.toDouble(), j.toDouble());
        });
        return Future.value([false, false]);
      }
      else {
        var disparo = data['disparoRealizado'];
        var barcoCoordenadas = data['barcoCoordenadas'];
        acertado = procesarDisparo(disparo, [barcoCoordenadas]);
    
        print("Disparo IA: ");
        // Procesar disparo de la IA.
        var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
        for (var elemento in turnosIA) {  
            acertado = procesarTurnoIA(elemento);
        }
      }

      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
    }
  }


/**************************************************************************************************************/
/*                                                                                                            */
/*                                              PARTIDA MULTI                                                 */
/*                                                                                                            */
/**************************************************************************************************************/

// Realizar disparo en una partida multijugador.
  Future<List<bool>> realizarDisparoMulti(int i, int j) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlDispararMulti),
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
      bool fin = data['finPartida'];
      bool acertado = false;
      String evento = data['eventoOcurrido'];

      // Comprobar si en el siguiente turno hay niebla.
      if (evento == 'Niebla') {
        print("El ultimo disparo no ha llegado a su destino por la niebla.");
        setState(() {
          Juego().hayNiebla = true;
          casillaNiebla = Offset(i.toDouble(), j.toDouble());
        });
        acertado = false;
        fin = false;
      }
      else {
        print("ENTRO EN NO HAY NIEBLA");
        var disparo = data['disparoRealizado'];
        var barcoCoordenadas = data['barcoCoordenadas'];
        acertado = procesarDisparo(disparo, [barcoCoordenadas]);
      }

      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
    }
  }
  
/**************************************************************************************************************/
/*                                                                                                            */
/*                                  HABILIDADES MULTIPLAYER                                                   */
/*                                                                                                            */
/**************************************************************************************************************/

  // Rafaga Multi
  Future<List<bool>> realizarDisparoRafagaMulti(int i, int j, int restantes) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlDispararRafagaMulti),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': AuthProvider().name,
        'i': i,
        'j': j,
        'misilesRafagaRestantes': restantes,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var disparo = data['disparoRealizado'];
      bool fin = data['finPartida'];
      bool acertado = false;
      var barcoCoordenadas = data['barcoCoordenadas'];
      acertado = procesarDisparo(disparo, [barcoCoordenadas]);
      return Future.value([acertado, fin]);
    }
    else {
      throw Exception('Failed to load data');
    }
  }

  // Teledirigido Multi
  Future<List<bool>> realizarDisparoTeledirigidoMulti() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlDispararTeledirigidoMulti),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': AuthProvider().name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var disparo = data['disparoRealizado'];
      bool fin = data['finPartida'];
      bool acertado = false;
      var barcoCoordenadas = data['barcoCoordenadas'];
      acertado = procesarDisparo(disparo, [barcoCoordenadas]);
      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Torpedo Multi
  Future<List<bool>> realizarDisparoTorpedoMulti(int i, int j, bool turnoRecarga) async {
    var response;
    response = await http.post(
      Uri.parse(serverRoute.urlDispararTorpedoMulti),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': AuthProvider().name,
        'i': i,
        'j': j,
        'turnoRecarga': turnoRecarga,
      }),
    );

    if (response.statusCode == 200) {
      if (turnoRecarga) {
        // Recargar el torpedo, perdemos turno
        return Future.value([false, false]);
      }
      var data = jsonDecode(response.body);
      var disparos = data['disparosRealizados'];
      var barcoCoordenadas = data['barcoCoordenadas'];
      bool fin = data['finPartida'];
      bool acertado = false;
      int numAcertados = 0;

      for (var disparo in disparos) {
        if (procesarDisparo(disparo, barcoCoordenadas)) {
          numAcertados++;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }

      return Future.value([numAcertados > 0, fin]);
    } 
    else {
      throw Exception('Failed to load data');
    }
  }

  // Sonar Multi
  Future<List<bool>> usarSonarMulti(int i, int j) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlUsarSonarMulti),
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
      // Procesar barcos detectados por el sonar.
      var matriz = data['sonar'];
      // recorrer la matriz por filas y columnas
      for (int l = 0; l < matriz.length; l++) {
        for (int k = 0; k < matriz[l].length; k++) {
          switch(matriz[l][k]) {
            case 'Barco':
              // colocar la imagen de un barco en la casilla
              Juego().barcosDesveladosSonar.add(Offset((i+l-1).toDouble(), (j+k-1).toDouble()));
              break;
            case 'Agua':
              // No marcamos nada
              break;
            case 'Mina':
              // colocar la imagen de una mina en la casilla
              Juego().minasColocadasPorRival.add(Offset((i+l-1).toDouble(), (j+k-1).toDouble()));
              break;
          }
        }
      }
    return Future.value([false, false]);
    } else {
      throw Exception('Failed to load data');
    }
  }

}