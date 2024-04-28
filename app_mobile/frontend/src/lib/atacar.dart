import 'package:battleship/authProvider.dart';
import 'package:battleship/barco.dart';
import 'package:battleship/botones.dart';
import 'package:battleship/destino.dart';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'defender.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';

class Atacar extends StatefulWidget {
  const Atacar({super.key});

  @override
  _AtacarState createState() => _AtacarState();
}

class _AtacarState extends State<Atacar> {
  ServerRoute serverRoute = ServerRoute();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)), // Espera un segundo para cargar el tablero.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Text('¡Tu turno!', style: TextStyle(color: Colors.white, fontSize: 28)),
              ),
            ),
          );
        } else {
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
                  FutureBuilder<Widget>(
                    future: _construirTableroConBarcosAtacable(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return AnimatedOpacity(
                          opacity: snapshot.data == null ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: snapshot.data,
                        );
                      }
                    },
                  ),
                  _construirHabilidades(),
                  const Spacer(),
                  buildActionButton(context, () {
                    Juego().abandonarPartida(context);
                    Juego().reiniciarPartida();
                    Navigator.pushNamed(context, '/Principal');
                  }, "Abandonar partida"),
                  const Spacer(),
                ],
              ),
            ),
          );
        }
      },
    );
  }


  Future<Widget> _construirTableroConBarcosAtacable() async {
    return SizedBox(
      width: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
      height: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: await buildTableroClicable(_handleTap),
      ),
    );
  }


  Widget _construirBarcosRestantes() {
    print("TURNO EN ATACAR: ${Juego().turno}");
    List<Barco> barcosRestantes = Juego().obtenerBarcosRestantes();
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
              for (int i = 0; i < barcosRestantes.length; i++)  
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        'images/${barcosRestantes[i].nombre}.png', 
                        width: 50, 
                        height: 50,
                      ),
                    ),
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


  Future<List<Widget>> buildTableroClicable(Function(int, int) onTap) async {
    List<Widget> filas = [];
    filas.add(await buildTableroConBarcosHundidos(onTap));
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
      
  Future<Widget> buildFilaCasillas(int rowIndex, Function(int, int) onTap) async {
    List<Widget> casillas = [];
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
      String imagePath = 'images/dot.png';
      if (Juego().disparosFalladosJugador.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        imagePath = 'images/redCross.png';
      } else if (Juego().disparosAcertadosJugador.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        imagePath = 'images/explosion.png';
      }

      casillas.add(
        GestureDetector(
          onTap: () {
            onTap(rowIndex, j);
          },
          child: Container(
            width: Juego().tablero_oponente.casillaSize,
            height: Juego().tablero_oponente.casillaSize,
            decoration: BoxDecoration(
              color: const Color.fromARGB(128, 116, 181, 213),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
      );
    }

    return Row(children: casillas);
  }

  Future<Widget> buildTableroConBarcosHundidos(Function(int, int) onTap) async {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: await buildTablero(onTap),
        ),
        for (var barco in Juego().barcosHundidosPorJugador)
          Positioned(
            top: barco.barcoPosition.dx * Juego().tablero_jugador.casillaSize,
            left: barco.barcoPosition.dy * Juego().tablero_jugador.casillaSize,
            child: Image.asset(
              barco.getImagePath(),
              width: barco.getWidth(Juego().tablero_jugador.casillaSize),
              height: barco.getHeight(Juego().tablero_jugador.casillaSize),
              fit: BoxFit.fill,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
      ],
    );
  }

  Barco buscarBarcoHundidoDisparo(Map<String, dynamic> datosJuego) {
    if (datosJuego.containsKey('barcoCoordenadas')) {
      Map<String, dynamic> barcoCoordenadas = datosJuego['barcoCoordenadas'];
      List<dynamic> coordenadas = barcoCoordenadas['coordenadas'];
      String tipo = barcoCoordenadas['tipo'];

      print('Tipo de barco: $tipo');
      print('coordenadas: $coordenadas');

      List<Offset> casillasBarco = [];
      for (var coordenada in coordenadas) {
        double i = coordenada['i'].toDouble();
        double j = coordenada['j'].toDouble();
        Offset offset = Offset(i, j);
        casillasBarco.add(offset);
      }

      String nombre = tipo;
      Offset barcoPos = casillasBarco[0];
      int long = casillasBarco.length;
      bool rotado = casillasBarco[0].dy == casillasBarco[1].dy ? true : false;
      bool hundido = true;
      Barco barcoHundido = Barco(nombre, barcoPos, long, rotado, hundido);
      barcoHundido.showInfo();
      return barcoHundido;
    }

    return Barco('', const Offset(0, 0), 0, false, false);
  }

  Future<List<Widget>> buildTablero(Function(int, int) onTap) async {
    List<Widget> filas = [];
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().tablero_jugador.numFilas; i++) {
      filas.add(await buildFilaCasillas(i, onTap));
    }
    return filas;
  }

  Future<void> _handleTap(int i, int j) async {
    // Comprobar si ya se ha disparado en esa casilla.
    if (Juego().disparosAcertadosJugador.contains(Offset(i.toDouble(), j.toDouble())) || 
          Juego().disparosFalladosJugador.contains(Offset(i.toDouble(), j.toDouble()))) {
      showErrorSnackBar(context, 'Ya has disparado en esa casilla, prueba en otra');
      return;
    }

    bool acertado = false;
    bool fin = false;

    if(Juego().modalidadPartida == "INDIVIDUAL") {
      var respuestaFuture = realizarDisparoIndividual(i, j);
      Juego().disparosPendientes--;
      respuestaFuture.then((result) {
        acertado = result[0];
        fin = result[1];
      });
    }
    else if(Juego().modalidadPartida == "COMPETITIVA") {
      var respuestaFuture = realizarDisparoMulti(i, j);
      Juego().disparosPendientes--;
      respuestaFuture.then((result) {
        acertado = result[0];
        fin = result[1];
      });
    }
    else if (Juego().modalidadPartida == "AMISTOSA") {
      var respuestaFuture = realizarDisparoMulti(i, j);
      Juego().disparosPendientes--;
      respuestaFuture.then((result) {
        acertado = result[0];
        fin = result[1];
      });
    }
    else if (Juego().modalidadPartida == "TORNEO") {
      var respuestaFuture = realizarDisparoMulti(i, j);
      Juego().disparosPendientes--;
      respuestaFuture.then((result) {
        acertado = result[0];
        fin = result[1];
      });
    }
    else {
      showErrorSnackBar(context, 'Modalidad de juego no válida');
    }

    // Si la casilla tiene un barco.
    if(acertado) {
      Juego().disparosPendientes ++;

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
    }

    if (Juego().disparosPendientes == 0) {
      Juego().disparosPendientes = 1;
      Juego().habilidadSeleccionadaEnTurno = false;
      Juego().cambiarTurno();
      DestinoManager.setDestino(const Defender());
      Navigator.pushNamed(context, '/Defender');
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// PARTIDA VS IA  /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
      print("DISPARO ME DEVUELVE: ");
      var data = jsonDecode(response.body);
      print(data);
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
      print("TURNOS IA: $turnosIA");
      var disparo = data['disparoRealizado'];
      var estado = disparo['estado'];
      bool acertado = estado == 'Tocado' || estado == 'Hundido';
      bool fin = data['finPartida'];
      bool hundido = estado == 'Hundido';
      String nombreBarcoHundido = "";

      // Offset con las coordenadas del disparo.
      Offset disparoCoordenadas = Offset(i as double, j as double);

      if (acertado) {
        setState(() {
          Juego().disparosAcertadosJugador.add(disparoCoordenadas);
          print("DISPAROS ACERTADOS: ");
          print(Juego().disparosAcertadosJugador);
        });
      } else {
        setState(() {
          Juego().disparosFalladosJugador.add(disparoCoordenadas);
          print("DISPAROS FALLADOS: ");
          print(Juego().disparosFalladosJugador);
        });
      }

      if (hundido) {
        setState(() {
        Juego().decrementarBarcosRestantesOponente();
        nombreBarcoHundido = data['barcoCoordenadas']['tipo'];
        print("NOMBRE DEL BARCO HUNDIDO: $nombreBarcoHundido");
        Barco barcoHundido = buscarBarcoHundidoDisparo(data);
        Juego().barcosHundidosPorJugador.add(barcoHundido);
        print("BARCOS HUNDIDOS POR JUGADOR: ");
        for (var barco in Juego().barcosHundidosPorJugador) {
          barco.showInfo();
        }
        });
      }
  
      // Procesar disparo de la IA.
      bool finPartida = false;

      for (var elemento in turnosIA) {
        var disparo = elemento['disparoRealizado'];
        finPartida = elemento['finPartida'];
        estado = disparo['estado'];
        acertado = estado == 'Tocado' || estado == 'Hundido';
        hundido = estado == 'Hundido';

        if(finPartida) {
          print("¡Juego terminado!");
          print("¡Ganador: ${Juego().getGanador()}!");
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
          Juego().disparosAcertadosOponente.add(Offset(disparo['i'].toDouble(), disparo['j'].toDouble()));
        }
        else {
          Juego().disparosFalladosOponente.add(Offset(disparo['i'].toDouble(), disparo['j'].toDouble()));
        }

        if (hundido) {
          Barco barcoHundido = buscarBarcoHundidoDisparo(elemento);
          Juego().barcosHundidosPorOponente.add(barcoHundido);
          Juego().decrementarBarcosRestantesJugador();
        }
      }

      // Mostrar información de los barcos hundidos por la IA.
      print("BARCOS HUNDIDOS POR IA: ");
      print(Juego().barcosHundidosPorOponente);

      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// PARTIDA MULTI  /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
      print("DISPARO MULTI ME DEVUELVE: ");
      var data = jsonDecode(response.body);
      print(data);

      return Future.value([true, true]);
    } else {
      throw Exception('Failed to load data');
    }
  }
}