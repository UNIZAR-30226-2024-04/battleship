const express = require('express');
const mongoose = require("mongoose");
const perfilRoutes = require('./routes/perfilRoutes');

const app = express();

const mongoURI = "mongodb://developer:password@localhost:27017/BattleshipDB";

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
    res.header('Access-Control-Allow-Origin', 'http://localhost:27017/');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
});

// Middleware para parsear el body de las peticiones
app.use(express.json());

// Rutas
app.use('/profile', perfilRoutes);

module.exports = app;