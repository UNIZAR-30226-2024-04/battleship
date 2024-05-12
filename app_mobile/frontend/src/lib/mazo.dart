import 'package:flutter/material.dart';
import 'botones.dart';
import 'comun.dart';
import 'error.dart';
import 'habilidad.dart';
import 'juego.dart';

class Mazo extends StatefulWidget {
  MensajeErrorModel mensajeErrorModel = MensajeErrorModel.getInstance();

  Mazo({super.key});

  @override
  _MazoState createState() => _MazoState();

  List<Habilidad> getSelectedAbilities() {
    List<Habilidad> habilidades = [];
    Juego().selectedAbilities.forEach((key, value) {
      if (value) {
        switch (key) {
          case 'rafaga':
            habilidades.add(Rafaga());
            break;
          case 'torpedo':
            habilidades.add(Torpedo());
            break;
          case 'sonar':
            habilidades.add(Sonar());
            break;
          case 'mina':
            habilidades.add(Mina());
            break;
          case 'teledirigido':
            habilidades.add(TeleDirigido());
            break;
        }
      }
    });

    return habilidades;
  } 

  void setSelectedAbilities(List<Habilidad> habilidades) {
    Juego().selectedAbilities['rafaga'] = false;
    Juego().selectedAbilities['torpedo'] = false;
    Juego().selectedAbilities['sonar'] = false;
    Juego().selectedAbilities['mina'] = false;
    Juego().selectedAbilities['teledirigido'] = false;

    for (var habilidad in habilidades) {
      switch (habilidad.nombre) {
        case 'rafaga':
          Juego().selectedAbilities['rafaga'] = true;
          break;
        case 'torpedo':
          Juego().selectedAbilities['torpedo'] = true;
          break;
        case 'sonar':
          Juego().selectedAbilities['sonar'] = true;
          break;
        case 'mina':
          Juego().selectedAbilities['mina'] = true;
          break;
        case 'teledirigido':
          Juego().selectedAbilities['teledirigido'] = true;
          break;
      }
    }
  }
}

class _MazoState extends State<Mazo> {
  @override
  void initState() {
    super.initState();
    widget.setSelectedAbilities(Juego().habilidades);
  }

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
            buildTitle('Barcos', 28),
            const Spacer(),
            _buildFlota(context),
            const Spacer(),
            buildTitle('Habilidades', 28),
            const Spacer(),
            _buildHabilities(context),
            const Spacer(),
            buildActions(context)
          ],
        ),
      ),
    );
  }

  Widget _buildHabilities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircledButton('images/rafaga.png', 'Ráfaga', Juego().selectedAbilities['rafaga']!, () {
                  // Si hay mas de 3 habilidades seleccionadas, no se puede seleccionar otra
                  if (Juego().selectedAbilities.values.where((element) => element).length >= 3 && !Juego().selectedAbilities['rafaga']!) {
                    widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                    showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                    widget.mensajeErrorModel.cleanErrorMessage();
                    return;
                  }
                  setState(() {
                    Juego().selectedAbilities['rafaga'] = !Juego().selectedAbilities['rafaga']!;
                    Juego().actualizarMazo();
                  });
                }),
                buildCircledButton('images/torpedo.png', 'Torpedo', Juego().selectedAbilities['torpedo']!, () {
                  if (Juego().selectedAbilities.values.where((element) => element).length >= 3 && !Juego().selectedAbilities['torpedo']!) {
                    widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                    showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                    widget.mensajeErrorModel.cleanErrorMessage();
                    return;
                  }
                  setState(() {
                    Juego().selectedAbilities['torpedo'] = !Juego().selectedAbilities['torpedo']!;
                    Juego().actualizarMazo();
                  });
                }),
                buildCircledButton('images/sonar.png', 'Sonar', Juego().selectedAbilities['sonar']!, () {
                  if (Juego().selectedAbilities.values.where((element) => element).length >= 3 && !Juego().selectedAbilities['sonar']!) {
                    widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                    showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                    widget.mensajeErrorModel.cleanErrorMessage();
                    return;
                  }                  
                  setState(() {
                    Juego().selectedAbilities['sonar'] = !Juego().selectedAbilities['sonar']!;
                    Juego().actualizarMazo();
                  });
                }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircledButton('images/mina.png', 'Mina', Juego().selectedAbilities['mina']!, () {
                  if (Juego().selectedAbilities.values.where((element) => element).length >= 3 && !Juego().selectedAbilities['mina']!) {
                    widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                    showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                    widget.mensajeErrorModel.cleanErrorMessage();
                    return;
                  }
                  setState(() {
                    Juego().selectedAbilities['mina'] = !Juego().selectedAbilities['mina']!;
                    Juego().actualizarMazo();
                  });
                }),
                buildCircledButton('images/misil.png', 'Teledirigido', Juego().selectedAbilities['teledirigido']!, () {
                  if (Juego().selectedAbilities.values.where((element) => element).length >= 3 && !Juego().selectedAbilities['teledirigido']!) {
                    widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                    showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                    widget.mensajeErrorModel.cleanErrorMessage();
                    return;
                  }
                  setState(() {
                    Juego().selectedAbilities['teledirigido'] = !Juego().selectedAbilities['teledirigido']!;
                    Juego().actualizarMazo();
                  });
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlota(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCircledButton('images/clasico.png', 'Clásico', false, () {}),
            const SizedBox(width: 20),
            buildCircledButton('images/titan.png', 'Titán', false, () {}),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCircledButton('images/pirata.png', 'Pirata', false, () {}),
            const SizedBox(width: 20),
            buildCircledButton('images/vikingo.png', 'Vikingo', false, () {}),
          ],
        ),
      ],
    );
  }
}