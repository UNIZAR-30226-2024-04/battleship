class ServerRoute {
  String urlBase = 'http://13.81.81.208/';
  //String urlBase = 'http://localhost:8080/';
  String urlObtenerTablero = '';
  String urlMoverBarcoInicial = '';
  String urlCrearPartida = '';
  String urlMostrarMiTablero = '';
  String urlMostrarMiTableroMulti = '';
  String urlMostrarTableroEnemigo = '';
  String urlMostrarTableroEnemigoMulti = '';
  String urlCrearPartidaMulti = '';
  String urlCrearSala = '';
  String urlBuscarSala = '';
  String urlAbandonarPartida = '';
  String urlAbandonarPartidaMulti = '';
  String urlDisparar = '';
  String urlDispararMulti = '';

  // Perfil - Usuario
  String urlInicioSesion = '';
  String urlRegistro = '';
  String urlModificarDatosPersonales = '';
  String urlEliminarUsuario = '';
  String urlObtenerPerfil = '';

  // Mazo y Barcos 
  String urlDispararRafaga = '';
  String urlDispararTorpedo = '';
  String urlDispararTeledirigido = '';
  String urlColocarMina = '';
  String urlUsarSonar = '';
  String urlDispararRafagaMulti = '';
  String urlDispararTorpedoMulti = '';
  String urlDispararTeledirigidoMulti = '';
  String urlColocarMinaMulti = '';
  String urlUsarSonarMulti = '';
  String urlModificarMazo = '';

  // Social - Amigos / Solicitudes de amistad
  String urlObtenerAmigos = '';
  String urlAgnadirAmigo = '';
  String urlEliminarAmigo = '';
  String urlObtenerSolicitudAmistad = '';
  String urlEnviarSolicitudAmistad = '';
  String urlEliminarSolicitudAmistad = '';

  // Social - Publicaciones
  String urlCrearPublicacion = '';
  String urlObtenerPublicaciones = '';
  String urlObtenerPublicacionesAmigos = '';
  String urlReaccionarPublicacion = '';
  String urlEliminarPublicacion = '';

  // Torneo
  String urlComprobarTorneo = '';
  String urlCrearSalaTorneo = '';
  String urlBuscarSalaTorneo = '';
    
  ServerRoute() {
    // Juego - Partida
    urlObtenerTablero = '${urlBase}perfil/obtenerDatosPersonales';
    urlMoverBarcoInicial = '${urlBase}perfil/moverBarcoInicial';
    urlCrearPartida = '${urlBase}partida/crearPartida';
    urlMostrarMiTablero = '${urlBase}partida/mostrarMiTablero';
    urlMostrarMiTableroMulti = '${urlBase}partidaMulti/mostrarMiTablero';
    urlMostrarTableroEnemigo = '${urlBase}partida/mostrarTableroEnemigo';
    urlMostrarTableroEnemigoMulti = '${urlBase}partidaMulti/mostrarTableroEnemigo';
    urlCrearPartidaMulti = '${urlBase}partidaMulti/crearPartida';
    urlCrearSala = '${urlBase}partidaMulti/crearSala';
    urlBuscarSala = '${urlBase}partidaMulti/buscarSala';
    urlAbandonarPartida = '${urlBase}partida/abandonarPartida';
    urlAbandonarPartidaMulti = '${urlBase}partidaMulti/abandonarPartida';
    urlDisparar = '${urlBase}partida/realizarDisparo';
    urlDispararMulti = '${urlBase}partidaMulti/realizarDisparo';

    // Perfil - Usuario
    urlInicioSesion = '${urlBase}perfil/iniciarSesion';
    urlRegistro = '${urlBase}perfil/registrarUsuario';
    urlModificarDatosPersonales = '${urlBase}perfil/modificarDatosPersonales';
    urlEliminarUsuario = '${urlBase}perfil/eliminarUsuario';
    urlObtenerPerfil = '${urlBase}perfil/obtenerUsuario';

    // Mazo y Barcos 
    urlDispararRafaga = '${urlBase}partida/realizarDisparoMisilRafaga';
    urlDispararTorpedo = '${urlBase}partida/realizarDisparoTorpedoRecargado';
    urlDispararTeledirigido = '${urlBase}partida/realizarDisparoMisilTeledirigido';
    urlColocarMina = '${urlBase}partida/colocarMina';
    urlUsarSonar = '${urlBase}partida/usarSonar';
    urlDispararRafagaMulti = '${urlBase}partidaMulti/realizarDisparoMisilRafaga';
    urlDispararTorpedoMulti = '${urlBase}partidaMulti/realizarDisparoTorpedoRecargado';
    urlDispararTeledirigidoMulti = '${urlBase}partidaMulti/realizarDisparoMisilTeledirigido';
    urlColocarMinaMulti = '${urlBase}partidaMulti/colocarMina';
    urlUsarSonarMulti = '${urlBase}partidaMulti/usarSonar';
    urlModificarMazo = '${urlBase}perfil/modificarMazo';

    // Social - Amigos / Solicitudes de amistad
    urlObtenerAmigos = '${urlBase}perfil/obtenerAmigos';
    urlAgnadirAmigo = '${urlBase}perfil/agnadirAmigo';
    urlEliminarAmigo = '${urlBase}perfil/eliminarAmigo';
    urlObtenerSolicitudAmistad = '${urlBase}perfil/obtenerSolicitudesAmistad';
    urlEnviarSolicitudAmistad = '${urlBase}perfil/enviarSolicitudAmistad';
    urlEliminarSolicitudAmistad = '${urlBase}perfil/eliminarSolicitudAmistad';

    // Social - Publicaciones
    urlCrearPublicacion = '${urlBase}publicacion/crearPublicacion';
    urlObtenerPublicaciones = '${urlBase}publicacion/obtenerPublicaciones';
    urlObtenerPublicacionesAmigos = '${urlBase}publicacion/obtenerPublicacionesAmigos';
    urlReaccionarPublicacion = '${urlBase}publicacion/reaccionarPublicacion';
    urlEliminarPublicacion = '${urlBase}publicacion/eliminarPublicacion';

    // Torneo
    urlComprobarTorneo = '${urlBase}partidaMulti/comprobarTorneo';
    urlCrearSalaTorneo = '${urlBase}partidaMulti/crearSalaTorneo';
    urlBuscarSalaTorneo = '${urlBase}partidaMulti/buscarSalaTorneo';
  }
}