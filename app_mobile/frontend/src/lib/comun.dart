import 'package:battleship/authProvider.dart';
import 'package:battleship/destino.dart';
import 'package:flutter/material.dart';
import 'habilidades.dart';
import 'flota.dart';
import 'juego.dart';
import 'social.dart';

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
              if (ModalRoute.of(context)?.settings.name == '/Perfil') {
                print("RUTA: /Perfil");
                return;
              }

              DestinoManager.setDestino(Juego().perfilJugador);

              if (!AuthProvider().isLoggedIn) {
                Navigator.pushNamed(context, '/InicioSesion');
              } else {
                Navigator.pushNamed(context, '/Perfil');
              }
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem('Jugar', 'images/jugar.png', () {
            Navigator.pushNamed(context, '/Principal');
          }),
          _buildActionItem('Habilidades', 'images/habilidad.png', () {
            if (ModalRoute.of(context)?.settings.name == '/Habilidades') {
              print("RUTA: /Habilidades");
              return;
            }

            DestinoManager.setDestino(Habilidades());

            if (!AuthProvider().isLoggedIn) {
              Navigator.pushNamed(context, '/InicioSesion');
            } else {
              Navigator.pushNamed(context, '/Habilidades');
            }
          }),
          _buildActionItem('Flota', 'images/flota.png', () {
            if (ModalRoute.of(context)?.settings.name == '/Flota') {
              print("RUTA: /Flota");
              return;
            }

            DestinoManager.setDestino(const Flota());

            if (!AuthProvider().isLoggedIn) {
              Navigator.pushNamed(context, '/InicioSesion');
            } else {
              Navigator.pushNamed(context, '/Flota');
            }
          }),
          _buildActionItem('Social', 'images/social.png', () {
            if (ModalRoute.of(context)?.settings.name == '/Social') {
              print("RUTA: /Social");
              return;
            }

            DestinoManager.setDestino(const Social());

            if (!AuthProvider().isLoggedIn) {
              Navigator.pushNamed(context, '/InicioSesion');
            } else {
              Navigator.pushNamed(context, '/Social');
            }
          }),
          _buildActionItem('Ajustes', 'images/ajustes.png', () {
            if (ModalRoute.of(context)?.settings.name == '/Ajustes') {
              print("RUTA: /Ajustes");
              return;
            }
            Navigator.pushNamed(context, '/Ajustes');
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

bool isValidEmail(String email) {
  final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
  );
  return regex.hasMatch(email);
}

void showErrorSnackBar(BuildContext context, String message) {
  if (ScaffoldMessenger.of(context).mounted) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void showSuccessSnackBar(BuildContext context, String message) {
  if (ScaffoldMessenger.of(context).mounted) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.green),
      ),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}