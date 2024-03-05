const express = require('express');
const router = express.Router();

// Ruta al fichero controlador de perfil
const perfilController = require('../controllers/perfilController');

// Ruta para crear perfil
router.post('/perfiles', perfilController.crearPerfil);

module.exports = router;