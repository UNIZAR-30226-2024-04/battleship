import 'package:battleship/main.dart';
import 'package:flutter/material.dart';

class DestinoManager {
  static late Widget _destino = Principal();

  static setDestino(Widget destino) {
    _destino = destino;
  }

  static Widget getDestino() {
    return _destino;
  }
}
