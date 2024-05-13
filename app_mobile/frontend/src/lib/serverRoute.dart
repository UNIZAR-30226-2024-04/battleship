class ServerRoute {
  String urlObtenerTablero = 'http://localhost:8080/perfil/obtenerDatosPersonales';
  String urlMoverBarcoInicial = 'http://localhost:8080/perfil/moverBarcoInicial';
  String urlCrearPartida = 'http://localhost:8080/partida/crearPartida';
  String urlMostrarMiTablero = 'http://localhost:8080/partida/mostrarMiTablero';
  String urlMostrarMiTableroMulti = 'http://localhost:8080/partidaMulti/mostrarMiTablero';
  String urlMostrarTableroEnemigo = 'http://localhost:8080/partida/mostrarTableroEnemigo';
  String urlMostrarTableroEnemigoMulti = 'http://localhost:8080/partidaMulti/mostrarTableroEnemigo';
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
  String urlDispararTeledirigido = 'http://localhost:8080/partida/realizarDisparoMisilTeledirigido';
  String urlColocarMina = 'http://localhost:8080/partida/colocarMina';
  String urlUsarSonar = 'http://localhost:8080/partida/usarSonar';
  String urlDispararRafagaMulti = 'http://localhost:8080/partidaMulti/realizarDisparoMisilRafaga';
  String urlDispararTorpedoMulti = 'http://localhost:8080/partidaMulti/realizarDisparoTorpedoRecargado';
  String urlDispararTeledirigidoMulti = 'http://localhost:8080/partidaMulti/realizarDisparoMisilTeledirigido';
  String urlColocarMinaMulti = 'http://localhost:8080/partidaMulti/colocarMina';
  String urlUsarSonarMulti = 'http://localhost:8080/partidaMulti/usarSonar';
  String urlModificarMazo = 'http://localhost:8080/perfil/modificarMazo';

  // Social - Amigos / Solicitudes de amistad
  String urlObtenerAmigos = 'http://localhost:8080/perfil/obtenerAmigos';
  String urlAgnadirAmigo = 'http://localhost:8080/perfil/agnadirAmigo';
  String urlEliminarAmigo = 'http://localhost:8080/perfil/eliminarAmigo';
  String urlObtenerSolicitudAmistad = 'http://localhost:8080/perfil/obtenerSolicitudAmistad';
  String urlEnviarSolicitudAmistad = 'http://localhost:8080/perfil/enviarSolicitudAmistad';
  String urlEliminarSolicitudAmistad = 'http://localhost:8080/perfil/eliminarSolicitudAmistad';

  // Social - Publicaciones
  String urlCrearPublicacion = 'http://localhost:8080/publicacion/crearPublicacion';
  String urlObtenerPublicacion = 'http://localhost:8080/publicacion/obtenerPublicacion';
  String urlReaccionarPublicacion = 'http://localhost:8080/publicacion/reaccionarPublicacion';
  String urlEliminarPublicacion = 'http://localhost:8080/publicacion/eliminarPublicacion';
}