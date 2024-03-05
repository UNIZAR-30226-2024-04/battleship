const mongoose = require('mongoose');
// MongoDB no ofrece funcionalidad de campos publicos o privados
// La privacidad de los datos la manejamos en el servidor/API

const Schema = mongoose.Schema;

// Perfil Schema
const perfilSchema = new Schema({
  nombreId: {                // IDENTIFICADOR OBLIGATORIO: Nombre de usuario
    type: String, 
    required: true 
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
  tableroBarcos: {           // Lista barcos del jugador 
    type: [{
      coordenadas: [{        // Barco = lista de coordenadas y estado
        type: [{             // Cada coordenada es un par (x, y) con un booleano de tocada
          x: { type: Number, required: true, min: 1, max: 10 },
          y: { type: Number, required: true, min: 1, max: 10 },
          tocada: { type: Boolean, default: false}
        }],
        required: true        // Cada barco debe tener al menos una coordenada
      }],
      barcoHundido: {         // Estado del barco
        type: Boolean,
        default: false        // Por defecto no esta hundido
      }
    }],
    required: true
  },
  mazoHabilidadesElegidas: {  // Habilidades(enteros) elegidas de una lista fija
    type: [Number], 
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
  barcosEnemigosHundidos: {   // Estadísticas de barcos hundidos y perdidos
    type: Number, 
    default: 0 
  },
  barcosAliadosPerdidos: { 
    type: Number, 
    default: 0 
  }
});

const Perfil = mongoose.model('Perfil', perfilSchema);

module.exports = Perfil;
