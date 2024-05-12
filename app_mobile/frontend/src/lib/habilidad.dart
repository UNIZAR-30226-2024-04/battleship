import 'juego.dart';

abstract class Habilidad {
  String nombre = '';
  String estado = '';

  Habilidad() {
    nombre = '';
  }

  void ejecutar();

  String getImagePath() {
    return 'images/$nombre.png';
  }
}

class Sonar extends Habilidad {
  Sonar() {
    nombre = 'sonar';
  }

  @override
  void ejecutar() {
    Juego().indiceHabilidadSeleccionadaEnTurno = -1;
  }
}

class Mina extends Habilidad {
  Mina() {
    nombre = 'mina';
  }

  @override
  void ejecutar() {
      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
  }
}

class TeleDirigido extends Habilidad {
  TeleDirigido() {
    nombre = 'misil';
  }

  @override
  void ejecutar() {
    Juego().indiceHabilidadSeleccionadaEnTurno = -1;
  }
}

class Rafaga extends Habilidad {
  int disparosRealizados = 0;

  Rafaga() {
    nombre = 'rafaga';
  }
  
  @override
  void ejecutar() {
    if(disparosRealizados == 0) {
      Juego().disparosPendientes = 3;
      disparosRealizados ++;
    }
    else if(Juego().disparosPendientes > 0) {
      disparosRealizados ++;
    }
    else if(Juego().disparosPendientes == 0) {
      disparosRealizados = 0;
      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
    }
  }
}

class Torpedo extends Habilidad {
  String estado = 'recargando';
  int turnosPerdidosRestantes = 1;

  Torpedo() {
    nombre = 'torpedo';
  }

  void cambiarEstado() {
    estado = estado == 'recargando' ? 'disponible' : 'recargando';
  }

  @override
  void ejecutar() {
    if(estado == 'recargando') {
      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
    }
    cambiarEstado();
  }
}