import 'package:flutter/material.dart';
import 'comun.dart';
import 'botones.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircledButton('images/rafaga.png', 'Ráfaga'),
                buildCircledButton('images/torpedo.png', 'Torpedo'),
                buildCircledButton('images/sonar.png', 'Sonar'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircledButton('images/mina.png', 'Mina'),
                buildCircledButton('images/misil.png', 'Misil'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}