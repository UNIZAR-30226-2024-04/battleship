import 'package:battleship/authProvider.dart';
import 'package:battleship/tablero.dart';
import 'package:flutter/material.dart';
import 'barco.dart';
import 'habilidad.dart';
import 'perfil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Juego {
  Tablero tablero_jugador1 = Tablero();
  Tablero tablero_jugador2 = Tablero();
  int numBarcos = 5;
  int barcosRestantesJugador1 = 0;
  int barcosRestantesJugador2 = 0;
  int turno = 1;
  int ganador = 0;
  List<Habilidad> habilidadesJugador1 = [];   // habilidades en el mazo del jugador 1
  List<Habilidad> habilidadesJugador2 = [];   // habilidades en el mazo del jugador 2
  Perfil perfilJugador = Perfil('');
  List<bool> habilidadesUtilizadasJugador1 = [];
  List<bool> habilidadesUtilizadasJugador2 = [];
  int disparosPendientes = 0; // disparo básico 1. Habilidades depende
  bool habilidadSeleccionadaEnTurno = false;
  int numHabilidades = 3;
  int numAtaques = 0; // número de ataques en total
  int numAtaquesJugador1 = 0;
  int numAtaquesJugador2 = 0;
  int indexHabilidad = 0;
  String urlObtenerTablero = 'http://localhost:8080/perfil/obtenerDatosPersonales';
  String urlMoverBarcoInicial = 'http://localhost:8080/perfil/moverBarcoInicial';
  String urlActualizarPartida = 'http://localhost:8080/partida/actualizarEstadoPartida';
  String urlCrearPartida = 'http://localhost:8080/partida/crearPartida';
  String urlMostrarMiTablero = 'http://localhost:8080/partida/mostrarMiTablero';
  int codigo = -1;
  String tokenSesion = '';
  List<Offset> disparosAcertadosJugador1 = [];
  List<Offset> disparosAcertadosJugador2 = [];
  List<Offset> disparosFalladosJugador1 = [];
  List<Offset> disparosFalladosJugador2 = [];
  List<Barco> barcosHundidosPorJugador1 = [];
  List<Barco> barcosHundidosPorJugador2 = [];

  // Instancia privada y estática del singleton
  static final Juego _singleton = Juego._internal();

  // Constructor privado
  Juego._internal() {
    tablero_jugador1 = Tablero();
    tablero_jugador2 = Tablero();
    numBarcos = 5;
    barcosRestantesJugador1 = numBarcos;
    barcosRestantesJugador2 = numBarcos;
    turno = 1;
    perfilJugador = Perfil('usuario1', turno: 1);
    habilidadesJugador1 = perfilJugador.getHabilidadesSeleccionadas();
    //habilidadesJugador2 = perfilJugador2.getHabilidadesSeleccionadas();
    habilidadesUtilizadasJugador1 = List.filled(habilidadesJugador1.length, false);
    habilidadesUtilizadasJugador2 = List.filled(habilidadesJugador2.length, false);
    disparosPendientes = 1;
    habilidadSeleccionadaEnTurno = false;
    numHabilidades = 3;
    numAtaques = 0;
    numAtaquesJugador1 = 0;
    numAtaquesJugador2 = 0;
    indexHabilidad = 0;
  }

  Future<void> actualizarBarcosJugadores() async {
    tablero_jugador1.barcos = await obtenerBarcos(AuthProvider().name, urlObtenerTablero);
  }

  // Método para obtener la instancia del singleton
  factory Juego() {
    return _singleton;
  }

  List<List<Offset>> getCoordinates(List<dynamic> inputList) {
    List<List<Offset>> coordinates = [];

    for (var barco in inputList) {
      List<dynamic> coordenadas = barco['coordenadas'];
      List<Offset> coordenadasBarco = [];
      for (var coordenada in coordenadas) {
        coordenadasBarco.add(Offset(coordenada['i'].toDouble(), coordenada['j'].toDouble()));
      }
      coordinates.add(coordenadasBarco);
    }

    return coordinates;
  }

  List<String> getNames(List<dynamic> inputList) {
    List<String> nombresBarcos = [];

    for (var barco in inputList) {
      nombresBarcos.add(barco['tipo'].toLowerCase());
    }

    return nombresBarcos;
  }


  List<Barco> procesaTableroBD(List<List<Offset>> tablero, List<String> nombres, List<bool> barcosHundidos) {
    List<Barco> barcos = [];

    for (int i = 0; i < numBarcos; i++) {
      String nombre = nombres[i];
      Offset barcoPos = Offset(tablero[i][0].dx, tablero[i][0].dy);
      int long = tablero[i].length;
      bool rotado = tablero[i][0].dy == tablero[i][1].dy ? true : false;
      bool hundido = barcosHundidos[i];
      barcos.add(Barco(nombre, barcoPos, long, rotado, hundido));
      barcos[i].showInfo();
    }
    return barcos;
  }

  List<bool> obtenerHundidos(List<dynamic> inputList) {
    List<bool> barcosHundidos = [];

    for (var barco in inputList) {
      bool hundido = true;
      for (var coordenada in barco['coordenadas']) {
        if (coordenada['estado'] == 'Agua') {
          hundido = false;
          break;
        }
      }
      barcosHundidos.add(hundido);
    }

    return barcosHundidos;
  }

  Future<List<Barco>> obtenerBarcos(String usuario, String url) async {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenSesion',
      },
      body: jsonEncode(<String, String>{
        'nombreId': usuario,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      Map<String, dynamic> userMap = jsonDecode(response.body);

      int codigoPartida = userMap['codigoPartidaActual'];
      print("EL CODIGO ES: $codigoPartida");
      if (codigoPartida != -1) {
        codigo = codigoPartida;
      }

      List<dynamic> tableroInicial = userMap['tableroInicial'];

      print("AL OBTENER BARCOS OBTENGO:");
      print(data);
      print(tableroInicial);
      List<List<Offset>> coordenadas = getCoordinates(tableroInicial);
      print(coordenadas);
      List<String> nombres = getNames(tableroInicial);
      print(nombres);
      List<bool> barcosHundidos = obtenerHundidos(tableroInicial);
      print(barcosHundidos);
      print(procesaTableroBD(coordenadas, nombres, barcosHundidos));

      return procesaTableroBD(coordenadas, nombres, barcosHundidos);

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }


  Future<bool> moverBarco(String url, Offset nuevaPos, bool rotar, String usuario, int barcoId) async {
    var uri = Uri.parse(url);
    var response = await
     http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenSesion',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': usuario,
        'barcoId': barcoId,
        'iProaNueva': nuevaPos.dx,
        'jProaNueva': nuevaPos.dy,
        'rotar': rotar,
      }),
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      print(data);

      if(data['fueraTablero'] == false && data['colisiona'] == false) {
        print("BARCO MOVIDO");
        return true;
      }
      return false;
    } else {
      return false;
    }
  }


  Tablero get tablero_jugador {
    return turno == 1 ? tablero_jugador1 : tablero_jugador2;
  }

  Tablero get tablero_oponente {
    return turno == 1 ? tablero_jugador2 : tablero_jugador1;
  }

  List<Barco> get barcos_jugador {
    return turno == 1 ? tablero_jugador1.barcos : tablero_jugador2.barcos;
  }

  List<Barco> get barcos_oponente {
    return turno == 1 ? tablero_jugador2.barcos : tablero_jugador1.barcos;
  }

  List<Offset> get disparosAcertadosJugador {
    return turno == 1 ? disparosAcertadosJugador1 : disparosAcertadosJugador2;
  }

  List<Offset> get disparosFalladosJugador {
    return turno == 1 ? disparosFalladosJugador1 : disparosFalladosJugador2;
  }

  List<Offset> get disparosAcertadosOponente {
    return turno == 1 ? disparosAcertadosJugador2 : disparosAcertadosJugador1;
  }

  List<Offset> get disparosFalladosOponente {
    return turno == 1 ? disparosFalladosJugador2 : disparosFalladosJugador1;
  }

  List<Barco> get barcosHundidosPorJugador {
    return turno == 1 ? barcosHundidosPorJugador1 : barcosHundidosPorJugador2;
  }

  List<Barco> get barcosHundidosPorOponente {
    return turno == 1 ? barcosHundidosPorJugador2 : barcosHundidosPorJugador1;
  }

  void cambiarTurno() {
    turno = turno == 1 ? 2 : 1;
  }

  void decrementarBarcosRestantesOponente() {
    if (turno == 1) {
      barcosRestantesJugador2--;
    } else {
      barcosRestantesJugador1--;
    }
  }

  int getBarcosRestantesOponente() {
    return turno == 1 ? barcosRestantesJugador2 : barcosRestantesJugador1;
  }

  int getBarcosRestantesJugador() {
    return turno == 1 ? barcosRestantesJugador1 : barcosRestantesJugador2;
  }

  // Devuelve true si el juego ha terminado y actualiza el ganador
  bool juegoTerminado() {
    if (barcosRestantesJugador1 == 0) {
      ganador = 2;
      return true;
    }
    if (barcosRestantesJugador2 == 0) {
      ganador = 1;
      return true;
    }
    return false;
  }

  // Devolver el ganador del juego
  int getGanador() {
    return ganador;
  }

  void reiniciarPartida() {
    tablero_jugador1 = Tablero();
    tablero_jugador2 = Tablero();
    numBarcos = 5;
    barcosRestantesJugador1 = numBarcos;
    barcosRestantesJugador2 = numBarcos;
    turno = 1;
    ganador = 0;
    codigo = -1;
    disparosAcertadosJugador1 = [];
    disparosAcertadosJugador2 = [];
    disparosFalladosJugador1 = [];
    disparosFalladosJugador2 = [];
    barcosHundidosPorJugador1 = [];
    barcosHundidosPorJugador2 = [];
    numAtaques = 0;
    numAtaquesJugador1 = 0;
    numAtaquesJugador2 = 0;
  }

  Offset boundPosition(Offset position, double height, double width) {
    double dx = position.dx;
    double dy = position.dy;

    // Aseguramos que el barco no se salga por la izquierda o la parte superior del tablero
    dx = dx < 1 ? 1 : dx;
    dy = dy < 1 ? 1 : dy;

    // Aseguramos que el barco no se salga por la derecha o la parte inferior del tablero
    dx = dx + height / Juego().tablero_jugador.casillaSize > Juego().tablero_jugador.numFilas ? Juego().tablero_jugador.numFilas - height / Juego().tablero_jugador.casillaSize : dx;
    dy = dy + width / Juego().tablero_jugador.casillaSize > Juego().tablero_jugador.numColumnas ? Juego().tablero_jugador.numColumnas - width / Juego().tablero_jugador.casillaSize : dy;

    return Offset(dx, dy);
  }

  // Getter de habilidades
  List<Habilidad> getHabilidadesJugador() {
    return turno == 1 ? habilidadesJugador1 : habilidadesJugador2;
  }

  List<Habilidad> getHabilidadesOponente() {
    return turno == 1 ? habilidadesJugador2 : habilidadesJugador1;
  }

  List<bool> getHabilidadesUtilizadasJugador() {
    return turno == 1 ? habilidadesUtilizadasJugador1 : habilidadesUtilizadasJugador2;
  }

  List<bool> getHabilidadesUtilizadasOponente() {
    return turno == 1 ? habilidadesUtilizadasJugador2 : habilidadesUtilizadasJugador1;
  }

  int getNumAtaques() {
    return numAtaques;
  }

  void contabilizarAtaque() {
    print("CONTABILIZAR ATAQUE");
    if (turno == 1) {
      numAtaquesJugador1++;
    } else {
      numAtaquesJugador2++;
    }
    numAtaques++;
  }


  bool barcoHundido(Barco barco, Tablero tablero) {
    List<List<int>> casillasOcupadas = barco.getCasillasOcupadas(barco.barcoPosition);
    for (int i = 0; i < casillasOcupadas.length; i++) {
      if (!tablero.casillasAtacadas[casillasOcupadas[i][0]][casillasOcupadas[i][1]]) {
        return false;
      }
    }
    return true;
  }

  List<List<String>> obtenerEstado(List<dynamic> lista) {
    List<List<String>> estados = [];
    for (var elemento in lista) {
      if (elemento is List) {
        List<String> subEstados = [];
        for (var mapa in elemento) {
          if (mapa is Map && mapa.containsKey('estado')) {
            subEstados.add(mapa['estado']);
          }
        }
        estados.add(subEstados);
      }
    }
    return estados;
  }

  
  Future<void> mostrarMiTablero() async {
    print("LLAMANDO A MOSTRAR MI TABLERO CON CODIGO: $codigo Y NOMBRE: ${AuthProvider().name}");
    var response = await http.post(
      Uri.parse(urlMostrarMiTablero),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenSesion',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': codigo,
        'nombreId': AuthProvider().name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      print(data.runtimeType);
    }
  }


  Future<void> crearPartida() async {
    var response = await http.post(
      Uri.parse(urlCrearPartida),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenSesion',
      },
      body: jsonEncode(<String, String>{
        'nombreId1': perfilJugador.name,
        'bioma': 'Mediterraneo' ,
      }),
      
    );

    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);

      codigo = data['codigo'];

      print(codigo);  

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Future<void> actualizarPartida() async {
    var response = await http.post(
      Uri.parse(urlActualizarPartida),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': codigo,
        'jugador': turno,
        'tablero': [] ,
        'disparos': [] ,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

}