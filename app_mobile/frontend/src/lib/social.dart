import 'package:flutter/material.dart';
import 'comun.dart';

class Social extends StatelessWidget {
  const Social({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,    // Número de pestañas en la TabBar
        child: Scaffold(
          //appBar: AppBar(
            //title: const Text('Social'),
          //),
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
                // Pestaña de publicaciones
                Column(
                  children: [
                    Text(
                      'Publicaciones',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    construirPublicaciones(), 
                  ]
                ),

                // Pestaña de amigos
                Column(
                  children: [
                    Text(
                      'Amigos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    construirAmigos(),  //Lista de amigos
                  ],
                ),
                // Pestaña de solicitudes de amistad
                Column(
                  children: [
                    Text(
                      'Solicitudes de amistad',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    construirSolicitudes(),   //Lista de solicitudes
                  ],
                ),
                // Pestaña de mensajes
                Column(
                  children: [
                    Text(
                      'Mensajes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    construirMensajes(),    //Lista de mensajes
                  ],
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }

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


  Widget construirAmigos() {
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
