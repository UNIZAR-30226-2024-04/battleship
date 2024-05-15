import 'dart:async';
import 'package:battleship/juego.dart';
import 'package:flutter/material.dart';
import 'botones.dart';
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
        Juego().reiniciarPartida();
        showSuccessSnackBar(context, '¡Has ganado la partida por abandono de tu oponente!');
        Navigator.pushNamed(context, '/Principal');
      }
    });

    Juego().socket.on('resultadoTurno', (data) {
      String tipo = data[0];
      bool fin = false;
      var booleanoExtra;
      var disparosRespuestaMina;
      var barcosHundidosRespuestaMina;
      var eventoOcurrido;
      var disparo;
      var barcosCoordenadas;

      if (!(tipo == 'Sonar' || tipo == 'Mina')) {
        fin = data[4];
        disparosRespuestaMina = data[9];
        barcosHundidosRespuestaMina = data[10];
        eventoOcurrido = data[6];
        disparo = data[2];
        barcosCoordenadas = data[3];
        if (data[5] != null) {
          Juego().clima = data[5];
        }
      }
      if (tipo == 'Recargado' || tipo == 'Rafaga') {
        booleanoExtra = data[11];
      }
      // Procesar disparos de respuesta a minas.
      if (disparosRespuestaMina != null && disparosRespuestaMina.isNotEmpty) {
        for (var disp in disparosRespuestaMina) {
          procesarDisparo(disp, barcosHundidosRespuestaMina);
        }
      }

      if (fin) {
        showErrorSnackBar(context, 'Has perdido la partida');
        Juego().reiniciarPartida();
        Navigator.pushNamed(context, '/Principal');
      }


      if(data[1] != Juego().miPerfil.name) {
        if(eventoOcurrido != 'Niebla') {
          // Si no soy yo
            switch (tipo) {

              case 'Rafaga': // CASO RAFAGA
                procesarTurnoRival(tipo, disparo, [barcosCoordenadas], ultimaRafaga:booleanoExtra);
                break;

              case 'Recargado': // CASO TORPEDO RECARGADO
                bool turnoRecarga = booleanoExtra;
                if (turnoRecarga) { // No ataca, vamos a atacar nosotros
                  setState(() {
                    Juego().disparosPendientes = 1; // Los disparos que tendré yo en mi turno
                    if (Juego().indiceHabilidadSeleccionadaEnTurno != -1 && 
                    Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre != 'torpedo') {
                      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
                    }
                  });
                  Future.delayed(const Duration(milliseconds: 1100), () {
                    Navigator.pushNamed(context, '/Atacar'); 
                  }); 
                } else { // Torpedo ataca
                  int numFallados = 0;
                  bool todosFallados = false;
                  for (var disp in disparo) {
                    if (disp['estado'] == 'Agua') {
                      numFallados++;
                    }
                    if (numFallados == disparo.length) {
                      todosFallados = true;
                    }
                    if (barcosCoordenadas != null) {
                      procesarTurnoRival(tipo, disp, barcosCoordenadas, todosFallados:todosFallados);
                    } else {
                      procesarTurnoRival(tipo, disp, [barcosCoordenadas], todosFallados:todosFallados);
                    }
                  }

                }
                break;
              
              case 'Mina': // CASO MINA
                showInfoSnackBar(context, 'El rival ha usado la mina');
                setState(() {
                  Juego().disparosPendientes = 1; // Los disparos que tendré yo en mi turno
                  if (Juego().indiceHabilidadSeleccionadaEnTurno != -1 && 
                  Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre != 'torpedo') {
                    Juego().indiceHabilidadSeleccionadaEnTurno = -1;
                  }
                });
                Future.delayed(const Duration(milliseconds: 1100), () {
                  Navigator.pushNamed(context, '/Atacar'); 
                }); 
                break;
              case 'Sonar': // CASO SONAR
                showInfoSnackBar(context, 'El rival ha usado el sonar');                
                setState(() {
                  Juego().disparosPendientes = 1; // Los disparos que tendré yo en mi turno
                  if (Juego().indiceHabilidadSeleccionadaEnTurno != -1 && 
                  Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre != 'torpedo') {
                    Juego().indiceHabilidadSeleccionadaEnTurno = -1;
                  }
                });
                Future.delayed(const Duration(milliseconds: 1100), () {
                  Navigator.pushNamed(context, '/Atacar'); 
                }); 
                break;

              default: // CASO disparo normal o teledirigido
                procesarTurnoRival(tipo, disparo, [barcosCoordenadas]);
                break;
            }
        }
        else {
          atacar = true;
          if (Juego().indiceHabilidadSeleccionadaEnTurno != -1 && 
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre != 'torpedo') {
            Juego().indiceHabilidadSeleccionadaEnTurno = -1;
          }
          Future.delayed(const Duration(milliseconds: 1100), () {
            Navigator.pushNamed(context, '/Atacar'); 
          }); 
        }
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
            _construirTableroConBarcosDefensa(),
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
            const SizedBox(height: 10), // Espacio entre el botón y el texto
            Text(
              'Clima es: ${Juego().clima}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Ajusta el espacio debajo del texto
          ],
        ),
      ),
    );
  }

  Widget _construirBarcosRestantes() {
    List<Barco> barcosRestantes = Juego().obtenerMisBarcosRestantes();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 17, 177, 105).withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTitle('Tus barcos restantes: ${barcosRestantes.length}', 16),
          const SizedBox(height: 5),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < barcosRestantes.length; i++) 
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'images/${barcosRestantes[i].nombre}.png', 
                        width: 50, 
                        height: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3), 
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

  Widget _construirInfoRival(String nombreRival) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Text(
              nombreRival,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
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
        for(var mina in Juego().minasColocadasPorMi)
          Positioned(
            top: mina.dx * Juego().miTablero.casillaSize,
            left: mina.dy * Juego().miTablero.casillaSize,
            child: GestureDetector(
              child: Image.asset(
                'images/mineSymbol.png',
                width: Juego().miTablero.casillaSize,
                height: Juego().miTablero.casillaSize,
                fit: BoxFit.fill,
              ),
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
    Timer(const Duration(seconds: 2), () {
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
      }

      // Mostar disparos enemigos acertados
      for (var disparo in disparosAcertados) {
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
    }
  }

  // Funcion que procesa el turno del rival
  void procesarTurnoRival(tipo, disparo, barcosCoordenadas, {ultimaRafaga = true, todosFallados = true}) async {
    int i = disparo['i'];
    int j = disparo['j'];
    bool atacar = disparo['estado'] == 'Agua';
    if(atacar) {
      setState(() {
        Juego().disparosFalladosRival.add(Offset(i.toDouble(), j.toDouble()));
      });
      if (ultimaRafaga && todosFallados) {
        setState(() {
          Juego().disparosPendientes = 1; // Los disparos que tendré yo en mi turno
          if (Juego().indiceHabilidadSeleccionadaEnTurno != -1 && 
          Juego().habilidades[Juego().indiceHabilidadSeleccionadaEnTurno].nombre != 'torpedo') {
            Juego().indiceHabilidadSeleccionadaEnTurno = -1;
          }
        });
        Future.delayed(const Duration(milliseconds: 2200), () {
          Navigator.pushNamed(context, '/Atacar'); 
        });  
      }
    }
    else {
      setState(() {
        Juego().disparosAcertadosRival.add(Offset(i.toDouble(), j.toDouble()));
        // Barco coordenadas no null
        if (barcosCoordenadas != null && barcosCoordenadas.isNotEmpty) {
          for (var barco in barcosCoordenadas) {
            if (barco != null) {
              Barco barcoHundido = Juego().buscarBarcoHundidoDisparo(barco);
              Juego().barcosHundidosPorRival.add(barcoHundido);
            }
          }
        }
      });
    }
    
  }

  bool procesarDisparo(disparo, barcosCoordenadas) {
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
}