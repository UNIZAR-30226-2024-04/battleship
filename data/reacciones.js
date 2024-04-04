// Lista de reacciones disponibles
const posiblesReacciones = [ 'LIKE', 'DISLIKE', 'XD', ':)', ':(', 'OK!', 'LOL', 'OMG', 'WOW'];

const Reaccion = {
    nombreId: { type: String, required: true },
    estado: { type: String, enum: posiblesReacciones, required: true, default: 'LIKE'}
};



module.exports.Reaccion = Reaccion;
module.exports.posiblesReacciones = posiblesReacciones;