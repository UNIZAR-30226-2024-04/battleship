const express = require('express');
const router = express.Router();
const partidaController = require('../controllers/partidaController');
const verificarToken = require('../middlewares/authjwt');


// -------------------------------------------- //
// -------------- PARTIDA BASICA -------------- //
// -------------------------------------------- //

// Ruta para crear partida
router.post('/crearPartida', verificarToken, partidaController.crearPartida);

// Ruta para realizar disparo
router.post('/realizarDisparo', verificarToken, partidaController.realizarDisparo);

// Ruta para mostrar mi tablero
router.post('/mostrarMiTablero', verificarToken, partidaController.mostrarMiTablero);

// Ruta para mostrar tablero enemigo
router.post('/mostrarTableroEnemigo', verificarToken, partidaController.mostrarTableroEnemigo);

// Ruta para mostrar ambos tableros
router.post('/mostrarTableros', verificarToken, partidaController.mostrarTableros);

// Ruta para actualizar la partida (DEPRECATED)
router.post('/actualizarEstadoPartida', verificarToken, partidaController.actualizarEstadoPartida);

// Ruta para actualizar las estadisticas al terminar
router.post('/actualizarEstadisticasFinales', verificarToken, partidaController.actualizarEstadisticasFinales);


// --------------------------------------------- //
// -------------- CHAT DE PARTIDA -------------- //
// --------------------------------------------- //

// Ruta para obtener el chat
router.post('/obtenerChat', verificarToken, partidaController.obtenerChat);

// Ruta para enviar mensaje
router.post('/enviarMensaje', verificarToken, partidaController.enviarMensaje);

module.exports = router;