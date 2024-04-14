const Coordenada = require('./coordenada');

/** 
 * @module data/barco
 * @requires module:data/coordenada
*/

/**
 * @const {String} TipoBarco
 * @memberof module:data/barco
 * @description Tipos de barco posibles, con sus respectivos nombres
 * @enum {String}
 * @readonly
 * @default ['Acorazado', 'Destructor', 'Submarino', 'Patrullera', 'Portaviones']]
 */
const barcosDisponibles = ['Acorazado', 'Destructor', 'Submarino', 'Patrullera', 'Portaviones'];

/**
 * @typedef {Object} Barco
 * @property {Coordenada[]} coordenadas.required - Coordenadas del barco
 * @property {barcosDisponibles} tipo.required - Tipo de barco
 * @memberof module:data/barco
 * @description Tipo de dato Barco, formado por un array de coordenadas y un tipo de barco
 */

// Definir el tipo de datos Barco
const Barco = {
    coordenadas: { type: [Coordenada], required: true },
    tipo: { type: String, required: true, enum: barcosDisponibles }
};
  
module.exports = Barco;