const got = require('got');
const mongoose = require('mongoose');

// definir las URI a testear
const registrarUsuarioURI = 'http://localhost:8080/perfil/registrarUsuario';
const iniciarSesionURI = 'http://localhost:8080/perfil/iniciarSesion';
const obtenerUsuarioURI = 'http://localhost:8080/perfil/obtenerUsuario';
const obtenerDatosPersonalesURI = 'http://localhost:8080/perfil/obtenerDatosPersonales';

// definir las credenciales de prueba
const credenciales = {
    nombreId: 'usuario',
    correo: 'usuario@example.com',
    contraseña: 'Passwd1.'
};

// Conexión a la base de datos para borrarla
const mongoURI = 'mongodb://localhost/BattleshipDB';
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true, 
  useCreateIndex: true, useFindAndModify: false});

// redirect console.log and console.error to /dev/null
console.error = function() {};
console.log = function() {};

var token = '';
// Test de integración
describe('Pruebas de integración', function() {
    beforeAll(async () => {
        const connection = mongoose.connection;
        await connection.dropDatabase();
    });
    it('Registrar usuario mediante la ruta', async () => {
        token = await got.post(registrarUsuarioURI, {
            json: credenciales
        })
        .then(response => {
            response.body = JSON.parse(response.body);
            token = response.body.token;
            expect(response.statusCode).toBe(200);
            return token;
        });
    });
    it('Iniciar sesión mediante la ruta', async () => {
        token = await got.post(iniciarSesionURI, {
            json: {
                nombreId: credenciales.nombreId,
                contraseña: credenciales.contraseña
            }
        })
        .then(response => {
            response.body = JSON.parse(response.body);
            token = response.body.token;
            expect(response.statusCode).toBe(200);
            return token;
        });
    });
    it('Obtener usuario mediante la ruta', async () => {
        await got.post(obtenerUsuarioURI, {
            json: {
                nombreId: credenciales.nombreId
            }
        })
        .then(response => {
            response.body = JSON.parse(response.body);
            expect(response.statusCode).toBe(200);
            expect(response.body.nombreId).toBe(credenciales.nombreId);
            expect(response.body.correo).toBe(undefined);
        });
    });
    it('Obtener datos personales mediante la ruta', async () => {
        await got.post(obtenerDatosPersonalesURI, {
            json: {
                nombreId: credenciales.nombreId
            }, headers: { "Authorization": `Bearer ${token}` }
        })
        .then(response => {
            response.body = JSON.parse(response.body);
            expect(response.statusCode).toBe(200);
            expect(response.body.nombreId).toBe(credenciales.nombreId);
            expect(response.body.correo).toBe(credenciales.correo);
        });
    });
    afterAll(() => {
        mongoose.disconnect();
    });
});