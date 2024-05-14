import 'package:battleship/authProvider.dart';
import 'package:battleship/botones.dart';
import 'package:flutter/material.dart';
import 'comun.dart';
import 'package:audioplayers/audioplayers.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  final TextEditingController _activarChatController = TextEditingController();
  final TextEditingController _peticionesChatController = TextEditingController();
  final TextEditingController _mostrarMarcasController = TextEditingController();
  final TextEditingController _efectosSonidoController = TextEditingController();
  final TextEditingController _ocanoController = TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();
  
  //Declaración de variables a modificar en los ajustes.
  bool musica = true;
  bool sonido = true;
  bool chatPartidas = true;
  bool peticionesChat = true;
  bool marcasTiempo = true;
  bool efectosSonido = true;
  bool oceno = true;
  bool efectosBarcoTocado = true;
  bool efectosBarcoHundido = true;
  bool verNombreRival = true;
  bool verEloRival = true;
  bool verEmoticonos = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    buildTitle('Ajustes', 28),  // Título de la pantalla de ajustes.
                    _buildAjustes(context), // Construcción de la pantalla de ajustes.
                  ],
                ),
              ),
            ),
            buildActions(context)
          ],
        ),
      ),
    );
  }


  // Construcción de la pantalla de ajustes.
  Widget _buildAjustes(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Botones para activar/desactivar música y sonido.
          buildEntryToggleButton('Música', musica, () => _handlePressed(context, AuthProvider(), musica, (value) => musica = value)),
          buildEntryToggleButton('Sonido', sonido, () => _handlePressed(context, AuthProvider(), sonido, (value) => sonido = value)),

          // Dropdowns para seleccionar opciones: archivar, peticiones del chat, marcas de tiempo, sonido, chat de partidas y océano.
          buildDropdownButton(context, 'Activar chat de partidas', ['Todos', 'Solo yo'], _activarChatController),
          buildDropdownButton(context, 'Peticiones de chat', ['Amigos', 'Todos'], _peticionesChatController),
          buildDropdownButton(context, 'Mostrar marcas de tiempo', ['Nunca', 'Siempre'], _mostrarMarcasController),
          buildDropdownButton(context, 'Efectos de sonido', ['Por defecto', 'Desactivado', 'Activado'], _efectosSonidoController),
          buildDropdownButton(context, 'Activar chat de partidas', ['Todos', 'Solo yo'], _activarChatController),
          buildDropdownButton(context, 'Océano', ['Estático', 'En movimiento'], _ocanoController),
          
          // Botones para activar/desactivar efectos de barco, efectos de barco hundido, ver nombre y elo del rival y ver emoticonos durante una partida.
          buildEntryToggleButton('Efectos de barco tocado', efectosBarcoTocado, () => _handlePressed(context, AuthProvider(), efectosBarcoTocado, (value) => efectosBarcoTocado = value)),
          buildEntryToggleButton('Efectos de barco hundido', efectosBarcoHundido, () => _handlePressed(context, AuthProvider(), efectosBarcoHundido, (value) => efectosBarcoHundido = value)),
          buildEntryToggleButton('Ver nombre del rival', verNombreRival, () => _handlePressed(context, AuthProvider(), verNombreRival, (value) => verNombreRival = value)),
          buildEntryToggleButton('Ver elo del rival', verEloRival, () => _handlePressed(context, AuthProvider(), verEloRival, (value) => verEloRival = value)),
          buildEntryToggleButton('Ver emoticonos en partida', verEmoticonos, () => _handlePressed(context, AuthProvider(), verEmoticonos, (value) => verEmoticonos = value)),

        ],
      ),
    );
  }

  // Función para manejar el estado de los botones de activar/desactivar.
  void _handlePressed(BuildContext context, AuthProvider authProvider, bool isActive, Function(bool) setStateFunc) async {
    setState(() {
      setStateFunc(!isActive);
    });
  }
}