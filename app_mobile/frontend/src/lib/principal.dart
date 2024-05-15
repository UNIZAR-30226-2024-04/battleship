import 'package:flutter/material.dart';
import 'atacar.dart';
import 'juego.dart';
import 'comun.dart';
import 'botones.dart';
import 'destino.dart';
import 'sala.dart';

class Principal extends StatefulWidget {
  String bioma = 'Mediterraneo'; // Valor inicial de bioma

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {


  void _handleBiomaChange(String nuevoBioma) {
    setState(() {
      widget.bioma = nuevoBioma;
      showInfoSnackBar(context, "Bioma actual $nuevoBioma");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Juego().colorFondo,
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
            buildTitle('Elige un bioma', 22),
            const SizedBox(height: 10),
            buildBiomaButtons(),
            const SizedBox(height: 7),
            buildTitle('Elige una modalidad', 22),
            buildActionButton(context, () => _handleCompetitivaPressed(context, widget.bioma), "Partida Competitiva"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleAmistosaPressed(context, widget.bioma), "Partida Amistosa"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleIndividualPressed(context, widget.bioma), "Partida Individual"),
            const SizedBox(height: 7),
            buildActionButton(context, () => _handleTorneoPressed(context, widget.bioma), "Torneo"),
            const Spacer(),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget buildBiomaButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: buildSmallActionButton(context, () => _handleBiomaChange('Mediterraneo'), 'Mediterraneo'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildSmallActionButton(context, () => _handleBiomaChange('Cantabrico'), 'Cantabrico'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: buildSmallActionButton(context, () => _handleBiomaChange('Norte'), 'Norte'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildSmallActionButton(context, () => _handleBiomaChange('Bermudas'), 'Bermudas'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSmallActionButton(BuildContext context, VoidCallback onPressed, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          textStyle: const TextStyle(fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  void _handleCompetitivaPressed(BuildContext context, String bioma) async {
    Juego().modalidadPartida = "COMPETITIVA";
    Juego().bioma = bioma;
    if (Juego().codigo != -1) {
      await Juego().cargarPartida(context);
    } else {
      DestinoManager.setDestino(const Sala());
    }
    Navigator.pushNamed(context, DestinoManager.getRutaDestino());
  }

  void _handleAmistosaPressed(BuildContext context, String bioma) async {
    Juego().modalidadPartida = "AMISTOSA";
    Juego().bioma = bioma;
    if (Juego().codigo != -1) {
      await Juego().cargarPartida(context);
    } else {
      DestinoManager.setDestino(const Sala());
    }
    Navigator.pushNamed(context, DestinoManager.getRutaDestino());
  }

  Future<void> _handleIndividualPressed(BuildContext context, String bioma) async {
    DestinoManager.setDestino(const Atacar());
    Juego().modalidadPartida = "INDIVIDUAL";
    Juego().bioma = bioma;
    if (Juego().codigo == -1) {
      await Juego().crearPartida();
      DestinoManager.setDestino(const Atacar());
    } else {
      await Juego().cargarPartida(context);
    }
    Navigator.pushNamed(context, DestinoManager.getRutaDestino());
  }

  Future<void> _handleTorneoPressed(BuildContext context, String bioma) async {
    Juego().torneo = true;
    Juego().modalidadPartida = "TORNEO";
    Juego().bioma = bioma;
    if (Juego().codigo != -1) {
      await Juego().cargarPartida(context);
    } else {
      DestinoManager.setDestino(const Sala());
    }
    Navigator.pushNamed(context, '/seleccionarTorneo');
  }
}