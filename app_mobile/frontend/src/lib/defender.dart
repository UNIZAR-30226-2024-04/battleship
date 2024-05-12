import 'dart:async';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'barco.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';

class Defender extends StatefulWidget {
  const Defender({super.key});

  @override
  _DefenderState createState() => _DefenderState();
}

class _DefenderState extends State<Defender> {
  ServerRoute serverRoute = ServerRoute();
  Completer completerAbandono = Completer();
  Completer resultadoTurno = Completer();
  bool atacar = false;  // indica si me toca atacar tras el evento recibido

  @override
  void initState() {
    super.initState();

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

    Juego().socket.on('resultadoTurno', (data) {
      print("EN DEFENDER: $data");
      Juego().hayNiebla = data[6] == 'Niebla';
      bool fin = data[4];

      if (fin) {
        Juego().reiniciarPartida();
        showErrorSnackBar(context, 'Has perdido la partida');
        Navigator.pushNamed(context, '/Principal');
      }

      print("Niebla: ${Juego().hayNiebla}");

      if(!Juego().hayNiebla) {
        print("Entro al if");
        atacar = data[2]['estado'] == 'Agua';

        // Si no soy yo
        if(data[1] != Juego().miPerfil.name) {
          int i = data[2]['i'];
          int j = data[2]['j'];

          if(atacar) {
            print('Resultado turno: $data');
            setState(() {
              Juego().disparosPendientes = 1;
              if (Juego().indiceHabilidadSeleccionadaEnTurno != -1 && 
              Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre != 'torpedo') {
                Juego().indiceHabilidadSeleccionadaEnTurno = -1;
              }
              Juego().disparosFalladosRival.add(Offset(i.toDouble(), j.toDouble()));
            });
            Future.delayed(const Duration(milliseconds: 1100), () {
              Navigator.pushNamed(context, '/Atacar'); 
            });  
          }
          else {
            setState(() {
              Juego().disparosAcertadosRival.add(Offset(i.toDouble(), j.toDouble()));
              if (data[3] != null) {
                Barco barcoHundido = Juego().buscarBarcoHundidoDisparo(data[3]);
                Juego().barcosHundidosPorRival.add(barcoHundido);
              }
            });
          }
        }
      }
      else {
        print("No entro en el if porque ha habido un disparo con efecto niebla");
        atacar = true;
        if (Juego().indiceHabilidadSeleccionadaEnTurno != -1 && 
        Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre != 'torpedo') {
          Juego().indiceHabilidadSeleccionadaEnTurno = -1;
        }
        Future.delayed(const Duration(milliseconds: 1100), () {
          Navigator.pushNamed(context, '/Atacar'); 
        }); 
      }
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
        body: Column(
          children: [
            buildHeader(context, ponerPerfil: false),
            const SizedBox(height: 20),
            _construirBarcosRestantes(),
            _construirTableroConBarcosDefensa(),
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
          buildTitle('Tus barcos restantes: ${barcosRestantes.length}', 16),
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

  Widget _construirTableroConBarcosDefensa() {
    List<Widget> children = [];

    children.add(
      SizedBox(
        width: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
        height: Juego().miTablero.boardSize + Juego().miTablero.casillaSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildTableroDefensa(),
        ),
      ),
    );  

    return Stack(children: children);
  }

  List<Widget> buildTableroDefensa() {
    List<Widget> filas = [];
    filas.add(buildFilaCasillasDefensa());
    return filas;
  }

  Widget buildFilaCasillasDefensa() {
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
    if (Juego().minaSeleccionada == false){
      Timer(const Duration(seconds: 4), () {
        setState(() {
          Juego().disparosPendientes = 1;
          if (Juego().indiceHabilidadSeleccionadaEnTurno != -1 &&
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre != 'torpedo') {
            Juego().indiceHabilidadSeleccionadaEnTurno = -1;
          }
        });
        Navigator.pushNamed(context, '/Atacar');
      });
    }
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
/////////////////////////////////////////////// PARA COLOCAR MINAS /////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////




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