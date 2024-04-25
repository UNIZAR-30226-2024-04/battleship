import 'package:flutter/material.dart';

class MensajeErrorModel extends ChangeNotifier {
  String _mensaje = '';

  // Instancia estática privada de la clase
  static final MensajeErrorModel _instance = MensajeErrorModel._();

  // Constructor privado
  MensajeErrorModel._();

  // Método estático para obtener la instancia única de la clase
  static MensajeErrorModel getInstance() {
    return _instance;
  }

  String get mensaje => _mensaje;

  void setMensaje(String mensaje) {
    _mensaje = mensaje;
    notifyListeners();
  }

  void cleanErrorMessage() {
    _mensaje = '';
    notifyListeners(); 
  }
}
