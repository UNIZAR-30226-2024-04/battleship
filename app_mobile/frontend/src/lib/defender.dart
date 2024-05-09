import 'dart:async';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'barco.dart';
import 'atacar.dart';
import 'destino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';

class Defender extends StatefulWidget {
  const Defender({super.key});

  @override
  _DefenderState createState() => _DefenderState();
}

class _DefenderState extends State<Defender> {
  bool _isLoading = true;
  ServerRoute serverRoute = ServerRoute();
  Completer completerAbandono = Completer();
  Completer resultadoTurno = Completer();
  bool atacar = false;  // indica si me toca atacar tras el evento recibido

  @override
  void initState() {
    super.initState();

    Juego().socket.on('abandono', (data) {
      //print('Abandono: $data');
      if (!completerAbandono.isCompleted) {
        completerAbandono.complete();
      }
    });

    Juego().socket.on('resultadoTurno', (data) {
      Juego().hayNiebla = data[6] == 'Niebla';

      print("Niebla: ${Juego().hayNiebla}");

      if(!Juego().hayNiebla) {
        print("Entro al if");
        atacar = data[2]['estado'] == 'Agua';
      }
      else {
        print("No entro en el if porque ha habido un disparo con efecto niebla");
        atacar = true;
      }

      // Si el estado es agua y el usuario es el otro
      if(atacar && data[1] != Juego().miPerfil.name) {
        print('Resultado turno: $data');
        setState(() {
          Juego().disparosPendientes = 1;
        });

        DestinoManager.setDestino(const Atacar());
        Navigator.pushNamed(context, '/Atacar');        
      }
      else if (!atacar) {
        //print('El rival ha acertado y voy a refrescar: $data');

      }
    });     

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    if (Juego().modalidadPartida == 'INDIVIDUAL') {
      iniciarTransicionAutomatica();
    }
  }

  @override
  Widget build(BuildContext context) {
    esperarTurno();
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
            ? const Center(child: Text('¡Defiéndete!', style: TextStyle(color: Colors.white, fontSize: 28)))
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

  Widget _construirBarcosRestantes() {
    List<Barco> barcosRestantes = Juego().obtenerMisBarcosRestantes();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTitle('Tus barcos restantes: ${Juego().misBarcosRestantes}', 16),
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

  Future<Widget> _construirTableroConBarcosDefensa() async {
    List<Widget> children = [];

    children.add(
      SizedBox(
        width: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
        height: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: await buildTableroDefensa(),
        ),
      ),
    );  

    return Stack(children: children);
  }

  Future<List<Widget>> buildTableroDefensa() async {
    List<Widget> filas = [];
    filas.add(await buildFilaCasillasDefensa());
    return filas;
  }

  Future<Widget> buildFilaCasillasDefensa() async {
    List<Barco> barcosRestantes = Juego().obtenerMisBarcosRestantes();
    return Stack(
      children: [
        SizedBox(
          width: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
          height: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildTablero(),
          ),
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

  List<Widget> buildTablero() {
    List<Widget> filas = [];
    // Añade una fila adicional para las etiquetas de las coordenadas
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().miTablero.numFilas; i++) {
      filas.add(buildFilaCasillas(i));
    }
    return filas;
  }

  Widget buildFilaCasillas(int rowIndex) {
    List<Widget> casillas = [];
    // Etiqueta de fila
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
      String imagePath = '';
      if (Juego().disparosFalladosRival.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        imagePath = 'images/redCross.png';
      } else if (Juego().disparosAcertadosRival.contains(Offset(rowIndex.toDouble(), j.toDouble()))) {
        imagePath = 'images/explosion.png';
      }

      if (Juego().barcosHundidosPorRival.isNotEmpty) {
        Offset pos = Offset(rowIndex.toDouble(), j.toDouble());
        if (Juego().barcosHundidosPorRival.contains(pos)) {
          // Obtener el barco hundido en la posición pos.
          Barco barcoHundido = Juego().barcosHundidosPorRival.firstWhere((element) => element.barcoPosition == pos);
          imagePath = barcoHundido.getImagePath();
        }
      }

      casillas.add(
        GestureDetector(
          child: Container(
            width: Juego().miTablero.casillaSize,
            height: Juego().miTablero.casillaSize,
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
  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// PARTIDA VS IA  /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void iniciarTransicionAutomatica() {
    Timer(const Duration(seconds: 4), () {
      setState(() {
        Juego().disparosPendientes = 1;
      });
      DestinoManager.setDestino(const Atacar());
      Navigator.pushNamed(context, '/Atacar');
    });
  }


  Future<Map<String, List<Offset>>> obtenerDisparosEnemigos() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlMostrarMiTablero),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': Juego().miPerfil.name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

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

      // Mostar disparos enemigos agua
      for (var disparo in disparosAgua) {
        //print('Disparo enemigo agua: ${disparo.dx}, ${disparo.dy}');
      }

      // Mostar disparos enemigos acertados
      for (var disparo in disparosAcertados) {
        //print('Disparo enemigo acertado: ${disparo.dx}, ${disparo.dy}');
      }


      return {
        'Agua': disparosAgua,
        'Acertados': disparosAcertados,
      };
    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Future<List<bool>> obtenerBarcosHundidos() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlMostrarMiTablero),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': Juego().miPerfil.name,
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// PARTIDA COMPETITIVA ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> esperarTurno() async {
    await Future.wait([completerAbandono.future, resultadoTurno.future]);
    if (completerAbandono.isCompleted) {
      //print('Abandono');
    }
  }
}