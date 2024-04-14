/** 
 * @module data/tablero
 * @requires module:data/barco
*/

/**
 * @typedef {Object} Tablero
 * @property {Barco[]} barcos
 * @memberof module:data/tablero
 * @description Tipo de dato Tablero, formado por un array de barcos
 * @example { barcos: [ { coordenadas: [ { x: 1, y: 1 }, { x: 1, y: 2 } ] } ] }
 */

const {Barco} = require('./barco');

// Definir el tipo de datos Tablero
const Tablero = [Barco];

module.exports = Tablero;