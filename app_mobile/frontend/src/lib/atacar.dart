import 'dart:async';
import 'dart:math';

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
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Atacar extends StatefulWidget {
  const Atacar({super.key});

  @override
  _AtacarState createState() => _AtacarState();
}

class _AtacarState extends State<Atacar> {
  ServerRoute serverRoute = ServerRoute();
  Completer completerAbandono = Completer();

  @override
  void initState() {
    super.initState();
    Juego().socket.on('abandono', (data) {
      print('Abandono: $data');
      if (!completerAbandono.isCompleted) {
        completerAbandono.complete();
      }
    }); 
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
      width: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
      height: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: await buildTableroClicable(_handleTap),
      ),
    );
  }


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
                        onPressed: () {
                          if (Juego().indiceHabilidadSeleccionadaEnTurno != -1) {
                            showErrorSnackBar(context, 'Ya has seleccionado una habilidad para este turno');
                            return;
                          }
                          Juego().indiceHabilidadSeleccionadaEnTurno = i;
                          print("HABILIDAD SELECCIONADA: ${Juego().habilidades[i].nombre}");
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

  Future<List<Widget>> buildTableroClicable(Function(int, int) onTap) async {
    List<Widget> filas = [];
    filas.add(await buildTableroConBarcosHundidos(onTap));
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
      
  Future<Widget> buildFilaCasillas(int rowIndex, Function(int, int) onTap) async {
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

    for (int j = 1; j < Juego().miTablero.numColumnas; j++) {
      String imagePath = 'images/dot.png';
      if (Juego().disparosFalladosPorMi.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        imagePath = 'images/redCross.png';
      } else if (Juego().disparosAcertadosPorMi.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        imagePath = 'images/explosion.png';
      }

      casillas.add(
        GestureDetector(
          onTap: () {
            onTap(rowIndex, j);
          },
          child: Container(
            width: Juego().miTablero.casillaSize,
            height: Juego().miTablero.casillaSize,
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
        for (var barco in Juego().barcosHundidosPorMi)
          Positioned(
            top: barco.barcoPosition.dx * Juego().miTablero.casillaSize,
            left: barco.barcoPosition.dy * Juego().miTablero.casillaSize,
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

  Barco buscarBarcoHundidoDisparo(Map<String, dynamic> datosJuego) {
    if (datosJuego.containsKey('barcoCoordenadas')) {
      Map<String, dynamic> barcoCoordenadas = datosJuego['barcoCoordenadas'];
      List<dynamic> coordenadas = barcoCoordenadas['coordenadas'];
      String tipo = barcoCoordenadas['tipo'];

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
      return barcoHundido;
    }

    return Barco('', const Offset(0, 0), 0, false, false);
  }

  Future<List<Widget>> buildTablero(Function(int, int) onTap) async {
    List<Widget> filas = [];
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().miTablero.numFilas; i++) {
      filas.add(await buildFilaCasillas(i, onTap));
    }
    return filas;
  }

  Future<void> _handleTap(int i, int j) async {
    // Comprobar si ya se ha disparado en esa casilla.
    if (Juego().disparosAcertadosPorMi.contains(Offset(i.toDouble(), j.toDouble())) || 
          Juego().disparosFalladosPorMi.contains(Offset(i.toDouble(), j.toDouble()))) {
      showErrorSnackBar(context, 'Ya has disparado en esa casilla, prueba en otra');
      return;
    }

    bool acertado = false;
    bool fin = false;

    if(Juego().modalidadPartida == "INDIVIDUAL") {
      if (Juego().indiceHabilidadSeleccionadaEnTurno != -1) {
        if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'rafaga') {
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
          var result = await realizarDisparoRafaga(i, j, Juego().disparosPendientes);
          acertado = result[0];
          fin = result[1];
        }
        else if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'misil') {
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].ejecutar();
          var result = await realizarDisparoMisil();
          //acertado = result[0];
          //fin = result[1];
        }
        else if (Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre == 'torpedo') {
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
        Juego().disparosPendientes--;
      }
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
      print("ACERTADO");
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

    else if (Juego().disparosPendientes == 0) {
      Juego().disparosPendientes = 1;
      DestinoManager.setDestino(const Defender());
      Navigator.pushNamed(context, '/Defender');
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////// HABILIDADES ///////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
      print(data);
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
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
          Juego().disparosAcertadosPorMi.add(disparoCoordenadas);
        });
      } else {
        setState(() {
          Juego().disparosFalladosPorMi.add(disparoCoordenadas);
        });
      }

      if (hundido) {
        setState(() {
          Juego().barcosRestantesRival--;
          nombreBarcoHundido = data['barcoCoordenadas']['tipo'];
          Barco barcoHundido = buscarBarcoHundidoDisparo(data);
          Juego().barcosHundidosPorMi.add(barcoHundido);
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
          Juego().disparosAcertadosRival.add(Offset(disparo['i'].toDouble(), disparo['j'].toDouble()));
        }
        else {
          Juego().disparosFalladosRival.add(Offset(disparo['i'].toDouble(), disparo['j'].toDouble()));
        }

        if (hundido) {
          Barco barcoHundido = buscarBarcoHundidoDisparo(elemento);
          Juego().barcosHundidosPorRival.add(barcoHundido);
          Juego().misBarcosRestantes--;
        }
      }

      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
    }
  }


 Future<void> realizarDisparoMisil() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlDispararMisil),
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
      print(data);
    } else {
      throw Exception('Failed to load data');
    }
  }


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
          'turnoRecarga': true,
        }),
      );
    }
    else {
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
        }),
      );
    }

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
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
          Juego().disparosAcertadosPorMi.add(disparoCoordenadas);
        });
      } else {
        setState(() {
          Juego().disparosFalladosPorMi.add(disparoCoordenadas);
        });
      }

      if (hundido) {
        setState(() {
        Juego().barcosRestantesRival--;
        nombreBarcoHundido = data['barcoCoordenadas']['tipo'];
        Barco barcoHundido = buscarBarcoHundidoDisparo(data);
        Juego().barcosHundidosPorMi.add(barcoHundido);
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
          Juego().disparosAcertadosRival.add(Offset(disparo['i'].toDouble(), disparo['j'].toDouble()));
        }
        else {
          Juego().disparosFalladosRival.add(Offset(disparo['i'].toDouble(), disparo['j'].toDouble()));
        }

        if (hundido) {
          Barco barcoHundido = buscarBarcoHundidoDisparo(elemento);
          Juego().barcosHundidosPorRival.add(barcoHundido);
          Juego().misBarcosRestantes--;
        }
      }

      return Future.value([acertado, fin]);
    } else {
      throw Exception('Failed to load data');
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
      var data = jsonDecode(response.body);
      print(data);
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
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
          Juego().disparosAcertadosPorMi.add(disparoCoordenadas);
        });
      } else {
        setState(() {
          Juego().disparosFalladosPorMi.add(disparoCoordenadas);
        });
      }

      if (hundido) {
        setState(() {
          Juego().barcosRestantesRival--;
          nombreBarcoHundido = data['barcoCoordenadas']['tipo'];
          Barco barcoHundido = buscarBarcoHundidoDisparo(data);
          Juego().barcosHundidosPorMi.add(barcoHundido);
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
          setState(() {
            Juego().disparosAcertadosRival.add(Offset(disparo['i'].toDouble(), disparo['j'].toDouble()));
          });
        }
        else {
          setState(() {
            Juego().disparosFalladosRival.add(Offset(disparo['i'].toDouble(), disparo['j'].toDouble()));
          });
        }

        if (hundido) {
          setState(() {
            Barco barcoHundido = buscarBarcoHundidoDisparo(elemento);
            Juego().barcosHundidosPorRival.add(barcoHundido);
            Juego().misBarcosRestantes--;
          });
        }
      }

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
      var data = jsonDecode(response.body);

      return Future.value([true, true]);
    } else {
      throw Exception('Failed to load data');
    }
  }
}