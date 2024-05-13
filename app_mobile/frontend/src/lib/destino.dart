import 'package:battleship/main.dart';
import 'package:flutter/material.dart';
import 'ajustes.dart';
import 'atacar.dart';
import 'flota.dart';
import 'defender.dart';
import 'mazo.dart';
import 'juego.dart';
import 'login.dart';
import 'mina.dart';
import 'principal.dart';
import 'recContrasena.dart';
import 'registro.dart';
import 'sala.dart';
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
    } else if (_destino == Juego().miPerfil) {
      return '/Perfil';
    } else if (_destino is Principal) {
      return '/Principal';
    } else if (_destino is Flota) {
      return '/Flota';
    } else if (_destino is Mazo) {
      return '/Mazo';
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
    } else if (_destino is Sala) {
      return '/Sala';
    } else if (_destino is Mina) {
      return '/Mina';
    }
    else {
      throw Exception('Widget no definido');
    }
  }
}
