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
import 'perfil.dart';


class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final AuthProvider _authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/fondo.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(height: 10), // Ajuste de espacio para mover las imágenes más arriba
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20), // Añade sangría a la izquierda
                  child: Image(
                    image: AssetImage('images/logo.png'),
                    width: 100,
                    height: 100,
                    alignment: Alignment.topLeft,
                  ),
                ),
                const Spacer(),
                Transform.translate(
                  offset: const Offset(0, -20), // Ajusta la posición vertical de la imagen "battleship"
                  child: const Image(
                    image: AssetImage('images/battleship.png'),
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20), // Añade sangría a la derecha
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Perfil()), // Reemplaza NuevaPantalla() por la pantalla a la que deseas navegar
                      );
                    },
                    child: const Image(
                      image: AssetImage('images/perfil.png'),
                      width: 100,
                      height: 100,
                      alignment: Alignment.topRight,
                    ),
                  ),
                ),
              ],
          ),



          const Text(
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


        const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
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
                  suffixIcon: const Icon(Icons.email),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
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
                  suffixIcon: const Icon(Icons.lock),
                ),
              ),
            ),
          ),



          GestureDetector(
            onTap: () {
              // Navegar a la nueva pantalla cuando se pulsa el texto
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecuperacionContrasena()),
              );
            },
            child: const Text(
              'Olvidé la contraseña',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 16.0, // Tamaño del texto
              ),
            ),
          ),


          // Checkbox
          const SizedBox(height: 20.0),
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
              const SizedBox(width: 8.0),
              const Text(
                'Recordarme',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),


          const SizedBox(height: 20), // Espacio entre los botones
            Stack(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Bordes redondeados
                    ),
                    backgroundColor: Colors.orange, // Color del botón
                    minimumSize: const Size(250, 60), // Tamaño del botón
                    elevation: 8, // Sombras elevadas
                  ),
                  child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
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
                      minimumSize: const Size(270, 80), // Aumenta el tamaño para que sobresalga
                      elevation: 10, // Sombras elevadas más pronunciadas
                    ),
                    child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),





          const SizedBox(height: 20), // Espacio entre los botones    
          GestureDetector(
            onTap: () {
              // Navegar a la nueva pantalla cuando se pulsa el texto
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Registro()),
              );
            },
            child: const Text(
              '¿No tienes una cuenta? Regístrate',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 16.0, // Tamaño del texto
              ),
            ),
          ),








            const SizedBox(height: 185), // Ajuste de espacio entre las filas
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
                      const Text('Jugar', style: TextStyle(color: Colors.white)),
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
                            MaterialPageRoute(builder: (context) => const Habilidades()),
                          );
                        },
                        child: Image.asset('images/habilidad.png', width: 50, height: 50),
                      ),
                      const Text('Habilidades', style: TextStyle(color: Colors.white)),
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
                            MaterialPageRoute(builder: (context) => const Flota()),
                          );
                        },
                        child: Image.asset('images/flota.png', width: 50, height: 50),
                      ),
                      const Text('Flota', style: TextStyle(color: Colors.white)),
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
                            MaterialPageRoute(builder: (context) => const Social()),
                          );
                        },
                        child: Image.asset('images/social.png', width: 50, height: 50),
                      ),
                      const Text('Social', style: TextStyle(color: Colors.white)),
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
                            MaterialPageRoute(builder: (context) => const Ajustes()),
                          );
                        },
                        child: Image.asset('images/ajustes.png', width: 50, height: 50),
                      ),
                      const Text('Ajustes', style: TextStyle(color: Colors.white)),
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

