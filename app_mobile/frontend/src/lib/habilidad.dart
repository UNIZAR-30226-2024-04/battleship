
import 'dart:ui';

import 'juego.dart';

abstract class Habilidad {
  String nombre = '';
  int turno = 1;
  bool usada = false;

  Habilidad(int turnoAsignado) {
    nombre = '';
    turno = turnoAsignado;
    usada = false;
  }

  List<Offset> ejecutar(int i, int j);

  bool disponible();

  void informarHabilidad();

  String getImagePath() {
    return 'images/$nombre.png';
  }
}

class Sonar extends Habilidad {
  Sonar(super.turnoAsignado) {
    nombre = 'sonar';
  }

  @override
  List<Offset> ejecutar(int i, int j) {
    print("EJEUCTANDO SONAR");
    usada = true;
    return [Offset(i.toDouble(), j.toDouble())];
  }

  @override
  bool disponible() {
    return !usada;
  }

  @override
  void informarHabilidad() {
    // No hace nada
  }
}

class Mina extends Habilidad {
  Mina(super.turnoAsignado) {
    nombre = 'mina';
  }

  @override
  List<Offset> ejecutar(int i, int j) {
    print("EJEUCTANDO MINA");
    usada = true;
    return [Offset(i.toDouble(), j.toDouble())];
  }

  @override
  bool disponible() {
    return !usada;
  }

  @override
  void informarHabilidad() {
    // No hace nada
  }
}

class MisilTeledirigido extends Habilidad {
  MisilTeledirigido(super.turnoAsignado) {
    nombre = 'misil';
  }

  @override
  List<Offset> ejecutar(int i, int j) {
    print("EJEUCTANDO MISIL");
    usada = true;
    return [Offset(i.toDouble(), j.toDouble())];
  }

  @override
  bool disponible() {
    return !usada;
  }

  @override
  void informarHabilidad() {
    // No hace nada
  }
}

class RafagaDeMisiles extends Habilidad {
  RafagaDeMisiles(super.turnoAsignado) {
    nombre = 'rafaga';
  }
  
  @override
  List<Offset> ejecutar(int i, int j) {
    print("EJEUCTANDO RAFAGA");
    if(!usada) {
      Juego().disparosPendientes = 3;
      usada = true;
    }
    
    return [Offset(i.toDouble(), j.toDouble())];
  }

  @override
  bool disponible() {
    return !usada;
  }

  @override
  void informarHabilidad() {
    // No hace nada
  }
}

class TorpedoRecargado extends Habilidad {
  String estado = 'disponible';
  int turnosPerdidosRestantes = 1;

  TorpedoRecargado(super.turnoAsignado) {
    nombre = 'torpedo';
  }

  void cambiarEstado() {
    estado = estado == 'recargando' ? 'disponible' : 'recargando';
  }

  @override
  List<Offset> ejecutar(int i, int j) {
    print("EJEUCTANDO TORPEDO");
    usada = true;

    List<Offset> casillasAAtacar = [];
    for (int delta = -1; delta <= 1; delta++) {
      casillasAAtacar.add(Offset(i.toDouble() + delta, j.toDouble()));
    }

    casillasAAtacar.add(Offset(i.toDouble(), j.toDouble() - 1));
    casillasAAtacar.add(Offset(i.toDouble(), j.toDouble() + 1));

    return casillasAAtacar;
  }

  @override
  void informarHabilidad() {
    if (estado == 'recargando') {
      if (turnosPerdidosRestantes == 0) {
        turnosPerdidosRestantes = 1;
        usada = false;
        cambiarEstado();
      }
    }
    else if(usada) {
      turnosPerdidosRestantes --;
      cambiarEstado();
    }
  }

  @override
  bool disponible() {
    return estado == 'disponible';
  }
}