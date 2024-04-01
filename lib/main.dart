import 'package:battleship/colocarBarcos.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'authProvider.dart';
import 'comun.dart';
import 'botones.dart';
import 'destino.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final AuthProvider _authProvider = AuthProvider();

  Principal({super.key});

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
            buildHeader(context),
            const SizedBox(
              width: 250,
              height: 250,
              child: Image(image: AssetImage('images/portada.png')),
            ),
            const Spacer(),
            buildActionButton(context, () => _handleOnlinePressed(context, _authProvider), "Jugar Online"),
            const SizedBox(height: 10),
            buildActionButton(context, () => _handleOfflinePressed(context, _authProvider), "Jugar Offline"),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }
}

void _handleOnlinePressed(BuildContext context, AuthProvider authProvider) {
  DestinoManager.setDestino(const ColocarBarcos());
  if (!authProvider.isLoggedIn) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InicioSesion()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ColocarBarcos()),
    );
  }
}

void _handleOfflinePressed(BuildContext context, AuthProvider authProvider) {
  DestinoManager.setDestino(const ColocarBarcos());
  if (!authProvider.isLoggedIn) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InicioSesion()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ColocarBarcos()),
    );
  }
}
