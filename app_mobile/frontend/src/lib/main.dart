import 'package:battleship/defender.dart';
import 'package:battleship/registro.dart';
import 'package:flutter/material.dart';
import 'ajustes.dart';
import 'atacar.dart';
import 'flota.dart';
import 'mazo.dart';
import 'juego.dart';
import 'login.dart';
import 'destino.dart';
import 'principal.dart';
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
      home: InicioSesion(),
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

