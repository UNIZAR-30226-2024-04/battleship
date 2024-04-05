const jwt = require('jsonwebtoken');
const config = require('../config/auth.config');
const Perfil = require('../models/perfilModel');

const verificarToken = async (req, res, next) => {
    let token = req.headers['x-access-token'];
    if (!token) {
        return res.status(403).send({ message: 'No se ha proporcionado un token' });
    }

    jwt.verify(token, config.secret, async (err, decoded) => {
        if (err) {
            return res.status(401).send({ message: 'No autorizado' });
        }
        req.nombreId = decoded.id;
        const perfil = await Perfil.findOne({ nombreId: req.nombreId });
        if (!perfil) {
            return res.status(404).send({ message: 'Perfil no encontrado' });
        }
        next();
    });
};

module.exports = verificarToken;
