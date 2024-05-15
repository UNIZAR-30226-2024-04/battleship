const mongoose = require('mongoose');
// MongoDB no ofrece funcionalidad de campos publicos o privados
// La privacidad de los datos la manejamos en el servidor/API



/**
 * @typedef {Object} Torneo
 * @memberof module:torneo
 * @property {String} codigo - Identificador del torneo
 * @property {Object[]} participantes - Lista de participantes
 * @property {String} participantes.nombreId - Nombre de usuario del participante
 * @property {Number} participantes.victorias - Número de victorias del participante
 * @property {Number} participantes.derrotas - Número de derrotas del participante
 * @property {String[]} ganadores - Lista de ganadores
 * @property {String} ganadores.nombreId - Nombre de usuario del ganador
 * @property {Number} numeroVictorias - Número de victorias para ganar el torneo
 * @property {Number} numeroMaxDerrotas - Número máximo de derrotas permitidas
 * 
 * @description Tipo de dato Torneo, formado por los datos de un torneo 
 * 
 */

// Torneo Schema
const torneoSchema = new mongoose.Schema({
  codigo: { // Identificador del torneo
    type: String,
    required: true,
    unique: true
  },
  participantes: { // Lista de participantes
    type: [{nombreId: String, victorias: Number, derrotas: Number}],
    default: []
  },
  ganadores: { // Ganadores del torneo
    type: [{nombreId: String}],
    default: []
  },
  numeroVictorias: { // Número de victorias para ganar el torneo
    type: Number,
    required: true
  },
  numeroMaxDerrotas: { // Número máximo de derrotas permitidas
    type: Number,
    required: true
  }
});

const Torneo = mongoose.model('Torneo', torneoSchema, 'Torneos');
module.exports = Torneo;