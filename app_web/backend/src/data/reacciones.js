
/** 
 * @module data/reacciones
*/

/**
 * @const posiblesReacciones
 * @memberof module:data/reacciones
 * @description Lista de reacciones disponibles para las publicaciones
 * @default ['LIKE', 'DISLIKE', 'XD', ':)', ':(', 'OK!', 'LOL', 'OMG', 'WOW']
 */
// Lista de reacciones disponibles
const posiblesReacciones = [ 'LIKE', 'DISLIKE', 'XD', ':)', ':(', 'OK!', 'LOL', 'OMG', 'WOW'];

/**
 * @typedef {Object} Reaccion
 * @property {String} nombreId
 * @property {posiblesReacciones} estado - Estado de la reacción
 * @memberof module:data/reacciones
 * @description Tipo de dato Reaccion, formado por un nombre de usuario y un estado de reacción
 * @example { nombreId: '1', estado: 'LIKE' }
 */
const Reaccion = {
    nombreId: { type: String, required: true },
    estado: { type: String, enum: posiblesReacciones, required: true, default: 'LIKE'}
};

module.exports.Reaccion = Reaccion;
module.exports.posiblesReacciones = posiblesReacciones;