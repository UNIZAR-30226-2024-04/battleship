const Coordenada = require('./coordenada');

/** 
 * @module data/barco
 * @requires module:data/coordenada
 * @description Tipo de dato Barco
*/

/**
 * @typedef {Object} Barco
 * @property {Coordenada[]} coordenadas
 * @memberof module:data/barco
 * @file src/data/barco.js
 * @description Tipo de dato Barco
 */

// Definir el tipo de datos Barco
const Barco = [Coordenada];
  
module.exports = Barco;