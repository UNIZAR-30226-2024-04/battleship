const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const verificarToken = require('../middlewares/authjwt');

// Ruta para obtener el chat
router.post('/obtenerChat', verificarToken, chatController.obtenerChat);

// Ruta para enviar mensaje
router.post('/enviarMensaje', verificarToken, chatController.enviarMensaje);

module.exports = router;