const express = require('express');
const router = express.Router();
const partidaController = require('../controllers/partidaController');
const verificarToken = require('../middlewares/authjwt');
const verificarRegistro = require('../middlewares/verificarRegistro');

// Ruta para realizar disparo
router.post('/realizarDisparo', partidaController.realizarDisparo);

// Ruta para obtener partida
router.post('/actualizarEstadoPartida', partidaController.actualizarEstadoPartida);

// Ruta para crear partida
router.post('/crearPartida', partidaController.crearPartida);

// Ruta para 

module.exports = router;