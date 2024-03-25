// Definir el tipo de datos Coordenada
const Coordenada = {
    i: { type: Number, required: true, min: 1, max: 10 },
    j: { type: Number, required: true, min: 1, max: 10 },
    estado: { type: String, enum: ['Agua', 'Tocado', 'Hundido'], default: 'Agua'}
};

module.exports = Coordenada;