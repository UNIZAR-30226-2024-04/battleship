/** 
 * @module data/tablero
 * @requires module:data/barco
 * @description Tipo de dato Tablero
*/

/**
 * @typedef {Object} Tablero
 * @property {Barco[]} barcos
 * @memberof module:data/tablero
 * @file src/data/tablero.js
 * @description Tipo de dato Tablero
 * @example { barcos: [ { coordenadas: [ { x: 1, y: 1 }, { x: 1, y: 2 } ] } ] }
 */

const Barco = require('./barco');

// Definir el tipo de datos Tablero
const Tablero = [Barco];
    
module.exports = Tablero;