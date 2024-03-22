// Definir el tipo de datos Coordenada
const Coordenada = {
    x: { type: Number, required: true, min: 1, max: 10 },
    y: { type: Number, required: true, min: 1, max: 10 },
    estado: { type: String, enum: ['Agua', 'Tocado', 'Hundido'], default: 'Agua'}
};

module.exports = Coordenada;