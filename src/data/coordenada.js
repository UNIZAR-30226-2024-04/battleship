/** 
 * @module data/coordenada
 * @description Tipo de dato Coordenada
*/


/**
 * @typedef Coordenada
 * @property {Number} i.required - Coordenada i
 * @property {Number} j.required - Coordenada j
 * @property {String} estado - Estado de la coordenada: 'Agua', 'Tocado', 'Hundido'
 * @memberof module:data/coordenada
 * @file src/data/coordenada.js
 * @description Tipo de dato Coordenada
 * @example { i: 1, j: 1, estado: 'Agua' }
 */

// Definir el tipo de datos Coordenada
const Coordenada = {
    i: { type: Number, required: true, min: 1, max: 10 },
    j: { type: Number, required: true, min: 1, max: 10 },
    estado: { type: String, enum: ['Agua', 'Tocado', 'Hundido'], default: 'Agua'}
};

module.exports = Coordenada;