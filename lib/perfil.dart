import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'comun.dart';
import 'habilidad.dart';

class Perfil extends StatefulWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _rememberMe = false;
  final AuthProvider _authProvider = AuthProvider();
  List<Habilidad> _habilidades = [];  // habilidades desbloqueadas
  List<Habilidad> _habilidadesSeleccionadas = [];  // habilidades seleccionadas para la partida

  Perfil({turno = 1}) {
    _habilidades = [Sonar(turno), Mina(turno), MisilTeledirigido(turno), RafagaDeMisiles(turno), TorpedoRecargado(turno)];
    _habilidadesSeleccionadas = [RafagaDeMisiles(turno), TorpedoRecargado(turno), MisilTeledirigido(turno)];
  }

  @override
  _PerfilState createState() => _PerfilState();

  List<Habilidad> getHabilidadesSeleccionadas() {
    return _habilidadesSeleccionadas;
  }
}

class _PerfilState extends State<Perfil> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fondo.jpg'),
            fit: BoxFit.cover,
          ),
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
            buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        buildTitle('Nombre usuario', 28),
        buildTitle('Seguidores', 14),
        buildTitle('Siguiendo', 14),
      ],
    );
  }

  Widget _buildStats() {
    return Column(
      children: [
        _buildStatRow('PUNTOS: '),
        _buildStatRow('TOTAL PARTIDAS: '),
        _buildStatRow('VICTORIAS: '),
        _buildStatRow('DERROTAS: '),
        _buildStatRow('BARCOS HUNDIDOS: '),
        _buildStatRow('RATIO VICTORIAS: '),
        _buildStatRow('FLOTA FAVORITA: '),
        _buildStatRow('HABILIDAD FAVORITA: '),
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

