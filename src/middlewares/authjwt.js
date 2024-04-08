const jwt = require('jsonwebtoken');
const config = require('../config/auth.config');
const Perfil = require('../models/perfilModel');

const verificarToken = async (req, res, next) => {
    let token = req.headers['authorization'];
    if (token.startsWith('Bearer ')) {
        token = token.slice(7, token.length);
    }
    if (!token) {
        return res.status(403).send({ message: 'No se ha proporcionado un token' });
    }
    jwt.verify(token, config.secret, async (err, decoded) => {
        if (err) {
            return res.status(401).send({ message: 'No autorizado' });
        }
        if (decoded.id !== req.body.nombreId) {
            return res.status(401).send({ message: 'El token no corresponde al usuario' });
        }

        const perfil = await Perfil.findOne({ nombreId: decoded.id });
        if (!perfil) {
            return res.status(404).send({ message: 'Perfil no encontrado' });
        }
        next();
    });
};

module.exports = verificarToken;
