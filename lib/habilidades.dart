import 'package:flutter/material.dart';
import 'social.dart';
import 'flota.dart';
import 'ajustes.dart';
import 'main.dart';
import 'perfil.dart';


class Habilidades extends StatelessWidget {
  const Habilidades({super.key});

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


          const SizedBox(height: 50),
          const Text(
            'Habilidades',
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



          const SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(), // Forma totalmente redonda
                            padding: const EdgeInsets.all(20), // Tamaño del botón
                            backgroundColor: Colors.black.withOpacity(0.5), // Fondo oscuro y transparente
                          ),
                          child: const Image(
                            image: AssetImage('images/rafaga.png'), // Ruta de la imagen
                            width: 50, // Ancho de la imagen
                            height: 50, // Alto de la imagen
                          ),
                        ),
                        const SizedBox(height: 5), // Espaciado entre el botón y el texto
                        const Text('Ráfaga', style: TextStyle(color: Colors.white)), // Texto debajo del botón
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(), // Forma totalmente redonda
                            padding: const EdgeInsets.all(20), // Tamaño del botón
                            backgroundColor: Colors.black.withOpacity(0.5), // Fondo oscuro y transparente
                          ),
                          child: const Image(
                            image: AssetImage('images/torpedo.png'), // Ruta de la imagen
                            width: 50, // Ancho de la imagen
                            height: 50, // Alto de la imagen
                          ),
                        ),
                        const SizedBox(height: 5), // Espaciado entre el botón y el texto
                        const Text('Torpedo', style: TextStyle(color: Colors.white)), // Texto debajo del botón
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(), // Forma totalmente redonda
                            padding: const EdgeInsets.all(20), // Tamaño del botón
                            backgroundColor: Colors.black.withOpacity(0.5), // Fondo oscuro y transparente
                          ),
                          child: const Image(
                            image: AssetImage('images/sonar.png'), // Ruta de la imagen
                            width: 50, // Ancho de la imagen
                            height: 50, // Alto de la imagen
                          ),
                        ),
                        const SizedBox(height: 5), // Espaciado entre el botón y el texto
                        const Text('Sonar', style: TextStyle(color: Colors.white)), // Texto debajo del botón
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Espaciado entre las filas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(), // Forma totalmente redonda
                            padding: const EdgeInsets.all(20), // Tamaño del botón
                            backgroundColor: Colors.black.withOpacity(0.5), // Fondo oscuro y transparente
                          ),
                          child: const Image(
                            image: AssetImage('images/mina.png'), // Ruta de la imagen
                            width: 50, // Ancho de la imagen
                            height: 50, // Alto de la imagen
                          ),
                        ),
                        const SizedBox(height: 5), // Espaciado entre el botón y el texto
                        const Text('Mina', style: TextStyle(color: Colors.white)), // Texto debajo del botón
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(), // Forma totalmente redonda
                            padding: const EdgeInsets.all(20), // Tamaño del botón
                            backgroundColor: Colors.black.withOpacity(0.5), // Fondo oscuro y transparente
                          ),
                          child: const Image(
                            image: AssetImage('images/misil.png'), // Ruta de la imagen
                            width: 50, // Ancho de la imagen
                            height: 50, // Alto de la imagen
                          ),
                        ),
                        const SizedBox(height: 5), // Espaciado entre el botón y el texto
                        const Text('Misil', style: TextStyle(color: Colors.white)), // Texto debajo del botón
                      ],
                    ),
                  ],
                ),
              ],
          ),


          const SizedBox(height: 210), // Ajuste de espacio entre las filas
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