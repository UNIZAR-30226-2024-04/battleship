class ServerRoute {
  String urlObtenerTablero = 'http://localhost:8080/perfil/obtenerDatosPersonales';
  String urlMoverBarcoInicial = 'http://localhost:8080/perfil/moverBarcoInicial';
  String urlCrearPartida = 'http://localhost:8080/partida/crearPartida';
  String urlMostrarMiTablero = 'http://localhost:8080/partida/mostrarMiTablero';
  String urlMostrarTableroEnemigo = 'http://localhost:8080/partida/mostrarTableroEnemigo';
  String urlCrearPartidaMulti = 'http://localhost:8080/partidaMulti/crearPartida';
  String urlCrearSala = 'http://localhost:8080/partidaMulti/crearSala';
  String urlBuscarSala = 'http://localhost:8080/partidaMulti/buscarSala';
  String urlAbandonarPartida = 'http://localhost:8080/partida/abandonarPartida';
  String urlAbandonarPartidaMulti = 'http://localhost:8080/partidaMulti/abandonarPartida';
  String urlDisparar = 'http://localhost:8080/partida/realizarDisparo';
  String urlDispararMulti = 'http://localhost:8080/partidaMulti/realizarDisparo';
  String urlInicioSesion = 'http://localhost:8080/perfil/iniciarSesion';
  String urlRegistro = 'http://localhost:8080/perfil/registrarUsuario';
  String urlModificarDatosPersonales = 'http://localhost:8080/perfil/modificarDatosPersonales';
  String urlEliminarUsuario = 'http://localhost:8080/perfil/eliminarUsuario';
  String urlObtenerPerfil = 'http://localhost:8080/perfil/obtenerUsuario';
  String urlDispararRafaga = 'http://localhost:8080/partida/realizarDisparoMisilRafaga';
  String urlDispararTorpedo = 'http://localhost:8080/partida/realizarDisparoTorpedoRecargado';
  String urlDispararMisil = 'http://localhost:8080/partida/realizarDisparoMisilTeledirigido';
  String urlModificarMazo = 'http://localhost:8080/perfil/modificarMazo';
}