const mongoose = require('mongoose');
const { eliminarPerfil } = require('../controllers/perfilController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      // Lista de perfiles a crear
      const perfiles = [
        { nombreId: 'usuario2'},
        { nombreId: 'usuario2'},    // No existente
        { contraseña: 'Passwd1.'},  // Falta nombreId
      ];

      // Itera sobre la lista de perfiles y crea cada uno
      for (const perfil of perfiles) {
        const req = { body: perfil };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await eliminarPerfil(req, res); // Espera a que se complete la creación del perfil
      }
    } catch (error) {
      console.error('Error en el test de crear perfil:', error);
    } finally {
      // Cierra la conexión a la base de datos al finalizar
      mongoose.disconnect();
    }
  })
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));





