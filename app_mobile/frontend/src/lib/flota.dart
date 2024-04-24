import 'package:flutter/material.dart';
import 'comun.dart';
import 'botones.dart';

class Flota extends StatelessWidget {
  const Flota({super.key});

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
            buildTitle('Flota', 28),
            const Spacer(),
            _buildFlota(context),
            const Spacer(),
            buildActions(context)
          ],
        ),
      ),
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