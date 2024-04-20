import 'package:battleship/destino.dart';
import 'package:battleship/juego.dart';
import 'package:battleship/main.dart';
import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'barco.dart';
import 'comun.dart';
import 'defender.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Atacar extends StatefulWidget {
  String urlDisparar = 'http://localhost:8080/partida/realizarDisparo';
  String urlMostrarTableroEnemigo = 'http://localhost:8080/partida/mostrarTableroEnemigo';

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
            FutureBuilder<Widget>(
              future: _construirTableroConBarcosAtacable(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the future to complete, you can show a loading indicator.
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error, you can show an error message.
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Once the future completes, return the widget.
                  return snapshot.data!;
                }
              },
            ),
            _construirHabilidades(),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  Future<Widget> _construirTableroConBarcosAtacable() async {
    List<Widget> children = [];

    children.add(
      SizedBox(
        width: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
        height: Juego().tablero_oponente.boardSize + Juego().tablero_oponente.casillaSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: await buildTableroClicable(_handleTap),
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

  Future<Map<String, List<Offset>>> obtenerMisDisparos() async {
    print("EL CODIGO ES: ${Juego().codigo}");
    print("LLAMO A OBTENER MIS DISPAROS CON: ${widget.urlMostrarTableroEnemigo} Y ${Juego().tokenSesion} Y ${Juego().codigo} Y ${Juego().perfilJugador.name}");
    var response = await http.post(
      Uri.parse(widget.urlMostrarTableroEnemigo),
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
      print("ESTOS SON MIS DISPAROS:");
      print(data);
      print(data.runtimeType);

      var disparosEnemigos = data['misDisparos'] as List;
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
      print("EL CODIGO ES: ${Juego().codigo}");
      return {
        'Agua': disparosAgua,
        'Acertados': disparosAcertados,
      };
    } else {
      throw Exception('La solicitud ha fallado');
    }
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
    filas.add(buildFilaCoordenadas());
    for (int i = 1; i < Juego().tablero_oponente.numFilas; i++) {
      filas.add(await buildFilaCasillasClicables(i, onTap));
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
  
  Future<void> obtenerBarcosEnemigo() async {
    var response = await http.post(
      Uri.parse(widget.urlMostrarTableroEnemigo),
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
      print("BARCOS DEL ENEMIGO:");
      print(data);
      print(data.runtimeType);
    } else {
      throw Exception('La solicitud ha fallado');
    }
  }



  Future<Widget> buildFilaCasillasClicables(int rowIndex, Function(int, int) onTap) async {
    var disparos_future = obtenerMisDisparos();
    Map<String, List<Offset>> disparos = await disparos_future;
    print("OBTENGO MIS DISPAROS: ");
    print(disparos);

    List<Offset> disparosAgua = disparos['Agua']!;
    List<Offset> disparosAcertados = disparos['Acertados']!;
    print("DISPAROS AGUA:");
    print(disparosAgua);
    print("DISPAROS ACERTADOS:");
    print(disparosAcertados);

    obtenerBarcosEnemigo();

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

    for (int j = 1; j <= Juego().tablero_oponente.numColumnas; j++) {
      Offset casilla = Offset(rowIndex.toDouble(), j.toDouble());
      if (disparosAgua.contains(casilla)) {
        casillas.add(
          GestureDetector(
            onTap: () {
              onTap(rowIndex, j);
            },
            child: Image.asset(
              'images/redCross.png',
              width: Juego().tablero_oponente.casillaSize,
              height: Juego().tablero_oponente.casillaSize,
              fit: BoxFit.cover
            ),
          ),
        );
      } else if (disparosAcertados.contains(casilla)) {
        casillas.add(
          GestureDetector(
            onTap: () {
              onTap(rowIndex, j);
            },
            child: Image.asset(
              'images/explosion.png',
              width: Juego().tablero_oponente.casillaSize,
              height: Juego().tablero_oponente.casillaSize,
              fit: BoxFit.cover
            ),
          ),
        );
      } else {
        casillas.add(
          GestureDetector(
            onTap: () {
              onTap(rowIndex, j);
            },
            child: Image.asset(
              'images/dot.png',
              width: Juego().tablero_oponente.casillaSize,
              height: Juego().tablero_oponente.casillaSize,
              fit: BoxFit.cover
            ),
          ),
        );
      }
    }
    return Row(children: casillas);
  }

  List<bool> analizarDisparoEnemigo(List<Map<String, dynamic>> disparoEnemigo) {
    if (disparoEnemigo.isEmpty) {
      return [false, false];
    }

    var disparo = disparoEnemigo[0];
    var estado = disparo['disparoRealizado']['estado'];
    var fin = disparo['finPartida'];
    var acertado = estado == 'Tocado' || estado == 'Hundido';

    return [acertado, fin];
  }

  Future<List<bool>> realizarDisparo(int i, int j) async {
    var response = await http.post(
      Uri.parse(widget.urlDisparar),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': Juego().codigo,
        'nombreId': Juego().perfilJugador.name,
        'i': i,
        'j': j,
      }),
    );

    if (response.statusCode == 200) {
      print("DISPARO ME DEVUELVE: ");
      var data = jsonDecode(response.body);
      print(data);
      var fin = data['finPartida'];
      var turnosIA = data['turnosIA'].cast<Map<String, dynamic>>();
      var disparo = data['disparoRealizado'];
      var estado = disparo['estado'];

      //analizarDisparoEnemigo(turnosIA);

      if (estado == 'Tocado' || estado == 'Hundido') {
        return Future.value([true as bool, fin as bool]);
      }
      return Future.value([false, fin as bool]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _handleTap(int i, int j) async {
    print("TURNO: ${Juego().turno}");
    print("VOY A DISPARAR EN: $i $j");
    var respuesta_future = realizarDisparo(i, j);
    print("HE DISPARADO EN: $i $j");
    //mostrarMiTablero();
    Juego().disparosPendientes--;

    respuesta_future.then((result) {
      var acertado = result[0];
      var fin_future = result[1];
      print("ACERTADO: $acertado");
      print("FIN: $fin_future");
      // Si la casilla tiene un barco.
      if(acertado) {
        //Juego().actualizarBarcosRestantes();
        Juego().disparosPendientes ++;
        print("ACERTADOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
        if(fin_future) {
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
        Juego().disparosPendientes = 1;
        Juego().habilidadSeleccionadaEnTurno = false;
        Juego().cambiarTurno();
        DestinoManager.setDestino(Defender());
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Defender(),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      }
    });
  }
}
