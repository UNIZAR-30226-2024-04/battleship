import 'package:battleship/defender.dart';
import 'package:battleship/registro.dart';
import 'package:flutter/material.dart';
import 'ajustes.dart';
import 'atacar.dart';
import 'flota.dart';
import 'mazo.dart';
import 'juego.dart';
import 'login.dart';
import 'authProvider.dart';
import 'comun.dart';
import 'botones.dart';
import 'destino.dart';
import 'recContrasena.dart';
import 'sala.dart';
import 'social.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Principal(),
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/InicioSesion':
            builder = (BuildContext _) => const InicioSesion();
            break;
          case '/Perfil':
            builder = (BuildContext _) => Juego().miPerfil;
            break;
          case '/Principal':
            builder = (BuildContext _) => Principal();
            break;
          case '/Flota':
            builder = (BuildContext _) => const Flota();
            break;
          case '/Mazo':
            builder = (BuildContext _) => Mazo();
            break;
          case '/Ajustes':
            builder = (BuildContext _) => const Ajustes();
            break;
          case '/Social':
            builder = (BuildContext _) => const Social();
            break;
          case '/Registrarse':
            builder = (BuildContext _) => Registro();
            break;
          case 'RecuperarContrasena':
            builder = (BuildContext _) => RecuperacionContrasena();
            break;
          case '/Atacar':
            builder = (BuildContext _) => const Atacar();
            break;
          case '/Defender':
            builder = (BuildContext _) => const Defender();
            break;
          case '/Destino':
            builder = (BuildContext _) => DestinoManager.getDestino();
            break;
          case '/Sala':
            builder = (BuildContext _) => const Sala();
            break;
          default:
            throw Exception('Ruta no definida');
        }
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration.zero, // Desactiva la animación de transición
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
        );
      },
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
            const SizedBox(height: 30),
            const SizedBox(
              width: 195,
              height: 195,
              child: Image(image: AssetImage('images/portada.png')),
            ),
            const Spacer(),
            buildActionButton(context, () => _handleCompetitivaPressed(context, _authProvider), "Partida Competitiva"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleAmistosaPressed(context, _authProvider), "Partida Amistosa"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleIndividualPressed(context, _authProvider), "Partida Individual"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleTorneoPressed(context, _authProvider), "Torneo"),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  void _handleCompetitivaPressed(BuildContext context, AuthProvider authProvider) {
    Juego().modalidadPartida = "COMPETITIVA";
    if (Juego().codigo != -1) {
      if (Juego().anfitrion) {
        DestinoManager.setDestino(const Atacar());
      }
      else {
        DestinoManager.setDestino(const Defender());
      }
    }
    else {
      DestinoManager.setDestino(const Sala());
    }
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/InicioSesion');
    } 
    else {
      Navigator.pushNamed(context, DestinoManager.getRutaDestino());
    }
  }

  void _handleAmistosaPressed(BuildContext context, AuthProvider authProvider) {
    Juego().modalidadPartida = "AMISTOSA";
    if (Juego().codigo != -1) {
      if (Juego().anfitrion) {
        DestinoManager.setDestino(const Atacar());
      }
      else {
        DestinoManager.setDestino(const Defender());
      }
    }
    else {
      DestinoManager.setDestino(const Sala());
    }
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/InicioSesion');
    } 
    else {
      Navigator.pushNamed(context, DestinoManager.getRutaDestino());
    }
  }

  Future<void> _handleIndividualPressed(BuildContext context, AuthProvider authProvider) async {
    DestinoManager.setDestino(const Atacar());
    Juego().modalidadPartida = "INDIVIDUAL";
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/InicioSesion');
    } 
    else {
      if (Juego().codigo == -1) {
        await Juego().crearPartida();
      } 
      DestinoManager.setDestino(const Atacar());
      Navigator.pushNamed(context, '/Atacar');
    }
  }

  Future<void> _handleTorneoPressed(BuildContext context, AuthProvider authProvider) async {
    DestinoManager.setDestino(const Atacar());
    Juego().modalidadPartida = "TORNEO";
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/InicioSesion');
    } 
    else {
      if (Juego().codigo == -1) {
        await Juego().crearPartida();
      }
      DestinoManager.setDestino(const Atacar());
      Navigator.pushNamed(context, '/Atacar');
    }
  }
}