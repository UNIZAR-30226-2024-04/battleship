const express = require('express');
const router = express.Router();
const partidaMultiController = require('../controllers/partidaMultiController');
const verificarToken = require('../middlewares/authjwt');


// -------------------------------------------- //
// -------------- PARTIDA BASICA -------------- //
// -------------------------------------------- //

// Ruta para crear partida
router.post('/crearPartida', verificarToken, partidaMultiController.crearPartida);

// Ruta para realizar disparo
router.post('/realizarDisparo', verificarToken, partidaMultiController.realizarDisparo);

// Ruta para mostrar mi tablero
router.post('/mostrarMiTablero', verificarToken, partidaMultiController.mostrarMiTablero);

// Ruta para mostrar tablero enemigo
router.post('/mostrarTableroEnemigo', verificarToken, partidaMultiController.mostrarTableroEnemigo);

// Ruta para mostrar ambos tableros
router.post('/mostrarTableros', verificarToken, partidaMultiController.mostrarTableros);

// Ruta para abandonar partida
router.post('/abandonarPartida', verificarToken, partidaMultiController.abandonarPartida);


// -------------------------------------------- //
// ------------------ SALAS ------------------- //
// -------------------------------------------- //

// Ruta para buscar sala
router.post('/buscarSala', verificarToken, partidaMultiController.buscarSala);

// Ruta para crear una sala
router.post('/crearSala', verificarToken, partidaMultiController.crearSala);

// --------------------------------------------- //
// -------------- CHAT DE PARTIDA -------------- //
// --------------------------------------------- //

// Ruta para obtener el chat
router.post('/obtenerChat', verificarToken, partidaMultiController.obtenerChat);

// Ruta para enviar mensaje
router.post('/enviarMensaje', verificarToken, partidaMultiController.enviarMensaje);

module.exports = router;