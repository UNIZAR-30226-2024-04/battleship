const mongoose = require('mongoose');
const {registrarUsuario} = require('../controllers/perfilController');
const Torneo = require('../models/torneoModel');
const {comprobarTorneo, crearSalaTorneo, buscarSalaTorneo} = require('../controllers/torneoController');

const { mongoURI } = require('../uri');
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true, 
  useCreateIndex: true, useFindAndModify: false});

// redirect console.log and console.error to /dev/null
console.error = function() {};
console.log = function() {};

// Test for comprobarTorneo
describe('Comprobar torneo', () => {
    beforeAll(async () => {
        const connection = mongoose.connection;
        await connection.dropDatabase();
        const req = { body: { nombreId: 'usuario1', contraseña: 'Passwd1.',
        correo: 'usuario1@example.com' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(undefined);

       var torneo = new Torneo({
            codigo: 'torneo1',
            numeroVictorias: 1,
            numeroMaxDerrotas: 1
        });
        await torneo.save();
        console.log('Torneo creado:', torneo);
    });
    it('Comprueba si un torneo existe', async () => {
        const req = { body: { nombreId: 'usuario1', torneo: 'torneo1' } };
        let res = { json: function(_json) {this._json = _json; return this;}, status: function(s) {
          this.statusCode = s; return this; }, send: () => {} };
        await comprobarTorneo(req, res);
        expect(res.statusCode).toBe(undefined);
        expect(res._json.existe).toBe(true);
        expect(res._json.puedeUnirse).toBe(true);
        expect(res._json.haGanado).toBe(false);
    });
    it('Comprueba si un torneo no existe', async () => {
        const req = { body: { nombreId: 'usuario1', torneo: 'torneo2' } };
        let res = { json: function(_json) {this._json = _json; return this;}, status: function(s) {
          this.statusCode = s; return this; }, send: () => {} };
        await comprobarTorneo(req, res);
        expect(res.statusCode).toBe(undefined);
        expect(res._json.existe).toBe(false);
        expect(res._json.puedeUnirse).toBe(false);
        expect(res._json.haGanado).toBe(false);
    });
    it('Comprueba si un jugador ya ha ganado un torneo', async () => {
        torneo = await Torneo.findOneAndUpdate({codigo: 'torneo1'},
            {ganadores: [{nombreId: 'usuario1'}]});
        const req = { body: { nombreId: 'usuario1', torneo: 'torneo1' } };
        let res = { json: function(_json) {this._json = _json; return this;}, status: function(s) {
          this.statusCode = s; return this; }, send: () => {} };
        await comprobarTorneo(req, res);
        expect(res.statusCode).toBe(undefined);
        expect(res._json.existe).toBe(true);
        expect(res._json.puedeUnirse).toBe(false);
        expect(res._json.haGanado).toBe(true);
    });
    it('Comprueba si un jugador ya ha perdido un torneo', async () => {
        torneo = await Torneo.findOneAndUpdate({codigo: 'torneo1'},
            {participantes: [{nombreId: 'usuario1', derrotas: 2}], ganadores: []});
        const req = { body: { nombreId: 'usuario1', torneo: 'torneo1' } };
        let res = { json: function(_json) {this._json = _json; return this;}, status: function(s) {
          this.statusCode = s; return this; }, send: () => {} };
        await comprobarTorneo(req, res);
        expect(res.statusCode).toBe(undefined);
        expect(res._json.existe).toBe(true);
        expect(res._json.puedeUnirse).toBe(false);
        expect(res._json.haGanado).toBe(false);
    });
  });

// Test for crearSalaTorneo
describe('Crear sala de torneo', () => {
      beforeAll(async () => {
        const connection = mongoose.connection;
        await connection.dropDatabase();
        const req = { body: { nombreId: 'usuario1', contraseña: 'Passwd1.',
        correo: 'usuario1@example.com' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(undefined);

       var torneo = new Torneo({
            codigo: 'torneo1',
            numeroVictorias: 1,
            numeroMaxDerrotas: 1
        });
        await torneo.save();
        console.log('Torneo creado:', torneo);
    });
    it('Falla al crear una sala de torneo', async () => {
        const req = { body: { nombreId: 'usuario1', torneo: 'torneo2' } };
        let res = { json: function(_json) {this._json = _json; return this;}, status: function(s) {
          this.statusCode = s; return this; }, send: () => {} };
        await crearSalaTorneo(req, res);
        expect(res.statusCode).toBe(400);
    });
    afterAll(() => {
      mongoose.disconnect();
    });
});