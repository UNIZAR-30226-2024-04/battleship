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
  List<bool> barcosJugador1 = [];
  List<bool> barcosJugador2 = [];
  int ganador = 0;
  List<Habilidad> habilidadesJugador1 = [];   // habilidades en el mazo del jugador 1
  List<Habilidad> habilidadesJugador2 = [];   // habilidades en el mazo del jugador 2
  Perfil perfilJugador1 = Perfil('');
  Perfil perfilJugador2 = Perfil('');
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
  int codigo = 0;
  String tokenSesion = '';

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
    barcosJugador1 = List.filled(numBarcos, true);
    barcosJugador2 = List.filled(numBarcos, true);
    perfilJugador1 = Perfil('usuario1', turno: 1);
    perfilJugador2 = Perfil('maquina', turno: 2);
    habilidadesJugador1 = perfilJugador1.getHabilidadesSeleccionadas();
    habilidadesJugador2 = perfilJugador2.getHabilidadesSeleccionadas();
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

  Future<void> inicializarBarcosJugador() async {
    tablero_jugador1.barcos = await obtenerBarcos(AuthProvider().name, urlObtenerTablero);
  }

  Perfil getPerfilJugador() {
    return turno == 1 ? perfilJugador1 : perfilJugador2;
  }

  Perfil getPerfilOponente() {
    return turno == 1 ? perfilJugador2 : perfilJugador1;
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


  List<Barco> procesaTableroBD(List<List<Offset>> tablero, List<String> nombres) {
    List<Barco> barcos = [];

    for (int i = 0; i < numBarcos; i++) {
      String nombre = nombres[i];
      Offset barcoPos = Offset(tablero[i][0].dx, tablero[i][0].dy);
      int long = tablero[i].length;
      bool rotado = tablero[i][0].dy == tablero[i][1].dy ? true : false;
      bool hundido = false;
      barcos.add(Barco(nombre, barcoPos, long, rotado, hundido));
      barcos[i].showInfo();
    }
    return barcos;
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
      List<dynamic> tableroInicial = userMap['tableroInicial'];

      print(data);
      print(tableroInicial);
      List<List<Offset>> coordenadas = getCoordinates(tableroInicial);
      print(coordenadas);
      List<String> nombres = getNames(tableroInicial);
      print(procesaTableroBD(coordenadas, nombres));

      return procesaTableroBD(coordenadas, nombres);

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Future<bool> moverBarco(String url, Offset nuevaPos, bool rotar, String usuario, int barcoId) async {
    var uri = Uri.parse(url);
    var response = await http.post(
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
      var data = jsonDecode(response.body);
      print(data);
      if(data.isNotEmpty) {
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

  List<bool> get barcosRestantes_jugador {
    return turno == 1 ? barcosJugador1 : barcosJugador2;
  }

  List<bool> get barcosRestantes_oponente {
    return turno == 1 ? barcosJugador2 : barcosJugador1;
  }

  List<Barco> get barcos_jugador {
    return turno == 1 ? tablero_jugador1.barcos : tablero_jugador2.barcos;
  }

  List<Barco> get barcos_oponente {
    return turno == 1 ? tablero_jugador2.barcos : tablero_jugador1.barcos;
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

  void actualizarBarcosRestantes() {
    for (int i = 0; i < barcosRestantes_oponente.length; i++) {
      if (barcosRestantes_oponente[i]) {
        Barco barco = tablero_oponente.barcos[i];
        if (barcoHundido(barco, tablero_oponente)) {
          barcosRestantes_oponente[i] = false;
          decrementarBarcosRestantesOponente();
        }
      }
    }
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
    barcosJugador1 = List.filled(numBarcos, true);
    barcosJugador2 = List.filled(numBarcos, true);
    ganador = 0;
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

  void callbackAtaque() {
    for (int i = 0; i < numHabilidades; i++) {
      getHabilidadesJugador()[i].informarHabilidad();
    }
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


  Future<void> crearPartida() async {
    var response = await http.post(
      Uri.parse(urlCrearPartida),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenSesion',
      },
      body: jsonEncode(<String, String>{
        'nombreId1': getPerfilJugador().name,
        'nombreId2': 'maquina',
        'bioma': 'Mediterraneo' ,
      }),
      
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);

      codigo = data['codigo'];

      print(codigo);  

      //print(data['tableroBarcos1']);

      //print(obtenerEstado(data['tableroBarcos1']));


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