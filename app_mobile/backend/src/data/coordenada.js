/** 
 * @module data/coordenada
*/

/**
 * @const estadosCoordenadaDisponibles
 * @memberof module:data/coordenada
 * @description Estados de la coordenada disponibles, con sus respectivos nombres
 * @enum {String}
 * @readonly
 * @default ['Agua', 'Tocado', 'Hundido']
 */
const estadosCoordenadaDisponibles = ['Agua', 'Tocado', 'Hundido'];

/**
 * @typedef Coordenada
 * @property {Number} i.required - Coordenada i
 * @property {Number} j.required - Coordenada j
 * @property {estadosCoordenadaDisponibles} estado - Estado de la coordenada
 * @memberof module:data/coordenada
 * @description Tipo de dato Coordenada
 * @example { i: 1, j: 1, estado: 'Agua' }
 */

// Definir el tipo de datos Coordenada
const Coordenada = {
    i: { type: Number, required: true, min: 1, max: 10 },
    j: { type: Number, required: true, min: 1, max: 10 },
    estado: { type: String, enum: estadosCoordenadaDisponibles, default: 'Agua'}
};

module.exports = Coordenada;