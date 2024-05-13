import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
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

  List<String> amigos = [];
  List<String> solicitudes = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,    // Número de pestañas en la TabBar
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
                Expanded(
                  child: Column(
                    children: [
                      construirPestanas(),
                      const Spacer(),
                      buildActions(context),
                    ],
                  ),
                ),
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
            TabBar(
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
                  construirPublicaciones(),  // Pestaña de publicaciones
                  construirAmigos(),         // Pestaña de amigos
                  construirSolicitudes(),    // Pestaña de solicitudes de amistad
                  construirMensajes(),       // Pestaña de mensajes
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

  // Pestaña de amigos
  Widget construirAmigos() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListView.builder(
          itemCount: amigos.length,
          itemBuilder: (context, index) {
              return ListTile(
                title: Text(amigos[index]),
              );
            },
        ),
      ),
    );
  }

  // Función para obtener los amigos
  Future<List<String>> obtenerAmigos() async {
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
      return amigos;
    } else {
      // Si hay algún error
      throw Exception('Obtener amigos ha fallado');
    }
  }

  // Función para eliminar un amigo
  Future<List<String>> eliminarAmigo(String nombreAmigo) async {
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
      return amigos;
    } else {
      // Si hay algún error
      throw Exception('Obtener amigos ha fallado');
    }
  }

  // Pestaña de solicitudes de amistad
  Widget construirSolicitudes() {
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

  //CAMBIAR
  Future<List<String>> obtenerSolicitudes() async {
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

    print('STATUS CODE: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      

      return solicitudes;;
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
