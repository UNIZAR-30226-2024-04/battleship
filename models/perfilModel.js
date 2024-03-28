const mongoose = require('mongoose');
// MongoDB no ofrece funcionalidad de campos publicos o privados
// La privacidad de los datos la manejamos en el servidor/API

const Schema = mongoose.Schema;
const habilidadesDisponibles = require('../data/habilidades');
const Tablero = require('../data/tablero');
// Perfil Schema
const perfilSchema = new Schema({
  _id: {                     // IDENTIFICADOR OBLIGATORIO: Nombre de usuario
    type: String, 
    required: true,
    unique: true
  },
  contraseña: {              // OBLIGATORIA: Contraseña usuario
    type: String, 
    required: true 
  },
  trofeos: {                 // Trofeos del usuario (ELO)
    type: Number, 
    default: 0 
  },
  puntosExperiencia: {       // Puntos que determinan el nivel del usuario
    type: Number, 
    default: 0 
  },
  tableroInicial: {           // Lista barcos del jugador 
    type: Tablero,
    required: true
  },
  mazoHabilidades: {  // Habilidades(enteros) elegidas de una lista fija
    type: [{
      type: String,
      enum: habilidadesDisponibles}], 
    default: [] 
  },
  correo: {                  // OBLIGATORIO: Correo electrónico del usuario
    type: String, 
    required: true 
  },
  partidasJugadas: {         // Estadísticas de partidas: Jugadas, ganadas, etc
    type: Number,
     default: 0 
  },
  partidasGanadas: { 
    type: Number, 
    default: 0 
  },
  barcosHundidos: {   // Estadísticas de barcos hundidos y perdidos
    type: Number, 
    default: 0 
  },
  barcosPerdidos: { 
    type: Number, 
    default: 0 
  },
  disparosAcertados: {        // Estadísticas de disparos acertados y fallados
    type: Number, 
    default: 0 
  },
  disparosFallados: { 
    type: Number, 
    default: 0 
  }
});

// Virtual para obtener el id del perfil
partidaSchema.virtual('nombreId').get(function() {
  return this._id;
});

const Perfil = mongoose.model('Perfil', perfilSchema, 'Perfiles');  // Perfiles es la colección de perfiles de BattleshipDB

module.exports = Perfil;
