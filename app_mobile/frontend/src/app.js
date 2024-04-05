const express = require("express");
const mongoose = require("mongoose");
const app = express();
const cors = require('cors');

const mongoURI = 'mongodb://localhost/BattleshipDB';

app.use(cors({}));

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

app.get("/", (req, res) => {
    res.status(200).json({ message: "Hola Mundo!" });
});

// Define un esquema para la colección 'personas'
const personaSchema = new mongoose.Schema({
    nombre: String,
    edad: Number,
    // Agrega más campos según sea necesario
});

// Crea un modelo de Mongoose basado en el esquema definido
const Persona = mongoose.model("Persona", personaSchema);

app.get("/personas", async (req, res) => {
    try {
        const personas = await Persona.find(); // Encuentra todas las personas
        res.status(200).json({ message: personas });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = app;

