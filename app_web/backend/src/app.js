const express = require('express');
const mongoose = require("mongoose");
const perfilRoutes = require('./routes/perfilRoutes');

const app = express();

const mongoURI = 'mongodb://localhost/BattleshipDB';

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
    res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'x-access-token, Content-Type, Origin, Accept');
    next();
});

// Middleware para parsear el body de las peticiones
app.use(express.json());

app.use(express.urlencoded({ extended: true }));

// Rutas
app.use('/perfil', perfilRoutes);

app.get('/', (req, res) => {
    res.json({ message: 'API de Battleship' });
});

module.exports = app;