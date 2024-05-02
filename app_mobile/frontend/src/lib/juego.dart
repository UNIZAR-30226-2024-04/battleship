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
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'mazo.dart';

class Juego {
  Tablero miTablero = Tablero();
  int numBarcos = 5;
  int misBarcosRestantes = 5;
  int barcosRestantesRival = 5;
  int ganador = 0;
  Perfil miPerfil = Perfil();     // perfil del jugador con sesión iniciada
  int disparosPendientes = 1; // disparo básico 1. Habilidades depende
  int codigo = -1;                // código de la partida
  String tokenSesion = '';        // token de la sesión
  List<Offset> disparosAcertadosPorMi = [];
  List<Offset> disparosAcertadosRival = [];
  List<Offset> disparosFalladosPorMi = [];
  List<Offset> disparosFalladosRival = [];
  List<Barco> barcosHundidosPorMi = [];
  List<Barco> barcosHundidosPorRival = [];
  String modalidadPartida = '';
  ServerRoute serverRoute = ServerRoute();
  final socket = IO.io('http://localhost:8080', <String, dynamic>{
    'transports': ['websocket'],
  });
  bool anfitrion = true;
  List<Habilidad> habilidades = [];
  int indiceHabilidadSeleccionadaEnTurno = -1;
  Map<String, bool> selectedAbilities = {
    'rafaga': false,
    'torpedo': false,
    'sonar': false,
    'mina': false,
    'misil': false,
  };

  // Instancia privada y estática del singleton
  static final Juego _singleton = Juego._internal();

  // Constructor privado
  Juego._internal() {
    socket.on('connect', (_) {
      print('connect');
    });
  }

  // Método para obtener la instancia del singleton
  factory Juego() {
    return _singleton;
  }


  @override
  void dispose() {
    //socket.disconnect();
    //super.dispose();
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// MÉTODOS DE LA CLASE ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
  bool juegoTerminado() {
    if (misBarcosRestantes == 0) {
      ganador = 2;
      return true;
    }
    if (barcosRestantesRival == 0) {
      ganador = 1;
      return true;
    }
    return false;
  }

  String getGanador() {
    return miPerfil.name;
  }

  void reiniciarPartida() {
    numBarcos = 5;
    misBarcosRestantes = numBarcos;
    barcosRestantesRival = numBarcos;
    ganador = 0;
    codigo = -1;
    disparosAcertadosPorMi = [];
    disparosAcertadosRival = [];
    disparosFalladosPorMi = [];
    disparosFalladosRival = [];
    barcosHundidosPorMi = [];
    barcosHundidosPorRival = [];
    anfitrion = true;
    if(modalidadPartida == 'COMPETITIVA' || modalidadPartida == 'AMISTOSA') {
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    }
  }

  void setSession(String name, String email, String password, String token) {
    if (name != "") {
      miPerfil.name = name;
      miPerfil.email = email;
      miPerfil.password = password;
      tokenSesion = token;
      miPerfil.updateState();
    }
  }

  Future<void> actualizarMazo() async {
    habilidades = Mazo().getSelectedAbilities();
    var mazoHabilidades = [];
    habilidades.forEach((habilidad) {
      switch (habilidad.nombre) {
        case 'rafaga':
          mazoHabilidades.add('Rafaga');
          break;
        case 'torpedo':
          mazoHabilidades.add('Recargado');
          break;
        case 'sonar':
          mazoHabilidades.add('Sonar');
          break;
        case 'mina':
          mazoHabilidades.add('Mina');
          break;
        case 'misil':
          mazoHabilidades.add('Teledirigido');
          break;
      }
    });

    var response = await http.post(
      Uri.parse(serverRoute.urlModificarMazo),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': Juego().miPerfil.name,
        'mazoHabilidades': mazoHabilidades ,
      }),
    );

    if (response.statusCode == 200) {
      print("MAZO ACTUALIZADO CORRECTAMENTE");
    } else {
      throw Exception('La solicitud ha fallado');
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
    dx = dx + height / Juego().miTablero.casillaSize > Juego().miTablero.numFilas ? Juego().miTablero.numFilas - height / Juego().miTablero.casillaSize : dx;
    dy = dy + width / Juego().miTablero.casillaSize > Juego().miTablero.numColumnas ? Juego().miTablero.numColumnas - width / Juego().miTablero.casillaSize : dy;

    return Offset(dx, dy);
  }

  List<Barco> obtenerBarcosRestantesRival() {
    List<Barco> barcosRestantes = [];
    bool hundido = false;
    for (var barco in Juego().miTablero.barcos) {
      hundido = false;
      for (var barcoHundido in Juego().barcosHundidosPorMi) {
        if (barcoHundido.nombre.toLowerCase() == barco.nombre.toLowerCase()) {
          hundido = true;
          break;
        }
      }
      if (!hundido) {
        barcosRestantes.add(barco);
      }
    }
    return barcosRestantes;
  }

  List<Barco> obtenerMisBarcosRestantes() {
    List<Barco> barcosRestantes = [];
    bool hundido = false;
    for (var barco in Juego().miTablero.barcos) {
      hundido = false;
      for (var barcoHundido in Juego().barcosHundidosPorRival) {
        if (barcoHundido.nombre.toLowerCase() == barco.nombre.toLowerCase()) {
          hundido = true;
          break;
        }
      }
      if (!hundido) {
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
        'nombreId': Juego().miPerfil.name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data.containsKey('misDisparos')) {
        var misDisparos = data['misDisparos'] as List;
        for (var disparo in misDisparos) {
          double i = disparo['i'].toDouble();
          double j = disparo['j'].toDouble();
          if (disparo['estado'] == 'Agua') {
            disparosFalladosPorMi.add(Offset(i, j));
          } else {
            disparosAcertadosPorMi.add(Offset(i, j));
          }
        }
      }

      if (data.containsKey('barcosHundidos')) {
        var barcosHundidosPorMi = data['barcosHundidos'] as List;
        for (var barco in barcosHundidosPorMi) {
          barcosRestantesRival--;
          Barco barcoHundido = buscarBarcoHundido(barco);
          barcosHundidosPorMi.add(barcoHundido);
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
        'nombreId': Juego().miPerfil.name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data.containsKey('disparosEnemigos')) {
        var disparosEnemigos = data['disparosEnemigos'] as List;
        for (var disparo in disparosEnemigos) {
          double i = disparo['i'].toDouble();
          double j = disparo['j'].toDouble();
          if (disparo['estado'] == 'Agua') {
            disparosFalladosRival.add(Offset(i, j));
          } else {
            disparosAcertadosRival.add(Offset(i, j));
          }
        }
      }

      if (data.containsKey('barcosHundidos')) {
        var barcosHundidosPorMi = data['barcosHundidos'] as List;
        for (var barco in barcosHundidosPorMi) {
          misBarcosRestantes--;
          Barco barcoHundido = buscarBarcoHundido(barco);
          barcosHundidosPorRival.add(barcoHundido);
        }
      }
    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Future<void> cargarPartida() async {
    miTablero.barcos = await obtenerBarcos(AuthProvider().name);
    if (codigo != -1) {
      await actualizarEstadoJugador();
      await actualizarEstadoOponente();
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
      print("BARCOS");
      print(data);

      var userMap = jsonDecode(response.body);

      var mazoHabilidades = userMap['mazoHabilidades'];
      habilidades = [];
      for (var habilidad in mazoHabilidades) {
        switch (habilidad) {
          case 'Rafaga':
            habilidades.add(Rafaga());
            break;
          case 'Recargado':
            habilidades.add(Torpedo());
            break;
          case 'Sonar':
            habilidades.add(Sonar());
            break;
          case 'Mina':
            habilidades.add(Mina());
            break;
          case 'Teledirigido':
            habilidades.add(Misil());
            break;
        }
      }

      int codigoPartida = userMap['codigoPartidaActual'];
      if (codigoPartida != -1) {
        codigo = codigoPartida;
      }

      List<dynamic> tableroInicial = userMap['tableroInicial'];
      List<List<Offset>> coordenadas = getCoordinates(tableroInicial);
      List<String> nombres = getNames(tableroInicial);
      List<bool> barcosHundidos = obtenerHundidos(tableroInicial);

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

      if(data['fueraTablero'] == false && data['colisiona'] == false) {
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
        'nombreId1': miPerfil.name,
        'bioma': 'Mediterraneo' ,
      }),
      
    );

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      codigo = data['codigo'];

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Future<void> abandonarPartida(BuildContext context) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlAbandonarPartida),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenSesion',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': codigo,
        'nombreId': miPerfil.name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
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
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      codigo = data['codigo']; 

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
        'nombreId': Juego().miPerfil.name,
        'bioma': 'Mediterraneo' ,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      codigo = data['codigo'];
      socket.emit('entrarSala', codigo);

      var completer = Completer();

      socket.on('partidaEncontrada', (data) {
        print('Partida encontrada: $data');
        if (!completer.isCompleted) {
          completer.complete();
        }
      });

      await completer.future;
    } else {
      throw Exception('La solicitud ha fallado');
    }
  }


  Future<bool> buscarSala() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlBuscarSala),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': Juego().miPerfil.name,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      codigo = data['codigo'];
      if (codigo == -1) {
        return false;
      }
      socket.emit('entrarSala', codigo);
      return true;

    } else {
      return false;
    }
  }  
}