const express = require('express');
const mongoose = require("mongoose");

const perfilRoutes = require('./routes/perfilRoutes');
const partidaRoutes = require('./routes/partidaRoutes');
const partidaMultiRoutes = require('./routes/partidaMultiRoutes');
const publicacionRoutes = require('./routes/publicacionRoutes');
const chatRoutes = require('./routes/chatRoutes');
app = express();

const { mongoURI } = require('./uri');

app.connectDatabase = async () => {
    try {
        await mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true });
        console.log("Connected to MongoDB");
    } catch (err) {
        console.error("Could not connect to MongoDB", err);
    }
};

app.connectDatabase();

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'x-access-token, Content-Type, Origin, Accept, authorization');
    next();
});

// Middleware para parsear el body de las peticiones
app.use(express.json());

app.use(express.urlencoded({ extended: true }));

// Rutas
app.use('/perfil', perfilRoutes);
app.use('/partida', partidaRoutes);
app.use('/partidaMulti', partidaMultiRoutes);
app.use('/publicacion', publicacionRoutes);
app.use('/chat', chatRoutes);

app.get('/', (req, res) => {
    res.json({ message: 'API de Battleship' });
});

module.exports = app;