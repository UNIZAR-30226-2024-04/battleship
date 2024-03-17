import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'comun.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _rememberMe = false;
  final AuthProvider _authProvider = AuthProvider();

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
}

Widget _buildUserInfo() {
  return const Column(
    children: [
      SizedBox(height: 10.0),
      Text(
        'Nombre usuario',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Colors.black,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
      Text(
        'Seguidores',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Colors.black,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
      Text(
        'Siguiendo',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Colors.black,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
      SizedBox(height: 10.0),
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