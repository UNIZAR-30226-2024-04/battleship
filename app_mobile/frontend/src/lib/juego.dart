import 'package:battleship/authProvider.dart';
import 'package:battleship/tablero.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'barco.dart';
import 'comun.dart';
import 'habilidad.dart';
import 'perfil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';

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
  Perfil perfilJugador = Perfil();
  List<bool> habilidadesUtilizadasJugador1 = [];
  List<bool> habilidadesUtilizadasJugador2 = [];
  int disparosPendientes = 0; // disparo básico 1. Habilidades depende
  bool habilidadSeleccionadaEnTurno = false;
  int numHabilidades = 3;
  int indexHabilidad = 0;
  int codigo = -1;
  String tokenSesion = '';
  List<Offset> disparosAcertadosJugador1 = [];
  List<Offset> disparosAcertadosJugador2 = [];
  List<Offset> disparosFalladosJugador1 = [];
  List<Offset> disparosFalladosJugador2 = [];
  List<Barco> barcosHundidosPorJugador1 = [];
  List<Barco> barcosHundidosPorJugador2 = [];
  String modalidadPartida = '';
  ServerRoute serverRoute = ServerRoute();

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
    habilidadesJugador1 = perfilJugador.getHabilidadesSeleccionadas();
    //habilidadesJugador2 = perfilJugador2.getHabilidadesSeleccionadas();
    habilidadesUtilizadasJugador1 = List.filled(habilidadesJugador1.length, false);
    habilidadesUtilizadasJugador2 = List.filled(habilidadesJugador2.length, false);
    disparosPendientes = 1;
    habilidadSeleccionadaEnTurno = false;
    numHabilidades = 3;
    indexHabilidad = 0;
    print("PERFIL DEL JUGADOR EN INTERNAL JUEGO: ${perfilJugador.name} ${perfilJugador.email} ${perfilJugador.password}");
  }

  // Método para obtener la instancia del singleton
  factory Juego() {
    return _singleton;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// MÉTODOS DE LA CLASE ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

  void decrementarBarcosRestantesJugador() {
    if (turno == 1) {
      barcosRestantesJugador1--;
    } else {
      barcosRestantesJugador2--;
    }
  }

  int getBarcosRestantesOponente() {
    return turno == 1 ? barcosRestantesJugador2 : barcosRestantesJugador1;
  }

  int getBarcosRestantesJugador() {
    return turno == 1 ? barcosRestantesJugador1 : barcosRestantesJugador2;
  }

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

  String getGanador() {
    return perfilJugador.name;
  }

  void reiniciarPartida() {
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
  }

  void setSession(String name, String email, String password, String token) {
    if (name != "") {
      perfilJugador.name = name;
      perfilJugador.email = email;
      perfilJugador.password = password;
      tokenSesion = token;
      perfilJugador.updateState();
      print("PONGO EL PERFIL A $name ${perfilJugador.name} ${perfilJugador.email} ${perfilJugador.password}");
      print("PERFIL JUGADOR: ${perfilJugador.name} ${perfilJugador.email} ${perfilJugador.password}");
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// AUXILIAR /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

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

  List<Barco> obtenerBarcosRestantes() {
    List<Barco> barcosRestantes = [];
    bool hundido = false;
    for (var barco in Juego().tablero_jugador1.barcos) {
      hundido = false;
      print("NOMBRE BARCO: ${barco.nombre}");
      for (var barcoHundido in Juego().barcosHundidosPorJugador) {
        print("NOMBRE BARCO HUNDIDO: ${barcoHundido.nombre}");
        if (barcoHundido.nombre.toLowerCase() == barco.nombre.toLowerCase()) {
          print("DETECTO HUNDIDO");
          hundido = true;
          break;
        }
      }
      if (!hundido) {
        print("LO AÑADO A BARCOS RESTANTES");
        barcosRestantes.add(barco);
      }
    }
    return barcosRestantes;
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

  Barco buscarBarcoHundido(Map<String, dynamic> datosJuego) {
    List<dynamic> coordenadas = datosJuego['coordenadas'];
    String tipo = datosJuego['tipo'];

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// PARTIDA VS IA //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  Future<void> actualizarEstadoJugador() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlMostrarTableroEnemigo),
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
      print("ACTUALIZAR ESTADO Jugador:");
      print(data);

      if (data.containsKey('misDisparos')) {
        var misDisparos = data['misDisparos'] as List;
        for (var disparo in misDisparos) {
          double i = disparo['i'].toDouble();
          double j = disparo['j'].toDouble();
          if (disparo['estado'] == 'Agua') {
            disparosFalladosJugador.add(Offset(i, j));
          } else {
            disparosAcertadosJugador.add(Offset(i, j));
          }
        }
      }

      if (data.containsKey('barcosHundidos')) {
        var barcosHundidosPorMi = data['barcosHundidos'] as List;
        for (var barco in barcosHundidosPorMi) {
          decrementarBarcosRestantesOponente();
          Barco barcoHundido = buscarBarcoHundido(barco);
          barcosHundidosPorJugador.add(barcoHundido);
        }
      }
    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Future<void> actualizarEstadoOponente() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlMostrarMiTablero),
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
      print("ACTUALIZAR ESTADO Oponente:");
      print(data);
      print(data.runtimeType);

      if (data.containsKey('disparosEnemigos')) {
        var disparosEnemigos = data['disparosEnemigos'] as List;
        for (var disparo in disparosEnemigos) {
          double i = disparo['i'].toDouble();
          double j = disparo['j'].toDouble();
          if (disparo['estado'] == 'Agua') {
            disparosFalladosOponente.add(Offset(i, j));
          } else {
            disparosAcertadosOponente.add(Offset(i, j));
          }
        }
      }

      print("AÑADIENDO BARCOS HUNDIDOS POR IA:");
      if (data.containsKey('barcosHundidos')) {
        var barcosHundidosPorMi = data['barcosHundidos'] as List;
        for (var barco in barcosHundidosPorMi) {
          decrementarBarcosRestantesJugador();
          Barco barcoHundido = buscarBarcoHundido(barco);
          barcosHundidosPorOponente.add(barcoHundido);
          barcoHundido.showInfo();
        }
      }
      print("FIN AÑADIENDO BARCOS HUNDIDOS POR IA:");
    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Future<void> cargarPartida() async {
    tablero_jugador1.barcos = await obtenerBarcos(AuthProvider().name);
    if (codigo != -1) {
      print("VOY A ACTUALIZAR ESTADO JUGADOR");
      await actualizarEstadoJugador();
      print("VOY A ACTUALIZAR ESTADO OPONENTE");
      await actualizarEstadoOponente();
      print("HE CARGADO LA PARTIDA");
      print("DISPAROS FALLADOS JUGADOR:");
      print(disparosFalladosJugador);
      print("DISPAROS ACERTADOS JUGADOR:");
      print(disparosAcertadosJugador);
      print("DISPAROS FALLADOS OPONENTE:");
      print(disparosFalladosOponente);
      print("DISPAROS ACERTADOS OPONENTE:");
      print(disparosAcertadosOponente);
    }
  }

  Future<List<Barco>> obtenerBarcos(String usuario) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlObtenerTablero),
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
  
  Future<void> crearPartida() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlCrearPartida),
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
    print("AL CREAR PARTIDA: ");
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

  Future<void> abandonarPartida(BuildContext context) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlAbandonarPartida),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': codigo,
        'nombreId': turno,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      showErrorSnackBar(context, 'Has abandonado la partida');

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// PARTIDA MULTIPLAYER ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> crearPartidaMulti(String nombreJugador1, String nombreJugador2) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlCrearPartidaMulti),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenSesion',
      },
      body: jsonEncode(<String, String>{
        'nombreId1': nombreJugador1,
        'nombreId2': nombreJugador2,
        'bioma': 'Mediterraneo' ,
      }),
      
    );

    var data = jsonDecode(response.body);
    print("AL CREAR PARTIDA MULTI: ");
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

  Future<void> crearSala() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlCrearSala),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': Juego().perfilJugador.name,
        'bioma': 'Mediterraneo' ,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("CREAR SALA:");
      print(data);
      codigo = data['codigo'];

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Future<bool> buscarSala() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlCrearSala),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': Juego().perfilJugador.name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("BUSCAR SALA:");
      print(data);
      codigo = data['codigo'];
      return true;

    } else {
      return false;
    }
  }  
}