// Lista de reacciones disponibles
const Reacciones = {
    usuario: { type: String, required: true},
    estado: { type: String, enum: [ 'LIKE', 'DISLIKE', 'XD', ':)', ':(', 'OK!', 'LOL', 'OMG', 'WOW'], default: 'LIKE'}
};

module.exports = Reacciones;