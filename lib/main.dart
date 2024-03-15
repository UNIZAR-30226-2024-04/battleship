import 'package:flutter/material.dart';
import 'social.dart';
import 'login.dart';
import 'habilidades.dart';
import 'flota.dart';
import 'ajustes.dart';
import 'authProvider.dart';
import 'jugar.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Principal(),
      ),
    );
  }
}


class Principal extends StatelessWidget {
  AuthProvider _authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/fondo.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: 10), // Ajuste de espacio para mover las imágenes más arriba
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20), // Añade sangría a la izquierda
                  child: Image(
                    image: AssetImage('images/logo.png'),
                    width: 100,
                    height: 100,
                    alignment: Alignment.topLeft,
                  ),
                ),
                Spacer(),
                Transform.translate(
                  offset: Offset(0, -20), // Ajusta la posición vertical de la imagen "battleship"
                  child: Image(
                    image: AssetImage('images/battleship.png'),
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 20), // Añade sangría a la derecha
                  child: Image(
                    image: AssetImage('images/perfil.png'),
                    width: 100,
                    height: 100,
                    alignment: Alignment.topRight,
                  ),
                ),
              ],
          ),


                      
            SizedBox(height: 200), // Espacio entre los botones y las imágenes
            Stack(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Bordes redondeados
                    ),
                    backgroundColor: Colors.orange, // Color del botón
                    minimumSize: Size(250, 60), // Tamaño del botón
                    elevation: 8, // Sombras elevadas
                  ),
                  child: Text('Jugar Online', style: TextStyle(color: Colors.white)),
                ),
                Positioned(
                  bottom: -10.0, // Ajuste para que sobresalga de la pantalla
                  right: -10.0, // Ajuste para que sobresalga de la pantalla
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_authProvider.isLoggedIn) { // el usuario no está logueado
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InicioSesion()),
                        );
                      }
                      else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Jugar()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Bordes redondeados
                      ),
                      backgroundColor: Colors.orange,
                      minimumSize: Size(270, 80), // Aumenta el tamaño para que sobresalga
                      elevation: 10, // Sombras elevadas más pronunciadas
                    ),
                    child: Text('Jugar Online', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Espacio entre los botones
            Stack(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Bordes redondeados
                    ),
                    backgroundColor: Colors.orange, // Color del botón
                    minimumSize: Size(250, 60), // Tamaño del botón
                    elevation: 8, // Sombras elevadas
                  ),
                  child: Text('Jugar Offline', style: TextStyle(color: Colors.white)),
                ),
                Positioned(
                  bottom: -10.0, // Ajuste para que sobresalga de la pantalla
                  right: -10.0, // Ajuste para que sobresalga de la pantalla
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_authProvider.isLoggedIn) { // el usuario no está logueado
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InicioSesion()),
                        );
                      }
                      else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Jugar()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Bordes redondeados
                      ),
                      backgroundColor: Colors.orange,
                      minimumSize: Size(270, 80), // Aumenta el tamaño para que sobresalga
                      elevation: 10, // Sombras elevadas más pronunciadas
                    ),
                    child: Text('Jugar Offline', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 270), // Ajuste de espacio entre las filas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset('images/jugar.png', width: 50, height: 50),
                      ),
                      Text('Jugar', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Habilidades()),
                          );
                        },
                        child: Image.asset('images/habilidad.png', width: 50, height: 50),
                      ),
                      Text('Habilidades', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Flota()),
                          );
                        },
                        child: Image.asset('images/flota.png', width: 50, height: 50),
                      ),
                      Text('Flota', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Social()),
                          );
                        },
                        child: Image.asset('images/social.png', width: 50, height: 50),
                      ),
                      Text('Social', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Ajustes()),
                          );
                        },
                        child: Image.asset('images/ajustes.png', width: 50, height: 50),
                      ),
                      Text('Ajustes', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}