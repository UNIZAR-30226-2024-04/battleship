import 'package:flutter/material.dart';
import 'botones.dart';
import 'comun.dart';
import 'error.dart';

class Habilidades extends StatefulWidget {
  MensajeErrorModel mensajeErrorModel = MensajeErrorModel.getInstance();

  Habilidades({super.key});

  @override
  _HabilidadesState createState() => _HabilidadesState();
}

class _HabilidadesState extends State<Habilidades> {
  Map<String, bool> selectedAbilities = {
    'Ráfaga': false,
    'Torpedo': false,
    'Sonar': false,
    'Mina': false,
    'Misil': false,
  };

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
    print(selectedAbilities);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircledButton('images/rafaga.png', 'Ráfaga', selectedAbilities['Ráfaga']!, () {
                  setState(() {
                    // Si hay mas de 3 habilidades seleccionadas, no se puede seleccionar otra
                    if (selectedAbilities.values.where((element) => element).length >= 3 && !selectedAbilities['Ráfaga']!) {
                      widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                      showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                      widget.mensajeErrorModel.cleanErrorMessage();
                      return;
                    }
                    selectedAbilities['Ráfaga'] = !selectedAbilities['Ráfaga']!;
                  });
                }),
                buildCircledButton('images/torpedo.png', 'Torpedo', selectedAbilities['Torpedo']!, () {
                  setState(() {
                    if (selectedAbilities.values.where((element) => element).length >= 3 && !selectedAbilities['Torpedo']!) {
                      widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                      showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                      widget.mensajeErrorModel.cleanErrorMessage();
                      return;
                    }
                    selectedAbilities['Torpedo'] = !selectedAbilities['Torpedo']!;
                  });
                }),
                buildCircledButton('images/sonar.png', 'Sonar', selectedAbilities['Sonar']!, () {
                  setState(() {
                    if (selectedAbilities.values.where((element) => element).length >= 3 && !selectedAbilities['Sonar']!) {
                      widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                      showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                      widget.mensajeErrorModel.cleanErrorMessage();
                      return;
                    }
                    selectedAbilities['Sonar'] = !selectedAbilities['Sonar']!;
                  });
                }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircledButton('images/mina.png', 'Mina', selectedAbilities['Mina']!, () {
                  setState(() {
                    if (selectedAbilities.values.where((element) => element).length >= 3 && !selectedAbilities['Mina']!) {
                      widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                      showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                      widget.mensajeErrorModel.cleanErrorMessage();
                      return;
                    }
                    selectedAbilities['Mina'] = !selectedAbilities['Mina']!;
                  });
                }),
                buildCircledButton('images/misil.png', 'Misil', selectedAbilities['Misil']!, () {
                  setState(() {
                    if (selectedAbilities.values.where((element) => element).length >= 3 && !selectedAbilities['Misil']!) {
                      widget.mensajeErrorModel.setMensaje('No puedes seleccionar más de 3 habilidades en tu mazo');
                      showErrorSnackBar(context, widget.mensajeErrorModel.mensaje);
                      widget.mensajeErrorModel.cleanErrorMessage();
                      return;
                    }
                    selectedAbilities['Misil'] = !selectedAbilities['Misil']!;
                  });
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }
}