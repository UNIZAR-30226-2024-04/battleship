import 'package:flutter/material.dart';
import 'package:battleship/juego.dart';
import 'package:battleship/serverRoute.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'comun.dart';
import 'botones.dart';

class PerfilOtroUsuario extends StatefulWidget {
  final String nombreUsuario;

  PerfilOtroUsuario({required this.nombreUsuario});

  @override
  _PerfilOtroUsuarioState createState() => _PerfilOtroUsuarioState();
}

class _PerfilOtroUsuarioState extends State<PerfilOtroUsuario> {
  ServerRoute serverRoute = ServerRoute();
  String pais = '';
  int partidasJugadas = 0;
  int partidasGanadas = 0;
  int partidasPerdidas = 0;
  int barcosHundidos = 0;
  int barcosPerdidos = 0;
  double ratioVictorias = 0;
  int puntos = 0;
  int trofeos = 0;
  int disparosAcertados = 0;
  int disparosFallados = 0;

  @override
  void initState() {
    super.initState();
    actualizarEstadisticasPerfil(widget.nombreUsuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Juego().colorFondo,
        ),
        child: Column(
          children: [
            buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildUserInfo(),
                    _buildStats(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildActions(context),
          ],
        ),
      ),
    );
  }

  Future<void> actualizarEstadisticasPerfil(String nombreUsuario) async {
    var response = await http.post(
      Uri.parse(serverRoute.urlObtenerPerfil),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombreId': nombreUsuario,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        trofeos = data['trofeos'];
        puntos = data['puntosExperiencia'];
        partidasJugadas = data['partidasJugadas'];
        partidasGanadas = data['partidasGanadas'];
        partidasPerdidas = partidasJugadas - partidasGanadas;
        if (partidasJugadas == 0) {
          ratioVictorias = 0;
        } else {
          double ratio = partidasGanadas / partidasJugadas;
          ratioVictorias = double.parse(ratio.toStringAsFixed(2));
        }
        barcosHundidos = data['barcosHundidos'];
        barcosPerdidos = data['barcosPerdidos'];
        disparosAcertados = data['disparosAcertados'];
        disparosFallados = data['disparosFallados'];
        pais = data['pais'];
      });

    } else {
      throw Exception('La solicitud ha fallado');
    }
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        buildTitle(widget.nombreUsuario, 28),
      ],
    );
  }

  Widget _buildStats() {
    return Column(
      children: [
        _buildStatRow('PUNTOS: $puntos'),
        _buildStatRow('TOTAL PARTIDAS: $partidasJugadas'),
        _buildStatRow('VICTORIAS: $partidasGanadas'),
        _buildStatRow('DERROTAS: $partidasPerdidas'),
        _buildStatRow('BARCOS HUNDIDOS: $barcosHundidos'),
        _buildStatRow('RATIO VICTORIAS: $ratioVictorias'),
        _buildStatRow('DISPAROS ACERTADOS: $disparosAcertados'),
        _buildStatRow('DISPAROS FALLADOS: $disparosFallados'),
      ],
    );
  }

  Widget _buildStatRow(String label) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

