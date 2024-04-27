import 'package:battleship/main.dart';
import 'package:flutter/material.dart';

import 'ajustes.dart';
import 'atacar.dart';
import 'colocarBarcos.dart';
import 'defender.dart';
import 'flota.dart';
import 'habilidades.dart';
import 'juego.dart';
import 'login.dart';
import 'recContrasena.dart';
import 'registro.dart';
import 'social.dart';

class DestinoManager {
  static Widget _destino = Principal();

  static setDestino(Widget destino) {
    _destino = destino;
  }

  static Widget getDestino() {
    return _destino;
  }

  static String getRutaDestino() {
    if (_destino is InicioSesion) {
      return '/InicioSesion';
    } else if (_destino == Juego().perfilJugador) {
      return '/Perfil';
    } else if (_destino is Principal) {
      return '/Principal';
    } else if (_destino is ColocarBarcos) {
      return '/ColocarBarcos';
    } else if (_destino is Habilidades) {
      return '/Habilidades';
    } else if (_destino is Flota) {
      return '/Flota';
    } else if (_destino is Ajustes) {
      return '/Ajustes';
    } else if (_destino is Social) {
      return '/Social';
    } else if (_destino is Registro) {
      return '/Registrarse';
    } else if (_destino is RecuperacionContrasena) {
      return 'RecuperarContrasena';
    } else if (_destino is Atacar) {
      return '/Atacar';
    } else if (_destino is Defender) {
      return '/Defender';
    } else {
      throw Exception('Widget no definido');
    }
  }
}
