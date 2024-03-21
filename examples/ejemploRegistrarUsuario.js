const mongoose = require('mongoose');
const { registrarUsuario } = require('../controllers/perfilController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {

      const perfiles = [
        { nombreId: 'usuario4', contraseña: 'Passwd4.', correo: 'usuario4@example.com' },
        { nombreId: 'usuario1', contraseña: 'Passwd1.', correo: 'usuario1@example.com', extra: 1 }, // Sobran campos
        { nombreId: 'usuario4', contraseña: 'Passwd4.', correo: 'usuario4@example.com' },  // Ya existente
        { contraseña: 'Passwd1.', correo: 'usuario1@example.com' },                        // Falta un campo
        { nombreId: 'usuario4', contraseña: 'passwd1.', correo: 'usuario1@example.com' }, // Contraseña inválida
        { nombreId: 'usuario4', contraseña: 'Passwd1.', correo: 'usuario1example.com' },  // Correo inválido
      ];

      for (const perfil of perfiles) {
        const req = { body: perfil };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await registrarUsuario(req, res);
      }
    } catch (error) {
      console.error('Error en el test de crear perfil:', error);
    } finally {
      // Cierra la conexión a la base de datos al finalizar
      mongoose.disconnect();
    }
  })
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));





