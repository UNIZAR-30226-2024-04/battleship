const mongoose = require('mongoose');
// MongoDB no ofrece funcionalidad de campos publicos o privados
// La privacidad de los datos la manejamos en el servidor/API

const Schema = mongoose.Schema;

// Partida Schema
const partidaSchema = new mongoose.Schema({
  chat: [{ mensaje: String, autor: mongoose.Schema.Types.ObjectId, timestamp: Date }],
  contadorTurno: { type: Number, default: 1}, // Jugador 1 juga si es impar, jugador 2 si es par
  jugador1: { // Perfil del jugador 1
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Perfil', 
    required: true 
  },
  jugador2: { // Perfil del jugador 2
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Perfil', 
    required: true 
  },
  tableroBarcos1: { // Lista barcos del jugador 1
    type: [{
      coordenadas: [{ // Barco = lista de coordenadas y estado
        type: [{      // Coordenada = par (x, y) con un booleano de tocada
          x: { type: Number, required: true, min: 1, max: 10 },
          y: { type: Number, required: true, min: 1, max: 10 },
          tocada: { type: Boolean, default: false}
        }],
        required: true
      }],
      barcoHundido: { // Estado del barco
        type: Boolean,
        default: false
      }
    }],
    required: true
  },
  tableroBarcos2: { // Lista barcos del jugador 2
    type: [{
      coordenadas: [{ // Barco = lista de coordenadas y estado
        type: [{      // Coordenada = par (x, y) con un booleano de tocada
          x: { type: Number, required: true, min: 1, max: 10 },
          y: { type: Number, required: true, min: 1, max: 10 },
          tocada: { type: Boolean, default: false}
        }],
        required: true
      }],
      barcoHundido: { // Estado del barco
        type: Boolean,
        default: false
      }
    }],
    required: true
  },
  disparosRealizados1: {  // Lista con los disparos realizados por J1
    type: [{  // Disparo = par (x, y) con resultado Agua/Tocado/Hundido
      x: { type: Number, required: true, min: 1, max: 10 },
      y: { type: Number, required: true, min: 1, max: 10 },
      resultado: {
        type: String,
        enum: ['Agua', 'Tocado', 'Hundido'],
        required: true
      }
    }],
    default: [] // Valor predeterminado como un array vacío
  },
  disparosRealizados2: {  // Lista con los disparos realizados por J2
    type: [{  // Disparo = par (x, y) con resultado Agua/Tocado/Hundido
      x: { type: Number, required: true, min: 1, max: 10 },
      y: { type: Number, required: true, min: 1, max: 10 },
      resultado: {
        type: String,
        enum: ['Agua', 'Tocado', 'Hundido'],
        required: true
      }
    }],
    default: [] // Valor predeterminado como un array vacío
  },
  clima: {  // Clima actual Calma/Viento/Tormenta/Niebla
    type: String,
    enum: ['Calma', 'Viento', 'Tormenta', 'Niebla'],
    required: true
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
    type: [{  // Mina = par (x, y)
      x: { type: Number, required: true, min: 1, max: 10 },
      y: { type: Number, required: true, min: 1, max: 10 },
    }],
    default: [] // Valor predeterminado como un array vacío
  },
  minas2: {  // Lista con las minas colocadas por J2
    type: [{  // Mina = par (x, y)
      x: { type: Number, required: true, min: 1, max: 10 },
      y: { type: Number, required: true, min: 1, max: 10 },
    }],
    default: [] // Valor predeterminado como un array vacío
  },
  bioma: {  // Bioma en el que se va a jugar la partida y que se caracteriza por una mayor probabilidad de clima
    type: String,
    enum: ['Mediterraneo', 'Cantabrico', 'Norte', 'Bermudas'],
    required: true
  }
}, { timestamps: true }); // timestamps añade automáticamente campos para 'createdAt' y 'updatedAt'


const Partida = mongoose.model('Partida', partidaSchema);
module.exports = Perfil;
