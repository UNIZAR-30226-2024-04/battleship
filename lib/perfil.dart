import 'package:flutter/material.dart';
import 'social.dart';
import 'habilidades.dart';
import 'flota.dart';
import 'ajustes.dart';
import 'main.dart';
import 'authProvider.dart';


class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  _Perfil createState() => _Perfil();
}

class _Perfil extends State<Perfil> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _rememberMe = false;
  final AuthProvider _authProvider = AuthProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              _buildUserInfo(),
              _buildStats(),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }
}







Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Image(
            image: AssetImage('images/logo.png'),
            width: 100,
            height: 100,
            alignment: Alignment.topLeft,
          ),
        ),
        const Spacer(),
        Transform.translate(
          offset: const Offset(0, -20),
          child: const Image(
            image: AssetImage('images/battleship.png'),
            width: 150,
            height: 150,
            alignment: Alignment.center,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Perfil()),
              );
            },
            child: const Image(
              image: AssetImage('images/perfil.png'),
              width: 100,
              height: 100,
              alignment: Alignment.topRight,
            ),
          ),
        ),
      ],
    );
  }




Widget _buildUserInfo() {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        const Text(
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
        const Text(
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
        const Text(
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
        const SizedBox(height: 10.0),
      ],
    );
  }



  Widget _buildStats() {
    return Column(
      children: [
        _buildStatRow('Puntos: '),
        _buildStatRow('Total partidas: '),
        _buildStatRow('Victorias: '),
        _buildStatRow('Derrotas: '),
        _buildStatRow('Barcos hundidos'),
        _buildStatRow('Ratio victorias: '),
        _buildStatRow('Flota favorita: '),
        _buildStatRow('Habilidad favorita: '),
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
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 70),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionItem('Jugar', 'images/jugar.png', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Principal()),
              );
            }),
            _buildActionItem('Habilidades', 'images/habilidad.png', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Habilidades()),
              );
            }),
            _buildActionItem('Flota', 'images/flota.png', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Flota()),
              );
            }),
            _buildActionItem('Social', 'images/social.png', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Social()),
              );
            }),
            _buildActionItem('Ajustes', 'images/ajustes.png', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Ajustes()),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(String label, String imagePath, void Function()? onTap) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }