import 'dart:async';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'barco.dart';
import 'atacar.dart';
import 'destino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Defender extends StatefulWidget {
  String urlMostrarTableroEnemigo = 'http://localhost:8080/partida/mostrarTableroEnemigo';
  String urlMostrarMiTablero = 'http://localhost:8080/partida/mostrarMiTablero';

  Defender({super.key});

  @override
  _DefenderState createState() => _DefenderState();
}

class _DefenderState extends State<Defender> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    iniciarTransicionAutomatica();
  }

  void iniciarTransicionAutomatica() {
    Timer(const Duration(seconds: 4), () {
      setState(() {
        Juego().contabilizarAtaque();
        Juego().disparosPendientes = 1;
        Juego().habilidadSeleccionadaEnTurno = false;
        Juego().cambiarTurno();
      });
      DestinoManager.setDestino(Atacar());
      Navigator.pushNamed(context, '/Atacar');
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
        body: _isLoading
            ? const Center(child: Text('¡Defiéndete!', style: TextStyle(color: Colors.white, fontSize: 24)))
            : Column(
                children: [
                  buildHeader(context, ponerPerfil: false),
                  const SizedBox(height: 20),
                  _construirBarcosRestantes(),
                  FutureBuilder<Widget>(
                    future: _construirTableroConBarcosDefensa(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While waiting for the future to complete, you can show a loading indicator.
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // If there's an error, you can show an error message.
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Once the future completes, return the widget.
                        return snapshot.data!;
                      }
                    },
                  ),
                  const Spacer(),
                ],
              ),
      ),
    );
  }

  Future<Map<String, List<Offset>>> obtenerDisparosEnemigos() async {
    var response = await http.post(
      Uri.parse(widget.urlMostrarMiTablero),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': Juego().perfilJugador.name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      print(data.runtimeType);

      var disparosEnemigos = data['disparosEnemigos'] as List;
      List<Offset> disparosAgua = [];
      List<Offset> disparosAcertados = [];

      for (var disparo in disparosEnemigos) {
        double i = disparo['i'].toDouble();
        double j = disparo['j'].toDouble();
        if (disparo['estado'] == 'Agua') {
          disparosAgua.add(Offset(i, j));
        } else {
          disparosAcertados.add(Offset(i, j));
        }
      }

      print(disparosAgua);
      print(disparosAcertados);

      return {
        'Agua': disparosAgua,
        'Acertados': disparosAcertados,
      };
    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Widget _construirBarcosRestantes() {
    print("TURNO EN DEFENDER: ${Juego().turno}");
    List<Barco> barcosRestantes = Juego().obtenerBarcosRestantes();
    for (var barco in barcosRestantes) {
      barco.showInfo();
    }
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

  Future<List<bool>> obtenerBarcosHundidos() async {
    var response = await http.post(
      Uri.parse(widget.urlMostrarMiTablero),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': Juego().perfilJugador.name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var tableroBarcos = data['tableroBarcos'] as List;
      List<bool> listaBarcosHundidos = [];

      for (var barco in tableroBarcos) {
        var coordenadas = barco['coordenadas'] as List;
        bool hundido = true;

        for (var casilla in coordenadas) {
          if (casilla['estado'] == 'Agua') {
            hundido = false;
            break;
          }
        }

        listaBarcosHundidos.add(hundido);
      }

      return listaBarcosHundidos;
    } else {
      throw Exception('La solicitud ha fallado');
    }
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

  Future<List<Widget>> buildTableroDefensa() async {
    List<Widget> filas = [];
    filas.add(await buildFilaCasillasDefensa());
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
  
  Future<Widget> buildFilaCasillas(int rowIndex) async {
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
      String imagePath = '';
      if (Juego().disparosFalladosJugador.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        imagePath = 'images/redCross.png';
      } else if (Juego().disparosAcertadosJugador.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        imagePath = 'images/explosion.png';
      }

      if (Juego().barcosHundidosPorJugador.isNotEmpty) {
        Offset pos = Offset(rowIndex.toDouble(), j.toDouble());
        if (Juego().barcosHundidosPorJugador.contains(pos)) {
          // Obtener el barco hundido en la posición pos.
          Barco barcoHundido = Juego().barcosHundidosPorJugador.firstWhere((element) => element.barcoPosition == pos);
          imagePath = barcoHundido.getImagePath();
        }
      }

      casillas.add(
        GestureDetector(
          child: Container(
            width: Juego().tablero_oponente.casillaSize,
            height: Juego().tablero_oponente.casillaSize,
            decoration: BoxDecoration(
              color: const Color.fromARGB(128, 116, 181, 213),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: imagePath != '' ? Image.asset(imagePath, fit: BoxFit.cover) : null,
          ),
        ),
      );
    }
    
    return Row(children: casillas);
  }

  Future<Widget> buildFilaCasillasDefensa() async {
    print("TURNO EN DEFENDER: ${Juego().turno}");
    List<Barco> barcosRestantes = Juego().obtenerBarcosRestantes();
    return Stack(
      children: [
        SizedBox(
          width: Juego().tablero_jugador.boardSize + Juego().tablero_jugador.casillaSize,
          height: Juego().tablero_jugador.boardSize + Juego().tablero_jugador.casillaSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: await buildTablero(),
          ),
        ),
        for (var barco in Juego().tablero_oponente.barcos)
          Positioned(
            top: barco.barcoPosition.dx * Juego().tablero_oponente.casillaSize,
            left: barco.barcoPosition.dy * Juego().tablero_oponente.casillaSize,
            child: Column(
              children: [
                GestureDetector(
                  child: Image.asset(
                    barco.getImagePath(),
                    width: barco.getWidth(Juego().tablero_oponente.casillaSize),
                    height: barco.getHeight(Juego().tablero_oponente.casillaSize),
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

  Future<List<Widget>> buildTablero() async {
    List<Widget> filas = [];
    // Añade una fila adicional para las etiquetas de las coordenadas
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().tablero_jugador.numFilas; i++) {
      filas.add(await buildFilaCasillas(i));
    }
    return filas;
  }

  Future<Widget> _construirTableroConBarcosDefensa() async {
    List<Widget> children = [];

    children.add(
      SizedBox(
        width: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
        height: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: await buildTableroDefensa(),
        ),
      ),
    );  

    return Stack(children: children);
  }
