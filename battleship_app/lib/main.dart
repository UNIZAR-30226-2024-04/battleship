import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyBackgroundScreen(),
      ),
    );
  }
}

class MyBackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/fondo.jpg'), // Reemplaza con la ruta de tu imagen
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('images/logo.png'),
            //fit: BoxFit.cover,
            width: 160,
            height: 160,
            alignment: Alignment.topLeft,
          ),
          toolbarHeight: 100,
          // Personaliza la barra de navegación según tus necesidades
        ),
        body: Center(
          /*child: ElevatedButton(
              onPressed: () {
                // Acción a realizar cuando se presiona el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Cambia a amarillo
                elevation: 5, // Añadir sombra al botón
              ),
              
              child: Text('Jugar Online'),
          ),*/
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: (){
                  // Acción a realizar cuando se presiona el botón
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondScreen()),
                  );
                },      
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Cambia a amarillo
                  elevation: 5, // Añadir sombra al botón
                ),
                child: Text('Jugar online'),
              ),
              SizedBox(height: 20), // Espacio entre los botones
              ElevatedButton(
                onPressed: (){
                  // Acción a realizar cuando se presiona el botón
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Cambia a amarillo
                  elevation: 5, // Añadir sombra al botón
                ),
                child: Text('Jugar offline'),
              ),
            ],
          ),
        ),
      )
    );
  }
}


/*class MyBackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/fondo.jpg'), // Reemplaza con la ruta de tu imagen
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: (){
              // Acción a realizar cuando se presiona el botón
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen()),
              );
            },      
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Cambia a amarillo
              elevation: 5, // Añadir sombra al botón
            ),
            child: Text('Jugar online'),
          ),
          SizedBox(height: 20), // Espacio entre los botones
          ElevatedButton(
            onPressed: (){
              // Acción a realizar cuando se presiona el botón
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Cambia a amarillo
              elevation: 5, // Añadir sombra al botón
            ),
            child: Text('Jugar offline'),
          ),
        ],
      ),
    );
  }
}
*/



class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segunda Pantalla'),
      ),
      body: Center(
        child: Text('¡Has llegado a la segunda pantalla!'),
      ),
    );
  }
}