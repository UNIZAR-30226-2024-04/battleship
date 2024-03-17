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
        const Text(
          'Habilidades',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5, // Espaciado entre letras
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCircledButton('images/clasico.png', 'Clásico'),
            const SizedBox(width: 20),
            buildCircledButton('images/titan.png', 'Titán'),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCircledButton('images/pirata.png', 'Pirata'),
            const SizedBox(width: 20),
            buildCircledButton('images/vikingo.png', 'Vikingo'),
          ],
        ),
      ],
    );
  }
}