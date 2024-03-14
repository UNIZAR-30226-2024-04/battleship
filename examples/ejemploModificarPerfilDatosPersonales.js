const mongoose = require('mongoose');
const { modificarPerfilDatosPersonales } = require('../controllers/perfilController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      // Lista de perfiles a crear
      const perfiles = [
        { nombreId: 'usuario1', contraseña: 'Passwd1.', correo: 'MODIFICADOusuario1@example.com' }, // Correo modificado
        { nombreId: 'usuario1', contraseña: 'MODIFICADAPasswd1.', correo: 'MODIFICADOusuario1@example.com' }, // Contraseña modificada
        { nombreId: 'usuario3', contraseña: 'Passwd3.', correo: 'usuario3@example.com' },  // No existente
        { contraseña: 'Passwd1.', correo: 'usuario1@example.com' },                        // Falta un campo
        { nombreId: 'usuario1', contraseña: 'Passwd12', correo: 'usuario1@example.com' }, // Contraseña inválida
        { nombreId: 'usuario1', contraseña: 'Passwd1.', correo: 'usuario1example.com' },  // Correo inválido

      ];

      for (const perfil of perfiles) {
        const req = { body: perfil };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await modificarPerfilDatosPersonales(req, res);
      }
    } catch (error) {
      console.error('Error en el test de crear perfil:', error);
    } finally {
      // Cierra la conexión a la base de datos al finalizar
      mongoose.disconnect();
    }
  })
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));





