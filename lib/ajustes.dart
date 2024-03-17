import 'package:flutter/material.dart';
import 'comun.dart';

class Ajustes extends StatelessWidget {
  const Ajustes({super.key});

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

            const Spacer(),
            buildActions(context)
          ],
        ),
      ),
    );
  }
}