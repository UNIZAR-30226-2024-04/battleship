import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'botones.dart';
import 'comun.dart';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';   
import 'juego.dart';

class Social extends StatefulWidget {
  const Social({super.key});

  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  ServerRoute serverRoute = ServerRoute();
  Juego juego = Juego();
  final TextEditingController _nameController = TextEditingController();
  List<String> amigos = [];
  List<String> solicitudes = [];
  List<String> idPublicaciones = [];
  List<String> textoPublicaciones = [];
  List<String> usuarioPublicaciones = [];
  

  @override
  void initState() {
    super.initState();
    List<String> solicitudes = [];
    print("OBTENER SOLICITUDES INICIAL: $solicitudes");
    _initAsync(); // Llamada a método auxiliar async
  }

  Future<void> _initAsync() async {
    try {
      await obtenerPublicaciones();
      construirPublicaciones();
      await obtenerAmigos();
      construirAmigos();
      await obtenerSolicitudes();
      print("Solicitudes tras obtener: $solicitudes");
      construirSolicitudes();
      construirMensajes();
    } catch (e) {
      // Manejar errores si es necesario
      print("Error al obtener solicitudes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/fondo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  buildHeader(context),
                  construirPestanas(),
                  const Spacer(),
                  buildActions(context),
                ],
              ),
            ),
          ),
        ),
      );
    }

  Widget construirPestanas() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                //Iconos para cada pestaña
                Tab(icon: Icon(Icons.web_stories_rounded)),
                Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.question_mark)),
                Tab(icon: Icon(Icons.message)),
              ],
            ),
            // Editar el contenido de cada pestaña
            Expanded(
              child: TabBarView(
                children: [
                  construirPublicaciones(),
                  construirAmigos(),
                  construirSolicitudes(),
                  construirMensajes(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Pestaña de publicaciones
  Widget construirPublicaciones() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  // Funcion de obtenerPublicaciones que llama a obtenerPublicaciones de backend
  Future<void> obtenerPublicaciones() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlObtenerPublicacionesAmigos),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String,String>{
        'nombreId': Juego().miPerfil.name,
      }),
    );

    if (response.statusCode == 200) {
      // Si obtiene datos
      var data = jsonDecode(response.body);
      print('Respuesta del servidor obtenerPublicaciones: $data');
      // si no es null
      if (data != null) {
        setState(() {
          idPublicaciones = List<String>.from(data['id']);
          textoPublicaciones = List<String>.from(data['texto']);
          usuarioPublicaciones = List<String>.from(data['usuario']);
        });
      }


    } else {
      // Si hay algún error
      throw Exception('Obtener publicaciones ha fallado');
    }
  }

  // Pestaña de amigos
  Widget construirAmigos() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ...List.generate(amigos.length, (index) => 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(amigos[index], style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Eliminar solicitud
                          eliminarAmigo(amigos[index]);
                        },
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para añadir un amigo
  Future<List<String>> agnadirAmigo(String nombreAmigo) async {
    print("EL AMIGO A AÑADIR ES: $nombreAmigo");
    var response = await http.post(
      Uri.parse(serverRoute.urlAgnadirAmigo),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String,String>{
        'nombreId': Juego().miPerfil.name,
        'nombreIdAmigo': nombreAmigo,
      }),
    );

    if (response.statusCode == 200) {
      // Si obtiene datos
      var data = jsonDecode(response.body);
      print('Respuesta del servidor añadir amigo: $data');
      
      setState(() {
        amigos = List<String>.from(data);
      });
      return amigos;
    } else {
      // Si hay algún error
      throw Exception('Añadir amigo ha fallado');
    }
  }

  // Función para obtener los amigos
  Future<void> obtenerAmigos() async {
    print("Llamamos a obtener amigos");
    var response = await http.post(
      Uri.parse(serverRoute.urlObtenerAmigos),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String,String>{
        'nombreId': Juego().miPerfil.name,
      }),
    );

    if (response.statusCode == 200) {
      // Si obtiene datos
      var data = jsonDecode(response.body);
      print('Respuesta del servidor obtenerAmigos: $data');
      
      setState(() {
        amigos = List<String>.from(data);
      });
    } else {
      // Si hay algún error
      throw Exception('Obtener amigos ha fallado');
    }
  }

  // Función para eliminar un amigo
  Future<void> eliminarAmigo(String nombreAmigo) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlEliminarAmigo),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String,String>{
        'nombreId': Juego().miPerfil.name,
        'nombreIdAmigo': nombreAmigo,
      }),
    );

    if (response.statusCode == 200) {
      // Si obtiene datos
      var data = jsonDecode(response.body);
      print('Respuesta del servidor eliminarAmigos: $data');
      
      setState(() {
        amigos = List<String>.from(data);
      });
    } else {
      // Si hay algún error
      throw Exception('Obtener amigos ha fallado');
    }
  }


  Future<void> enviarSolicitud(String nombreAmigo) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlEnviarSolicitudAmistad),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String,String>{
        'nombreId': Juego().miPerfil.name,
        'nombreIdAmigo': nombreAmigo,
      }),
    );

    if (response.statusCode == 200) {
      // Si obtiene datos
      var data = jsonDecode(response.body);
      print('Respuesta del servidor enviar solicitud: $data');
      
    } else {
      // Si hay algún error
      throw Exception('Enviar Solicitud ha fallado');
    }
  } 

  // Funcion que llama a eliminarSolicitudAmistad de backend
  Future<List<String>> eliminarSolicitudAmistad(String nombreAmigo) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlEliminarSolicitudAmistad),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String,String>{
        'nombreId': Juego().miPerfil.name,
        'nombreIdAmigo': nombreAmigo,
      }),
    );

    if (response.statusCode == 200) {
      // Si obtiene datos
      var data = jsonDecode(response.body);
      print('Respuesta del servidor eliminar solicitud: $data');
      
      return data;
    } else {
      // Si hay algún error
      throw Exception('Eliminar Solicitud ha fallado');
    }
  }

  // Pestaña de solicitudes de amistad, muestra las solicitudes de amistad pendientes 
  // Para ello llama a la función obtenerSolicitudes de backend
  Widget construirSolicitudes() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ...List.generate(solicitudes.length, (index) => 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(solicitudes[index], style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          // Añadir amigo
                          agnadirAmigo(solicitudes[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Eliminar solicitud
                          eliminarSolicitudAmistad(solicitudes[index]);
                        },
                      ),
                    ],
                  ),
                )
              ),
              SizedBox(height: 20),
              buildEntryButton('Nombre amigo', 'Introduzca el nombre del amigo', Icons.person, _nameController),
              buildActionButton(context, () {
                enviarSolicitud(_nameController.text);
                print('Envia solicitud a ${_nameController.text}');
              }, 'Enviar solicitud')
            ],
          ),
        ),
      ),
    );
  }

  Future<void> obtenerSolicitudes() async {
    var response = await http.post(
      Uri.parse(serverRoute.urlObtenerSolicitudAmistad),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String,String>{
        'nombreId': Juego().miPerfil.name,
      }),
    );

    print('STATUS CODE: ${response.statusCode}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('Solicitudes devuelta');
      print(data);
      setState(() {
        solicitudes = List<String>.from(data);
      });
    }
    else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Widget construirMensajes() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  
}