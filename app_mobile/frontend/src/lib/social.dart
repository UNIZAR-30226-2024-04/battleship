import 'dart:convert';
import 'dart:async';
import 'package:battleship/botones.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';   
import 'juego.dart';

class Social extends StatefulWidget {
  Social({super.key});
  final TextEditingController _friendController = TextEditingController();

  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  ServerRoute serverRoute = ServerRoute();
  Juego juego = Juego();

  List<String> amigos = [];
  List<String> solicitudes = [];
  List<String> publicaciones = [];

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
                /*Expanded(
                  child: Column(
                    children: [
                      //buildText(),*/
                      buildEntryButton('Amigo', 'Introduzca el nombre de usuario', Icons.email, widget._friendController),
                      buildTabs(),
                      const Spacer(),
                      buildActions(context),
                  /*  ],
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    return Row(
      children: [
        buildEntryButton('Amigo', 'Introduzca el nombre de usuario', Icons.email, widget._friendController),
      ],
    );
  }

  Widget buildTabs() {
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
                buildPosts(),       // Pestaña de publicaciones
                buildFriends(),     // Pestaña de amigos
                buildRequests(),    // Pestaña de solicitudes de amistad
                buildChats(),       // Pestaña de mensajes
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Pestaña de publicaciones
  Widget buildPosts() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListView.builder(
          itemCount: publicaciones.length,
          itemBuilder: (context, index) {
              return ListTile(
                title: Text(publicaciones[index]),
                leading: CircleAvatar(
                  //backgroundImage: const AssetImage('images/avatar.png'),
                  child: Text(publicaciones[index][0]),
                ),
                onTap: () {
                  //Al pulsar una publicacion
                  print('Pulsado ${publicaciones[index]}');
                }
              );
            },
        ),
      ),
    );
  }

  //Función para obtener las publicaciones
  Future<List<String>> obtenerPublicaciones(int tipoPost, int nivel, int trofeos, int pGanadas, int pJugadas, int torneos) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlObtenerPublicacion),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String,String>{
        'nombreId': Juego().miPerfil.name,
        'tipoPublicacion': tipoPost.toString(),
        'nivel': nivel.toString(),
        'trofeos': trofeos.toString(),
        'partidasGanadas': pGanadas.toString(),
        'partidasJugadas': pJugadas.toString(),
        'torneos': torneos.toString(),
      }),
    );

    if (response.statusCode == 200) {
      // Si obtiene datos
      var data = jsonDecode(response.body);
      print('Respuesta del servidor obtenerPublicaciones: $data');
      
      setState(() {
        publicaciones = List<String>.from(data);
      });
      return publicaciones;
    } else {
      // Si hay algún error
      throw Exception('Obtener publicaciones ha fallado');
    }
  }

  // Pestaña de amigos
  Widget buildFriends() {
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
                leading: CircleAvatar(
                  //backgroundImage: const AssetImage('images/avatar.png'),
                  child: Text(amigos[index][0]),
                ),
                onTap: () {
                  //Al pulsar un amigo
                  print('Pulsado ${amigos[index]}');
                }
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
        'nombreIdAmigo': nombreAmigo,
      }),
    );

    if (response.statusCode == 200) {
      // Si obtiene datos
      var data = jsonDecode(response.body);
      print('Respuesta del servidor obtenerAmigos: $data');

      //eliminar amigo
      amigos.remove(nombreAmigo);
      return amigos;
    } else {
      // Si hay algún error
      throw Exception('Obtener amigos ha fallado');
    }
  }


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
      print('Respuesta del servidor obtenerAmigos: $data');

      //añadir amigo
      amigos.add(nombreAmigo);
      return amigos;
    } else {
      // Si hay algún error
      throw Exception('Obtener amigos ha fallado');
    }
  } 

  // Pestaña de solicitudes de amistad
  Widget buildRequests() {
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

    print('STATUS CODE: ${response.statusCode}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
    
      setState(() {
        solicitudes = List<String>.from(data);
      });
      return solicitudes;
    }
    else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Widget buildChats() {
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
