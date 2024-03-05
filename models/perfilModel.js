const mongoose = require('mongoose');
// MongoDB no ofrece funcionalidad de campos publicos o privados
// La privacidad de los datos la manejamos en el servidor/API

const Schema = mongoose.Schema;

// Perfil Schema
const perfilSchema = new Schema({
  nombreId: { type: String, required: true },               // IDENTIFICADOR OBLIGATORIO: Nombre de usuario
  contraseña: { type: String, required: true },             // OBLIGATORIA: Contraseña usuario
  trofeos: { type: Number, default: 0 },                    // Trofeos del usuario (ELO)
  puntosExperiencia: { type: Number, default: 0 },          // Puntos que determinan el nivel del usuario
  tableroInicial: [                                         // Lista de barcos iniciales
    {
      proa: { type: [Number], required: true },             // Coordenadas de la proa del barco (delante)
      popa: { type: [Number], required: true }              // Coordenadas de la popa del barco (detras)
    }
  ],
  mazoHabilidadesElegidas: { type: [Number], default: [] }, // Habilidades(enteros) elegidas de una lista fija
  correo: { type: String, required: true },                 // OBLIGATORIO: Correo electrónico del usuario
  partidasJugadas: { type: Number, default: 0 },            // Estadísticas de partidas: Jugadas, ganadas, etc
  partidasGanadas: { type: Number, default: 0 },
  barcosEnemigosHundidos: { type: Number, default: 0 },
  barcosAliadosPerdidos: { type: Number, default: 0 }
});

const Perfil = mongoose.model('Perfil', perfilSchema);

module.exports = Perfil;
