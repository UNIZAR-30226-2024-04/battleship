import 'dart:convert';
import 'package:flutter/material.dart';
import 'juego.dart';
import 'botones.dart';
import 'comun.dart';
import 'package:http/http.dart' as http;
import 'serverRoute.dart';

class SeleccionarTorneo extends StatefulWidget {
  const SeleccionarTorneo({super.key});

  @override
  _SeleccionarTorneoState createState() => _SeleccionarTorneoState();
}

class _SeleccionarTorneoState extends State<SeleccionarTorneo> {
  final TextEditingController _idTorneo = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Juego().colorFondo,
        ),
        child: Center(
          child: _buildSelecter(context, () async => await _handlePressed(context)),
        ),
      ),
    );
  }

  Widget _buildSelecter(BuildContext context, VoidCallback? onPressed) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTitle('Buscar torneo', 28),
          const SizedBox(height: 10.0),
          buildEntryButton('Id torneo', 'Introduzca id del torneo', Icons.emoji_events, _idTorneo),
          const SizedBox(height: 20),
          buildActionButton(context, onPressed, "Buscar torneo"),
          const SizedBox(height: 10),
          buildActionButton(context, () => Navigator.pushNamed(context, '/Principal'), 'Cancelar'),
        ],
      ),
    );
  }

  Future<void> _handlePressed(BuildContext context) async {
    if (_idTorneo.text.isEmpty) {
      showInfoSnackBar(context, "Introduzca un id de torneo");
      return;
    }
    bool puedeEntrarTorneo = await comprobarTorneo(Juego().miPerfil.name, _idTorneo.text);
    if (puedeEntrarTorneo) {
      Navigator.pushNamed(context, '/Sala');
    }
  }

  Future<bool> comprobarTorneo(String nombreId, String idTorneo) async {
    var uri = Uri.parse(ServerRoute().urlComprobarTorneo);
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Juego().tokenSesion}',
      },
      body: jsonEncode(<String, dynamic>{
        'nombreId': nombreId,
        'torneo': idTorneo,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("COMPROBAR TORNEO");
      print(data);
      bool existe = data['existe'];
      bool puedeUnirse = data['puedeUnirse'];
      bool haGanado = data['haGanado'];

      if (!existe) {
        showErrorSnackBar(context, "El torneo no existe");
        return false;
      }
      if (!puedeUnirse) {
        showErrorSnackBar(context, "No puedes unirte al torneo");
        return false;
      }
      if (haGanado) {
        showErrorSnackBar(context, "Ya has ganado el torneo");
        return false;
      }

      Juego().idTorneo = idTorneo;

      return true;
    } else {
      return false;
    }
  }
}
