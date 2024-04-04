import 'package:flutter/material.dart';
import 'habilidades.dart';
import 'flota.dart';
import 'ajustes.dart';
import 'main.dart';
import 'social.dart';
import 'perfil.dart';

// Panel superior.
Widget buildHeader(BuildContext context) {
  return Transform.translate(
    offset: const Offset(0, 10),
    child: Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Image(
            image: AssetImage('images/logo.png'),
            width: 55,
            height: 55,
            alignment: Alignment.topLeft,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Perfil()),
              );
            },
            child: const Image(
              image: AssetImage('images/perfil.png'),
              width: 70,
              height: 70,
              alignment: Alignment.topRight,
            ),
          ),
        ),
      ],
    ),
  );
}


// Panel inferior.
Widget buildActions(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 70),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem('Jugar', 'images/jugar.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Principal()),
            );
          }),
          _buildActionItem('Habilidades', 'images/habilidad.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Habilidades()),
            );
          }),
          _buildActionItem('Flota', 'images/flota.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Flota()),
            );
          }),
          _buildActionItem('Social', 'images/social.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Social()),
            );
          }),
          _buildActionItem('Ajustes', 'images/ajustes.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Ajustes()),
            );
          }),
        ],
      ),
    ],
  );
}

Widget _buildActionItem(String label, String imagePath, void Function()? onTap) {
  return Expanded(
    child: Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}


Widget buildTitle(String text, int fontSize) {
  return Text(
    text,
    style: TextStyle(
      color: Colors.white,
      fontSize: fontSize.toDouble(),
      decoration: TextDecoration.none,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
      shadows: const [
        Shadow(
          blurRadius: 2.0,
          color: Colors.black,
          offset: Offset(2.0, 2.0),
        ),
      ],
    ),
  );
}

// Método que comprueba si una posicion pertenece a una matriz de posiciones
bool contiene(List<List<int>> lista, Offset posicion) {
  for (int i = 0; i < lista.length; i++) {
    if (lista[i][0] == posicion.dx && lista[i][1] == posicion.dy) {
      return true;
    }
  }
  return false;
}