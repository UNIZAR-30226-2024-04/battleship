const mongoose = require('mongoose');
// MongoDB no ofrece funcionalidad de campos publicos o privados
// La privacidad de los datos la manejamos en el servidor/API

const Schema = mongoose.Schema;
const Reaccion = require('../data/reacciones');

/**
 * @module models/publicacionModel
 * @description Modelo de Publicacion
 * @requires mongoose
 * @requires data/reacciones
 */

/**
 * @typedef {Object} Publicacion
 * @property {String} publicacionId - Identificador de la publicación
 * @property {String} usuario - Usuario que publica
 * @property {String} texto - Texto de la publicación
 * @property {Reaccion[]} reacciones - Lista de reacciones a la publicacion
 */

// Publicacion Schema
const publicacionSchema = new Schema({
  publicacionId: {           // IDENTIFICADOR OBLIGATORIO: identificador de la publicación
    type: String, 
    required: true,
    unique: true
  },
  usuario: {                // OBLIGATORIO: Usuario que publica
    type: String, 
    required: true 
  },
  texto: {              // texto de la publicación
    type: String,
    required: true
  },
  reacciones: {             // Lista de reacciones a la publicacion
    type: [Reaccion],
    default: []
  }
});

const Publicacion = mongoose.model('Publicacion', publicacionSchema, 'Publicaciones');  // Publicaciones es la colección de publicaciones de BattleshipDB

module.exports = Publicacion;
