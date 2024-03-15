import 'package:flutter/material.dart';
import 'social.dart';
import 'habilidades.dart';
import 'flota.dart';
import 'ajustes.dart';
import 'registro.dart';
import 'recContrasena.dart';
import 'botones.dart';
import 'main.dart';
import 'authProvider.dart';


class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
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
                  offset: Offset(-120, -20),
                  child: Image(
                    image: AssetImage('images/battleship.png'),
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                  ),
                ),
              ],
           ),



          Text(
            'Iniciar Sesión',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5, // Espaciado entre letras
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),


          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: 300, // Ancho deseado
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Email',
                  hintText: 'Introduzca la dirección de correo',
                  suffixIcon: Icon(Icons.email),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: 300, // Ancho deseado
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Contraseña',
                  hintText: 'Introduzca la contraseña',
                  suffixIcon: Icon(Icons.lock),
                ),
              ),
            ),
          ),



          GestureDetector(
            onTap: () {
              // Navegar a la nueva pantalla cuando se pulsa el texto
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecuperacionContrasena()),
              );
            },
            child: Text(
              'Olvidé la contraseña',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 16.0, // Tamaño del texto
              ),
            ),
          ),


          // Checkbox
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomCheckbox(
                value: _rememberMe,
                onChanged: (bool value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
              ),
              SizedBox(width: 8.0),
              Text(
                'Recordarme',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),


          SizedBox(height: 20), // Espacio entre los botones
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
                  child: Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
                ),
                Positioned(
                  bottom: -10.0, // Ajuste para que sobresalga de la pantalla
                  right: -10.0, // Ajuste para que sobresalga de la pantalla
                  child: ElevatedButton(
                    onPressed: () {
                      if(_authProvider.authenticate(_emailController.text, _passwordController.text)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Principal()),
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
                    child: Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),





          SizedBox(height: 20), // Espacio entre los botones    
          GestureDetector(
            onTap: () {
              // Navegar a la nueva pantalla cuando se pulsa el texto
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Registro()),
              );
            },
            child: Text(
              '¿No tienes una cuenta? Regístrate',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 16.0, // Tamaño del texto
              ),
            ),
          ),








            SizedBox(height: 185), // Ajuste de espacio entre las filas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Principal()),
                          );
                        },
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

