/** 
 * @module data/coordenada
 * @description Tipo de dato Coordenada
*/

/**
 * @typedef {String} EstadoCoordenada
 * @description Estado de la coordenada
 * @memberof module:data/coordenada
 * @default 'Agua'
 * @example 'Agua'
 * @example 'Tocado'
 * @example 'Hundido'
 */

/**
 * @typedef Coordenada
 * @property {Number} i.required - Coordenada i
 * @property {Number} j.required - Coordenada j
 * @property {EstadoCoordenada} estado - Estado de la coordenada
 * @memberof module:data/coordenada
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