import 'juego.dart';

abstract class Habilidad {
  String nombre = '';
  bool disponible = true;

  Habilidad() {
    nombre = '';
    disponible = true;
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
    if(disponible == true) {
      disponible = false;
      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
    }
    else {
      disponible = true;
    }
  }
}

class Mina extends Habilidad {
  Mina() {
    nombre = 'mina';
  }

  @override
  void ejecutar() {
    if(disponible == true) {
      disponible = false;
      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
    }
    else {
      disponible = true;
    }
  }
}

class Misil extends Habilidad {
  Misil() {
    nombre = 'misil';
  }

  @override
  void ejecutar() {
    if(disponible == true) {
      disponible = false;
      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
    }
    else {
      disponible = true;
    }
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
      Juego().disparosPendientes = 2;
      disparosRealizados = 1;
      disponible = true;
    }
    else if(disparosRealizados < 3) {
      Juego().disparosPendientes --;
      disparosRealizados ++;
      disponible = true;
    }
    else if(disparosRealizados == 3) {
      Juego().disparosPendientes = 0;
      disparosRealizados = 0;
      disponible = false;
      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
    }
  }
}

class Torpedo extends Habilidad {
  String estado = 'disponible';
  int turnosPerdidosRestantes = 1;

  Torpedo() {
    nombre = 'torpedo';
  }

  void cambiarEstado() {
    estado = estado == 'recargando' ? 'disponible' : 'recargando';
  }

  @override
  void ejecutar() {
    if(disponible == true) {
      disponible = false;
      Juego().indiceHabilidadSeleccionadaEnTurno = -1;
    }
    else {
      disponible = true;
    }
  }
}