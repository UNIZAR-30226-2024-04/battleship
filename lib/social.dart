import 'package:flutter/material.dart';
import 'comun.dart';

class Social extends StatelessWidget {
  const Social({super.key});

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

/* INTENTO DE HACER UNA LISTA DESPLEGABLE: NO COMPILA AÚN, TENGO QUE SEGUIR INVESTIGANDO
List<String> listaDeOpciones = ["A","B","C","D","E","F","G"];

  DropdownButtonFormField(
    items: listaDeOpciones.map((e){
      return DropdownMenuItem(
        child: SizedBox(
          width: double.infinity,
          child: Text(
            e,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: e,
      );
    }).toList(),
    onChanged: (String value) {},
    isDense: true,
    isExpanded: true,
  )*/
}