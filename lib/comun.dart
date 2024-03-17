import 'package:flutter/material.dart';
import 'habilidades.dart';
import 'flota.dart';
import 'ajustes.dart';
import 'main.dart';
import 'social.dart';
import 'perfil.dart';

// Panel superior.
Widget buildHeader(BuildContext context) {
  return Row(
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Image(
          image: AssetImage('images/logo.png'),
          width: 100,
          height: 100,
          alignment: Alignment.topLeft,
        ),
      ),
      const Spacer(),
      Transform.translate(
        offset: const Offset(0, -20),
        child: const Image(
          image: AssetImage('images/battleship.png'),
          width: 150,
          height: 150,
          alignment: Alignment.center,
        ),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Perfil()),
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
              MaterialPageRoute(builder: (context) => const Ajustes()),
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