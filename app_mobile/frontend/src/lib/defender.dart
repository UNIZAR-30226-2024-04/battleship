import 'dart:async';
import 'package:battleship/authProvider.dart';
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

  @override
  void initState() {
    super.initState();
    iniciarTransicionAutomatica();
  }

  void iniciarTransicionAutomatica() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        Juego().contabilizarAtaque();
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
            buildActions(context),
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
                if (!Juego().tablero_oponente.barcos[i].hundido) 
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

  Future<Widget> _construirTableroConBarcosDefensa2() async {
    var disparosenemigosFuture = obtenerDisparosEnemigos();
    Map<String, List<Offset>> disparosEnemigos = await disparosenemigosFuture;
    print("OBTENGO LOS DISPAROS ENEMIGOS: ");
    print(disparosEnemigos);

    List<Offset> disparosAgua = disparosEnemigos['Agua']!;
    List<Offset> disparosAcertados = disparosEnemigos['Acertados']!;
    print("DISPAROS AGUA:");
    print(disparosAgua);
    print("DISPAROS ACERTADOS:");
    print(disparosAcertados);

    var barcoshundidosFuture = obtenerBarcosHundidos();
    List<bool> barcosHundidos = await barcoshundidosFuture;
    print("BARCOS HUNDIDOS:");
    print(barcosHundidos);

    var barcosFuture = Juego().obtenerBarcos(AuthProvider().name, Juego().urlObtenerTablero);
    List<Barco> barcosJugador = await barcosFuture;
    print("BARCOS JUGADOR:");
    print(barcosJugador);


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
        for(int i = 0; i < disparosAgua.length; i++)
          Positioned(
            top: disparosAgua[i].dx * Juego().tablero_oponente.casillaSize,
            left: disparosAgua[i].dy * Juego().tablero_oponente.casillaSize,
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

        for(int i = 0; i < disparosAcertados.length; i++)
          Positioned(
            top: disparosAcertados[i].dx * Juego().tablero_oponente.casillaSize,
            left: disparosAcertados[i].dy * Juego().tablero_oponente.casillaSize,
            child: Column(
              children: [
                Image.asset(
                  'images/explosion.png',
                  width: Juego().tablero_oponente.casillaSize,
                  height: Juego().tablero_oponente.casillaSize,
                ),
              ],
            ),
          ),

        for (int i = 0; i < barcosHundidos.length; i++)
          if (barcosHundidos[i])
            Positioned(
              top: barcosJugador[i].barcoPosition.dx * Juego().tablero_oponente.casillaSize,
              left: barcosJugador[i].barcoPosition.dy * Juego().tablero_oponente.casillaSize,
              child: Image.asset(
                barcosJugador[i].getImagePath(),
                width: barcosJugador[i].getWidth(Juego().tablero_oponente.casillaSize),
                height: barcosJugador[i].getHeight(Juego().tablero_oponente.casillaSize),
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









////////////////////////////////////////////////////////

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
        for (var barco in Juego().barcosHundidosPorJugador)
          Positioned(
            top: barco.barcoPosition.dx * Juego().tablero_jugador.casillaSize,
            left: barco.barcoPosition.dy * Juego().tablero_jugador.casillaSize,
            child: Column(
              children: [
                GestureDetector(
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      barco.getImagePath(),
                      width: barco.getWidth(Juego().tablero_jugador.casillaSize),
                      height: barco.getHeight(Juego().tablero_jugador.casillaSize),
                      fit: BoxFit.fill,
                    ),
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






//////////////////////////////////////////////////////////////