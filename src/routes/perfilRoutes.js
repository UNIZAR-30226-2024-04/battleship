const express = require('express');
const router = express.Router();
const perfilController = require('../controllers/perfilController');
const verificarToken = require('../middlewares/authjwt');
const verificarRegistro = require('../middlewares/verificarRegistro');

/*--------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------ PERFIL BÁSICO  ----------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/

// Ruta para obtener perfil
router.post('/obtenerUsuario', perfilController.obtenerUsuario);
// Ruta para obtener datos personales del perfil
router.post('/obtenerDatosPersonales', perfilController.obtenerPerfilDatosPersonales);
// Ruta para modificar datos personales del perfil
router.post('/modificarDatosPersonales', perfilController.modificarPerfilDatosPersonales);
// Ruta para eliminar usuario
router.post('/eliminarUsuario', perfilController.eliminarUsuario);

/*--------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------- REGISTRO E INICIO DE SESIÓN  ---------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/

// Ruta para registrar usuario
router.post('/registrarUsuario', verificarRegistro, perfilController.registrarUsuario);
// Ruta para iniciar sesión
router.post('/inicioSesion', perfilController.iniciarSesion);

/*--------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------- ASPECTOS PARA PARTIDAS  ------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/

// Ruta para modificar mazo
router.post('/modificarMazo', verificarToken, perfilController.modificarMazo);
// Ruta para modificar tablero
router.post('/moverBarcoInicial', perfilController.moverBarcoInicial);

/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------- PERFIL POST PARTIDA  -------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/

// Ruta para modificar estadisticas
router.post('/actualizarEstadisticas', perfilController.actualizarEstadisticas);
// Ruta para modificar la experiencia
router.post('/actualizarPuntosExperiencia', perfilController.actualizarEstadisticas);

/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------- RED SOCIAL  ----------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/

// Ruta para obtener amigos
router.post('/obtenerAmigos', perfilController.obtenerAmigos);
// Ruta para añadir amigos
router.post('/agnadirAmigo', perfilController.agnadirAmigo);
// Ruta para eliminar amigos
router.post('/eliminarAmigo', perfilController.eliminarAmigo);
// Ruta para enviar solicitudes de amistad
router.post('/enviarSolicitud', perfilController.enviarSolicitudAmistad);
// Ruta para eliminar solicitudes de amistad
router.post('/eliminarSolicitud', perfilController.eliminarSolicitudAmistad);

module.exports = router;