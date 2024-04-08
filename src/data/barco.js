const Coordenada = require('./coordenada');

/** 
 * @module data/barco
 * @requires module:data/coordenada
 * @description Tipo de dato Barco
*/

/**
 * @typedef {Object} Barco
 * @property {Coordenada[]} coordenadas.required - Coordenadas del barco
 * @property {String} tipo.required - Tipo de barco
 * @memberof module:data/barco
 * @description Tipo de dato Barco
 */

// Definir el tipo de datos Barco
const Barco = {
    coordenadas: { type: [Coordenada], required: true },
    tipo: { type: String, required: true, enum: ['Acorazado', 'Fragata', 'Submarino', 'Patrullera'] }
};
  
module.exports = Barco;