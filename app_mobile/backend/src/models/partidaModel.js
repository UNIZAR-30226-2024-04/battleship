const mongoose = require('mongoose');
// MongoDB no ofrece funcionalidad de campos publicos o privados
// La privacidad de los datos la manejamos en el servidor/API

const Schema = mongoose.Schema;
const biomasDisponibles = require('../data/biomas')
const climasDisponibles = require('../data/climas');
const Tablero = require('../data/tablero');
const Coordenada = require('../data/coordenada');

/**
 * @module models/partidaModel
 * @description Modelo de Partida
 * @requires mongoose
 * @requires data/biomas
 * @requires data/climas
 * @requires data/tablero
 * @requires data/coordenada
 * @requires data/perfil
 * @requires models/perfilModel
 */

/**
 * @typedef {Object} mensajeChat
 * @property {String} mensaje - Mensaje del chat
 * @property {String} autor - Autor del mensaje
 * @property {Date} timestamp - Fecha y hora del mensaje
 */

/**
 * @typedef {Object} Partida
 * @property {Number} codigo - Identificador de la partida
 * @property {mensajeChat[]} chat - Lista de mensajes del chat
 * @property {Number} contadorTurno - Jugador 1 juga si es impar, jugador 2 si es par
 * @property {Perfil} jugador1 - Perfil del jugador 1
 * @property {Perfil} jugador2 - Perfil del jugador 2
 * @property {Tablero} tableroBarcos1 - Lista barcos del jugador 1
 * @property {Tablero} tableroBarcos2 - Lista barcos del jugador 2
 * @property {Coordenada[]} disparosRealizados1 - Lista con los disparos realizados por J1
 * @property {Coordenada[]} disparosRealizados2 - Lista con los disparos realizados por J2
 * @property {String} clima - Clima actual Calma/Viento/Tormenta/Niebla
 * @property {Number} usosHab1 - Total de usos restantes de habilidades del J1
 * @property {Number} usosHab2 - Total de usos restantes de habilidades del J2
 * @property {Coordenada[]} minas1 - Lista con las minas colocadas por J1
 * @property {Coordenada[]} minas2 - Lista con las minas colocadas por J2
 * @property {String} bioma - Bioma en el que se va a jugar la partida y que se caracteriza por una mayor probabilidad de clima
 * @property {Perfil} ganador - Perfil del jugador ganador
 */

// Partida Schema
const partidaSchema = new Schema({
  codigo: { // Identificador de la partida
    type: Number,
    required: true,
    unique: true
  },
  chat: {
    type: [{ mensaje: String, autor: mongoose.Schema.Types.ObjectId, timestamp: Date }],
    default: []
  },
  contadorTurno: { type: Number, default: 1}, // Jugador 1 juga si es impar, jugador 2 si es par
  jugador1: { // Perfil del jugador 1
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Perfil', 
    required: true 
  },
  jugador2: { // Perfil del jugador 2
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Perfil'
  },
  tableroBarcos1: { // Lista barcos del jugador 1
    type: Tablero,
    required: true
  },
  tableroBarcos2: { // Lista barcos del jugador 2
    type: Tablero,
    required: true
  },
  disparosRealizados1: {  // Lista con los disparos realizados por J1
    type: [Coordenada],
    default: [] // Valor predeterminado como un array vacío
  },
  disparosRealizados2: {  // Lista con los disparos realizados por J2
    type: [Coordenada],
    default: [] // Valor predeterminado como un array vacío
  },
  clima: {  // Clima actual Calma/Viento/Tormenta/Niebla
    type: String,
    enum: climasDisponibles,
    default: 'Calma'
  },
  usosHab1: { // Total de usos restantes de habilidades del J1
    type: Number, 
    default: 3
  },
  usosHab2: { // Total de usos restantes de habilidades del J2
    type: Number, 
    default: 3
  },
  minas1: {  // Lista con las minas colocadas por J1
    type: [Coordenada],
    default: [] // Valor predeterminado como un array vacío
  },
  minas2: {  // Lista con las minas colocadas por J2
    type: [Coordenada],
    default: [] // Valor predeterminado como un array vacío
  },
  bioma: {  // Bioma en el que se va a jugar la partida y que se caracteriza por una mayor probabilidad de clima
    type: String,
    enum: biomasDisponibles,
    required: true
  },
  ganador: {  // NombreId del jugador ganador
    type: 'String',
    default: ''
  }
}, { timestamps: true }); // timestamps añade automáticamente campos para 'createdAt' y 'updatedAt'

const Partida = mongoose.model('Partida', partidaSchema, 'Partidas');
module.exports = Partida;


