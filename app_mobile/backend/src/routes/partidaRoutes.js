const express = require('express');
const router = express.Router();
const partidaController = require('../controllers/partidaController');
const verificarToken = require('../middlewares/authjwt');
const verificarRegistro = require('../middlewares/verificarRegistro');

// Ruta para registrar usuario
router.post('/realizarDisparo', partidaController.realizarDisparo);
router.post('/actualizarEstadoPartida', partidaController.actualizarEstadoPartida);
router.post('/crearPartida', partidaController.crearPartida);
// Ruta para iniciar sesión
//router.post('/inicioSesion', perfilController.iniciarSesion);
// Ruta para modificar perfil
//router.post('/modificarPerfil', verificarToken, perfilController.modificarPerfil);
// Ruta para obtener perfil
//router.get('/obtenerPerfil', perfilController.obtenerPerfil);

// Ruta para crear perfil
// router.post('../perfil', perfilController.crearPerfil);
// Rutas para modificar perfil
// router.post('/perfiles', perfilController.modificarPerfilDatosPersonales);
// router.post('/perfiles', perfilController.modificarMazo);
//router.post('/moverBarcoInicial', perfilController.moverBarcoInicial);
// router.post('/perfiles', perfilController.actualizarEstadisticas);
// // Ruta para eliminar perfil
// router.post('/perfiles', perfilController.eliminarPerfil);
// // Ruta para obtener perfil
// router.get('/perfil', perfilController.obtenerUsuario);
//router.post('/obtenerUsuario', perfilController.obtenerUsuario);
// // Ruta para iniciar sesión
// router.post('/perfiles', perfilController.iniciarSesion);
// // Ruta para registrar usuario
// router.post('/perfiles', perfilController.registrarUsuario);
// // Ruta para autenticar usuario
// router.post('/perfiles', perfilController.autenticarUsuario);

module.exports = router;