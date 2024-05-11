import 'package:flutter/material.dart';
import 'comun.dart';

class Social extends StatelessWidget {
  const Social({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Social'),
          ),
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
        child: const Column(
          children: [
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(icon: Icon(Icons.message)),
                Tab(icon: Icon(Icons.people)),
              ],
            ),
            // Editar el contenido de cada pestaña
            Expanded(
              child: TabBarView(
              children: [
                // Pestaña de mensajes
                Column(
                  children: [
                    Text(
                      'Publicaciones',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
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
                    //Lista de mis publicaciones y las de mis amigos.
                  ],
                ),
              ],
            ),
            )
           
          ],
        ),
      ),
    );
  }
}