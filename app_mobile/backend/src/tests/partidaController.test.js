const mongoose = require('mongoose');
const {crearPartida, mostrarMiTablero, mostrarTableroEnemigo,
    mostrarTableros, realizarDisparo, enviarMensaje, obtenerChat} = require('../controllers/partidaController');
const {registrarUsuario, autenticarUsuario, eliminarUsuario, iniciarSesion, 
    modificarDatosPersonales, obtenerUsuario, actualizarEstadisticas,
    actualizarPuntosExperiencia, modificarMazo, moverBarcoInicial,
    enviarSolicitudAmistad, eliminarSolicitudAmistad, agnadirAmigo, eliminarAmigo} = require('../controllers/perfilController');
  
const mongoURI = 'mongodb://localhost/BattleshipDB';
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true, 
  useCreateIndex: true, useFindAndModify: false});

// redirect console.log and console.error to /dev/null
console.error = function() {};
console.log = function() {};

// Test for crearPartida
describe("Crear partida", () => {
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
        const req2 = { body: { nombreId: 'usuario2', contraseña: 'Passwd2.',
        correo: 'usuario2@example.com' } };
        const res2 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req2, res2);
        } catch (error) {}
        expect(res2.statusCode).toBe(undefined);
    });
    it("Debería crear una partida correctamente", async () => {
        const req = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req, res);
            }
        catch (error) {}
        expect(res.statusCode).toBe(undefined);
    });
    it("Debería fallar al crear una partida con demasiados campos", async () => {
        const req = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte', extra: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al crear una partida sin jugador 1", async () => {
        const req = { body: { nombreId2: 'usuario1', bioma: 'Norte' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al crear una partida con un bioma no disponible", async () => {
        const req = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Murcia' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al crear una partida con un jugador 1 inexistente", async () => {
        const req = { body: { nombreId1: 'usuario5', nombreId2: 'usuario1', bioma: 'Norte' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
    it("Debería fallar al crear una partida con un jugador 2 inexistente", async () => {
        const req = { body: { nombreId1: 'usuario1', nombreId2: 'usuario5', bioma: 'Norte' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
    it("Debería fallar al crear una partida con jugadores iguales", async () => {
        const req = { body: { nombreId1: 'usuario1', nombreId2: 'usuario1', bioma: 'Norte' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
});

var _codigo = 0;
// Test for mostrarMiTablero
describe("Mostrar mi tablero", () => {
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
        const req2 = { body: { nombreId: 'usuario2', contraseña: 'Passwd2.',
        correo: 'usuario2@example.com' } };
        const res2 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req2, res2);
        } catch (error) {}
        expect(res2.statusCode).toBe(undefined);
        const req3 = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte' } };
        const res3 = { json: function(_json) {this._json = _json; return this;}, status: function(s) { 
            this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req3, res3);
        } catch (error) {}
        expect(res3.statusCode).toBe(undefined);
        _codigo = res3._json.codigo;
    });
    it("Debería mostrar mi tablero correctamente", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarMiTablero(req, res);
            }
        catch (error) {}
        expect(res.statusCode).toBe(undefined);
    });
    it("Debería fallar al mostrar mi tablero con demasiados campos", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1' , extra: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarMiTablero(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al mostrar mi tablero sin jugador", async () => {
        const req = { body: { codigo: _codigo } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarMiTablero(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al mostrar mi tablero con un jugador inválido", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario3'  } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarMiTablero(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
    it("Debería fallar al mostrar mi tablero con un código de partida inexistente", async () => {
        const req = { body: { codigo: 1, nombreId: 'usuario1' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarMiTablero(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
});

_codigo = 1;
// Test for mostrarTableroEnemigo
describe("Mostrar tablero enemigo", () => {
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
        const req2 = { body: { nombreId: 'usuario2', contraseña: 'Passwd2.',
        correo: 'usuario2@example.com' } };
        const res2 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req2, res2);
        } catch (error) {}
        expect(res2.statusCode).toBe(undefined);
        const req3 = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte' } };
        const res3 = { json: function(_json) {this._json = _json; return this;}, status: function(s) { 
            this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req3, res3);
        } catch (error) {}
        expect(res3.statusCode).toBe(undefined);
        _codigo = res3._json.codigo;
    });
    it("Debería mostrar el tablero enemigo correctamente", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableroEnemigo(req, res);
            }
        catch (error) {}
        expect(res.statusCode).toBe(undefined);
    });
    it("Debería fallar al mostrar el tablero enemigo con demasiados campos", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1' , extra: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableroEnemigo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al mostrar el tablero enemigo sin jugador", async () => {
        const req = { body: { codigo: _codigo } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableroEnemigo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al mostrar el tablero enemigo con un jugador inválido", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario3' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableroEnemigo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
    it("Debería fallar al mostrar el tablero enemigo con un código de partida inexistente", async () => {
        const req = { body: { codigo: 1, nombreId: 'usuario1' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableroEnemigo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
});

// Test for mostrarTableros
describe("Mostrar tableros", () => {
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
        const req2 = { body: { nombreId: 'usuario2', contraseña: 'Passwd2.',
        correo: 'usuario2@example.com' } };
        const res2 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req2, res2);
        } catch (error) {}
        expect(res2.statusCode).toBe(undefined);
        const req3 = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte' } };
        const res3 = { json: function(_json) {this._json = _json; return this;}, status: function(s) { 
            this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req3, res3);
        } catch (error) {}
        expect(res3.statusCode).toBe(undefined);
        // guardar el código de la partida
        _codigo = res3._json.codigo;
        console.log(_codigo);
    });
    it("Debería mostrar los tableros correctamente", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableros(req, res);
            }
        catch (error) {}
        expect(res.statusCode).toBe(undefined);
    });
    it("Debería fallar al mostrar los tableros con demasiados campos", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1' , extra: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableros(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al mostrar los tableros sin código de partida", async () => {
        const req = { body: {nombreId: 'usuario1' } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableros(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al mostrar los tableros sin usuario", async () => {
        const req = { body: {codigo: _codigo} };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableros(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al mostrar los tableros con un código de partida inexistente", async () => {
        const req = { body: { codigo: 1, nombreId: 'usuario1'  } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await mostrarTableros(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
});

// Test for realizarDisparo
describe("Realizar disparo", () => {
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
        const req2 = { body: { nombreId: 'usuario2', contraseña: 'Passwd2.',
        correo: 'usuario2@example.com' } };
        const res2 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req2, res2);
        } catch (error) {}
        expect(res2.statusCode).toBe(undefined);
        const req3 = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte' } };
        const res3 = { json: function(_json) {this._json = _json; return this;}, status: function(s) { 
            this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req3, res3);
        } catch (error) {}
        expect(res3.statusCode).toBe(undefined);
        _codigo = res3._json.codigo;
    });
    it("Debería realizar un disparo correctamente", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1', i: 1, j: 1 } };
        const res = { json: function(_json) {this._json = _json; return this;}, status: function(s) { 
            this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
            }
        catch (error) {}
        expect(res.statusCode).toBe(undefined);
    });
    it("Debería fallar al realizar un disparo con demasiados campos", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1', i: 1, j: 1, extra: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al realizar un disparo sin jugador", async () => {
        const req = { body: { codigo: _codigo, i: 1, j: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al realizar un disparo sin coordenadas", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1'} };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al realizar un disparo con un jugador inválido", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario3', i: 1, j: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
    it("Debería fallar al realizar un disparo con coordenadas inválidas", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1', i: -1, j: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al realizar un disparo con un código de partida inexistente", async () => {
        const req = { body: { codigo: 1, nombreId: 'usuario1', i: 1, j: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
    it("Debería fallar al no ser el turno del jugador", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario2', i: 1, j: 2 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería hundir el barco", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1', i: 1, j: 2 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(undefined);
    });
    it("Debería fallar al disparar al agua", async () => {
        const req = { body: { codigo: _codigo, nombreId: 'usuario1', i: 1, j: 3 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await realizarDisparo(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(undefined);
    });
});

// Test for enviarMensaje
describe("Enviar mensaje", () => {
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
        const req2 = { body: { nombreId: 'usuario2', contraseña: 'Passwd2.',
        correo: 'usuario2@example.com' } };
        const res2 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req2, res2);
        } catch (error) {}
        expect(res2.statusCode).toBe(undefined);
        const req3 = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte' } };
        const res3 = { json: function(_json) {this._json = _json; return this;}, status: function(s) { 
            this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req3, res3);
        } catch (error) {}
        expect(res3.statusCode).toBe(undefined);
        _codigo = res3._json.codigo;
    });
    it("Debería enviar un mensaje correctamente", async () => {
        const req = { body: { codigo: _codigo, autor: 1, mensaje: "Esto es una prueba" } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await enviarMensaje(req, res);
            }
        catch (error) {}
        expect(res.statusCode).toBe(undefined);
    });
    it("Debería fallar al enviar un mensaje con demasiados campos", async () => {
        const req = { body: { codigo: _codigo, autor: 1, mensaje: "Esto es una prueba", extra: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await enviarMensaje(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al enviar un mensaje sin autor", async () => {
        const req = { body: { codigo: _codigo, mensaje: "Esto es una prueba" } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await enviarMensaje(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al enviar un mensaje sin mensaje", async () => {
        const req = { body: { codigo: _codigo, autor: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await enviarMensaje(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al enviar un mensaje con un autor inválido", async () => {
        const req = { body: { codigo: _codigo, autor: 3, mensaje: "Esto es una prueba" } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await enviarMensaje(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al enviar un mensaje con un código de partida inexistente", async () => {
        const req = { body: { codigo: 1, autor: 1, mensaje: "Esto es una prueba" } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await enviarMensaje(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
});

// Test for obtenerChat
describe("Obtener chat", () => {
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
        const req2 = { body: { nombreId: 'usuario2', contraseña: 'Passwd2.',
        correo: 'usuario2@example.com' } };
        const res2 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
          await registrarUsuario(req2, res2);
        } catch (error) {}
        expect(res2.statusCode).toBe(undefined);
        const req3 = { body: { nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte' } };
        const res3 = { json: function(_json) {this._json = _json; return this;}, status: function(s) { 
            this.statusCode = s; return this; }, send: () => {} };
        try {
            await crearPartida(req3, res3);
        } catch (error) {}
        expect(res3.statusCode).toBe(undefined);
        _codigo = res3._json.codigo;
        const req4 = { body: { codigo: _codigo, autor: 1, mensaje: "Esto es una prueba" } };
        const res4 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await enviarMensaje(req4, res4);
        } catch (error) {}
        expect(res4.statusCode).toBe(undefined);
    });
    it("Debería obtener el chat correctamente", async () => {
        const req = { body: { codigo: _codigo } };
        const res = { json: function(_json) {this._json = _json; return this;}, status: function(s) { 
            this.statusCode = s; return this; }, send: () => {} };
        try {
            await obtenerChat(req, res);
        } catch (error) {}
        console.log(res._json);
        expect(res.statusCode).toBe(undefined);
        expect(res._json[0].mensaje).toBe("Esto es una prueba");
    });
    it("Debería fallar al obtener el chat con demasiados campos", async () => {
        const req = { body: { codigo: _codigo, extra: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await obtenerChat(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al obtener el chat sin código de partida", async () => {
        const req = { body: {} };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await obtenerChat(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(400);
    });
    it("Debería fallar al obtener el chat con un código de partida inexistente", async () => {
        const req = { body: { codigo: 1 } };
        const res = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this; }, send: () => {} };
        try {
            await obtenerChat(req, res);
        } catch (error) {}
        expect(res.statusCode).toBe(404);
    });
    afterAll(() => {
        mongoose.disconnect();
    });
});