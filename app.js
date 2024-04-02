const express = require("express");
const mongoose = require("mongoose");
const app = express();

// Reemplaza 'myDatabase' con el nombre de tu base de datos
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

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Definir models
// const Persona = require('./models/Persona');
// const Partida = require('./models/Partida');




module.exports = app;

