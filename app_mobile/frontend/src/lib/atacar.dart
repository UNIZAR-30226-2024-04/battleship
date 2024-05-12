import 'dart:async';
import 'dart:html';
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
        print(data);
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
                          
                          Juego().indiceHabilidadSeleccionadaEnTurno = i;
                          //print("HABILIDAD SELECCIONADA: ${Juego().habilidades[i].nombre}");

                          if(Juego().habilidades[i].nombre == 'misil') {
                            _handleTap(1, 1);
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
                              color: Juego().indiceHabilidadSeleccionadaEnTurno == i ? Colors.black.withOpacity(0.5) : null,
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
            print(defender);
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

  /*
   * Construir tablero con los barcos del rival hundidos.
   */
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
    // Comprobar si ya se ha disparado en esa casilla.
    if (Juego().disparosAcertadosPorMi.contains(Offset(i.toDouble(), j.toDouble())) || 
          Juego().disparosFalladosPorMi.contains(Offset(i.toDouble(), j.toDouble()))) {
      showErrorSnackBar(context, 'Ya has disparado en esa casilla, prueba en otra');
      return;
    }

    bool acertado = false;
    bool fin = false;

    // Si la partida es de tipo "INDIVIDUAL" (contra la IA)
    if(Juego().modalidadPartida == "INDIVIDUAL") {
      if (Juego().indiceHabilidadSeleccionadaEnTurno != -1) {
        if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'rafaga') {
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
          print("disparos pendientes: ");
          print(Juego().disparosPendientes);
          var result = await realizarDisparoRafaga(i, j, Juego().disparosPendientes);
          acertado = result[0];
          fin = result[1];
        }
        else if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'teledirigido') {
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
          var result = await realizarDisparoTeledirigido();
          //acertado = result[0];
          //fin = result[1];
        }
        else if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'recargado') {
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
          var result = await realizarDisparoTorpedo(i, j, false);
          acertado = result[0];
          fin = result[1];
        }
        else {
          showErrorSnackBar(context, 'Habilidad no válida');
        }
      }
      else {
        var result = await realizarDisparoIndividual(i, j);
        acertado = result[0];
        fin = result[1];
        print("disminuyo disparos pendientes");
      }
    }
    // Si la partida es de tipo "COMPETITIVA"
    else if(Juego().modalidadPartida == "COMPETITIVA") {
      var result = await realizarDisparoMulti(i, j);
        print("disminuyo disparos pendientes");
      acertado = result[0];
      fin = result[1];
    }
    // Si la partida es de tipo "AMISTOSA"
    else if (Juego().modalidadPartida == "AMISTOSA") {
      var result = await realizarDisparoMulti(i, j);
        print("disminuyo disparos pendientes");
      acertado = result[0];
      fin = result[1];
    }
    // Si la partida es de tipo "TORNEO"
    else if (Juego().modalidadPartida == "TORNEO") {
      var result = await realizarDisparoMulti(i, j);
        print("disminuyo disparos pendientes");
      acertado = result[0];
      fin = result[1];
    }
    // Si la partida es de un tipo que no existe
    else {
      showErrorSnackBar(context, 'Modalidad de juego no válida');
    }

    // Si la casilla señalada tiene un barco (acierta el disparo).
    if(acertado || Juego().disparosPendientes > 1) { // Si acertamos o quedan rafagas
      //print("ACERTADO");

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

      if (Juego().disparosPendientes == 0) {
        setState(() {
          defender = true;
          Juego().disparosPendientes = 1;
          Juego().misDisparosDesviadosArriba.clear();
          Juego().misDisparosDesviadosAbajo.clear();
          Juego().misDisparosDesviadosIzquierda.clear();
          Juego().misDisparosDesviadosDerecha.clear();
        });
      }
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
      var barcoCoordenadas = data['barcoCoordenadas'];

      bool fin = data['finPartida'];
      bool acertado = procesarDisparo(disparo, barcoCoordenadas);
  
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
 Future<void> realizarDisparoTeledirigido() async {
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
      var barcoCoordenadas = data['barcoCoordenadas'];
      bool fin = data['finPartida'];
      bool acertado = procesarDisparo(disparo, barcoCoordenadas);

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
    if (turnoRecarga) {
      response = await http.post(
        Uri.parse(serverRoute.urlDispararTorpedo),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${Juego().tokenSesion}',
        },
        body: jsonEncode(<String, dynamic>{
          'codigo': Juego().codigo,
          'nombreId': AuthProvider().name,
          'turnoRecarga': turnoRecarga,
        }),
      );
    }

    if (response.statusCode == 200) {
      if (turnoRecarga) {
        // Recargar el torpedo, perdemos turno
        return Future.value([false, false]);
      }
      var data = jsonDecode(response.body);
      //print(data);
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
      var disparos = data['disparosRealizados'];
      var barcoCoordenadas = data['barcoCoordenadas'];
      bool fin = data['finPartida'];
      bool acertado = false;
      for (var disparo in disparos) {
        acertado = acertado || procesarDisparo(disparo, barcoCoordenadas);
      }
 
      // Procesar disparo de la IA.
      for (var elemento in turnosIA) {
        acertado = procesarTurnoIA(elemento);
      }
      return Future.value([acertado, fin]);
    } 
    else {
      throw Exception('Failed to load data');
    }
  }  

// Habilidad SONAR
Future<List<bool>> usarSonar() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlUsarSonar),
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
      // Procesar barcos detectados por el sonar.
      var matriz = data['sonar'] as List<List<dynamic>>;
      // recorrer la matriz por filas y columnas
      for (int i = 0; i < matriz.length; i++) {
        for (int j = 0; j < matriz[i].length; j++) {
          switch(matriz[i][j]) {
            case 'Barco':
              // colocar la imagen de un barco en la casilla
              Juego().barcosDesveladosSonar.add(Offset(i.toDouble(), j.toDouble()));
              break;
            case 'Agua':
              // colocar la imagen de una cruz en la casilla
              Juego().disparosFalladosPorMi.add(Offset(i.toDouble(), j.toDouble()));
              break;
            case 'Mina':
              // colocar la imagen de una mina en la casilla
              Juego().minasColocadasPorRival.add(Offset(i.toDouble(), j.toDouble()));
              break;
          }
        }
      }
    return Future.value([false, false]);
    } else {
      throw Exception('Failed to load data');
    }
  }



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

      // TO DO: ACTUALMENTE ESTA MINA SE PONE EN EL TABLERO DEL RIVAL, DEBERÍA PONERSE EN EL PROPIO
      var coordenadas = data['minaColocada'];
      // Colocar la mina en la casilla.
      Juego().minasColocadasPorMi.add(Offset(coordenadas['i'].toDouble(), coordenadas['j'].toDouble()));
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
          Map<String, dynamic> barcoCoordenadas = elemento['barcoCoordenadas'];
          Barco barcoHundido = Juego().buscarBarcoHundidoDisparo(barcoCoordenadas);
          Juego().barcosHundidosPorRival.add(barcoHundido);
        }
      });
    }
    return acertado;
  }
    

/**************************************************************************************************************/
/*                                                                                                            */
/*                                              MOSTRAR MI DISPARO                                            */
/*                                                                                                            */
/**************************************************************************************************************/
// Funcion que procesa mi disparo
 bool procesarDisparo(disparo, barcoCoordenadas) {
    var iReal = disparo['i'];
    var jReal = disparo['j'];
    Offset disparoCoordenadas = Offset(iReal as double, jReal as double);
    print("CASILLA REAL DE DISPARO: " + disparoCoordenadas.toString());
    var estado = disparo['estado'];
    bool acertado = estado == 'Tocado' || estado == 'Hundido';
    bool hundido = estado == 'Hundido';

    // Comprobar si el disparo ha sido desviado.
    if (disparoCoordenadas != Offset(iReal.toDouble(), jReal.toDouble())) {
      if (disparoCoordenadas.dx > iReal.toDouble()) {
        Juego().misDisparosDesviadosAbajo.add(Offset(iReal.toDouble(), jReal.toDouble()));
      }
      else if (disparoCoordenadas.dx < iReal.toDouble()) {
        Juego().misDisparosDesviadosArriba.add(Offset(iReal.toDouble(), jReal.toDouble()));
      }
      else if (disparoCoordenadas.dy > jReal.toDouble()) {
        Juego().misDisparosDesviadosDerecha.add(Offset(iReal.toDouble(), jReal.toDouble()));
      }
      else if (disparoCoordenadas.dy < jReal.toDouble()) {
        Juego().misDisparosDesviadosIzquierda.add(Offset(iReal.toDouble(), jReal.toDouble()));
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
      setState(() {
        Juego().disparosFalladosPorMi.add(disparoCoordenadas);
      });
    }

    if (hundido) {
      // Actualizar barcos hundidos.
      setState(() {
        Juego().barcosRestantesRival--;
        if (barcoCoordenadas != null) {
          Barco barcoHundido = Juego().buscarBarcoHundidoDisparo(barcoCoordenadas);
          Juego().barcosHundidosPorMi.add(barcoHundido);
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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var disparo = data['disparoRealizado'];
      var barcoCoordenadas = data['barcoCoordenadas'];
      bool fin = data['finPartida'];
      bool acertado = procesarDisparo(disparo, barcoCoordenadas);
  
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
      print("RESPUESTA EN ATAQUE: ");
      print(data);
      bool fin = data['finPartida'];
      bool acertado = false;
      String evento = data['eventoOcurrido'];
      bool desviado = false;

      // Comprobar si en el siguiente turno hay niebla.
      if (evento == 'Niebla') {
        print("El ultimo disparo no ha llegado a su destino por la niebla.");
        setState(() {
          Juego().hayNiebla = true;
          casillaNiebla = Offset(i.toDouble(), j.toDouble());
        });
        acertado = false;
      }
      else {
        print("ENTRO EN NO HAY NIEBLA");
        var disparo = data['disparoRealizado'];
        var iReal = disparo['i'];
        var jReal = disparo['j'];
        Offset disparoCoordenadas = Offset(iReal as double, jReal as double);
        print("CASILLA REAL DE DISPARO: " + disparoCoordenadas.toString());
        var estado = disparo['estado'];
        acertado = estado == 'Tocado' || estado == 'Hundido';
        bool hundido = estado == 'Hundido';

        // Comprobar si el disparo ha sido desviado.
        if (disparoCoordenadas != Offset(i.toDouble(), j.toDouble())) {
          desviado = true;  
          if (disparoCoordenadas.dx > i.toDouble()) {
            setState(() {
              Juego().misDisparosDesviadosAbajo.add(Offset(i.toDouble(), j.toDouble()));
            });
          }
          else if (disparoCoordenadas.dx < i.toDouble()) {
            setState(() {
              Juego().misDisparosDesviadosArriba.add(Offset(i.toDouble(), j.toDouble()));
            });
          }
          else if (disparoCoordenadas.dy > j.toDouble()) {
            setState(() {
              Juego().misDisparosDesviadosDerecha.add(Offset(i.toDouble(), j.toDouble()));
            });
          }
          else if (disparoCoordenadas.dy < j.toDouble()) {
            setState(() {
              Juego().misDisparosDesviadosIzquierda.add(Offset(i.toDouble(), j.toDouble()));
            });
          }
        }
        
        if((desviado && !Juego().disparosFalladosPorMi.contains(Offset(i.toDouble(), j.toDouble())) 
          && !Juego().disparosAcertadosPorMi.contains(Offset(i.toDouble(), j.toDouble()))) || !desviado) {
          if (acertado) {
            // Actualizar disparos acertados.
            setState(() {
              Juego().disparosAcertadosPorMi.add(disparoCoordenadas);
            });
          }
          else {
            // Actualizar disparos fallados.
            setState(() {
              Juego().disparosFalladosPorMi.add(disparoCoordenadas);
            });
          }
        }

        if (hundido) {
          // Actualizar barcos hundidos.
          setState(() {
            Juego().barcosRestantesRival--;
            if (data.containsKey('barcoCoordenadas')) {
              Map<String, dynamic> barcoCoordenadas = data['barcoCoordenadas'];
              Barco barcoHundido = Juego().buscarBarcoHundidoDisparo(barcoCoordenadas);
              Juego().barcosHundidosPorMi.add(barcoHundido);
            }
          });
        }
      }

      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
/**************************************************************************************************************/
/*                                                                                                            */
/*                                  HABILIDADES MULTIPLAYER                                                   */
/*                                                                                                            */
/**************************************************************************************************************/

