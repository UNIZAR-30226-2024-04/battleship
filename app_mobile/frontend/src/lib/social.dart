import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'botones.dart';
import 'comun.dart';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';   
import 'juego.dart';
import 'perfilOtro.dart';

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
  List<String> textoPublicaciones = [];
  List<String> usuarioPublicaciones = [];
  

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    try {
      await obtenerPublicaciones();
      await obtenerAmigos();
      await obtenerSolicitudes();
    } catch (e) {
      print("Error al obtener solicitudes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Juego().colorFondo,
            ),
            child: Column(
              children: [
                buildHeader(context),
                Expanded(
                  child: construirPestanas(),
                ),
                buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget construirPestanas() {
    return Container(
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
              Tab(icon: Icon(Icons.web_stories_rounded)),
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.person_add_alt_1)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                construirPublicaciones(),
                construirAmigos(),
                construirSolicitudes(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget construirPublicaciones() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: usuarioPublicaciones.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      usuarioPublicaciones[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textoPublicaciones[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
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

      if (data != null) {
        setState(() {
          for (var publicacion in data) {
            usuarioPublicaciones.add(publicacion['usuario']);
            textoPublicaciones.add(publicacion['texto']);
          }
        });
      }
    } else {
      // Si hay algún error
      throw Exception('Obtener publicaciones ha fallado');
    }
  }

  Widget construirAmigos() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: amigos.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildAmigoCard(amigos[index]);
          },
        ),
      ),
    );
  }

  Widget _buildAmigoCard(String nombreAmigo) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          nombreAmigo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.lightBlue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilOtroUsuario(nombreUsuario: nombreAmigo),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Eliminar amigo
                eliminarAmigo(nombreAmigo);
              },
            ),
          ]
        ),
      ),
    );
  }

  // Función para añadir un amigo
  Future<List<String>> agnadirAmigo(String nombreAmigo) async {
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
      setState(() {
        amigos = List<String>.from(data);
      });
    } else {
      // Si hay algún error
      throw Exception('Obtener amigos ha fallado');
    }
  }

  Future<bool> enviarSolicitud(String nombreAmigo) async {
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
      return true;   
    } else {
      // Si hay algún error
      return false;
    }
  } 

  // Funcion que llama a eliminarSolicitudAmistad de backend
  Future<void> eliminarSolicitudAmistad(String nombreAmigo) async {
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
    } else {
      // Si hay algún error
      throw Exception('Eliminar Solicitud ha fallado');
    }
  }

  Widget construirSolicitudes() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: buildEntryButton('Nombre amigo', 'Introduzca el nombre del amigo', Icons.person, _nameController),
          ),
          const SizedBox(height: 20),
          Center(
            child: buildActionButton(context, () {
              enviarSolicitud(_nameController.text);
              showSuccessSnackBar(context, 'Solicitud enviada a ${_nameController.text}');
            }, 'Enviar solicitud'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: List.generate(solicitudes.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(solicitudes[index], style: const TextStyle(fontSize: 18)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Color.fromARGB(255, 10, 125, 14)),
                              onPressed: () {
                                // Añadir amigo
                                agnadirAmigo(solicitudes[index]);
                                // Eliminar la solicitud de la lista
                                setState(() {
                                  solicitudes.removeAt(index);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Eliminar solicitud
                                eliminarSolicitudAmistad(solicitudes[index]);
                                // Eliminar la solicitud de la lista
                                setState(() {
                                  solicitudes.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        solicitudes = List<String>.from(data);
      });
    }
    else {
      throw Exception('La solicitud ha fallado');
    }
  }
}