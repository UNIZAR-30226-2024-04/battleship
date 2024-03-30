import 'package:flutter/material.dart';

class DestinoManager {
  static late Widget _destino;

  static setDestino(Widget destino) {
    _destino = destino;
  }

  static Widget getDestino() {
    return _destino;
  }
}
