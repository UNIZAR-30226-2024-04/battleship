const mongoose = require('mongoose');
const { actualizarEstadisticas } = require('../controllers/perfilController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      // Lista de perfiles a crear
      const perfiles = [
        { nombreId: 'usuario1', resultado: true, nuevosBarcosHundidos: 4, nuevosBarcosPerdidos:1, 
            nuevosDisparosAcertados: 8, nuevosDisparosFallados: 10 },   // Victoria
        { nombreId: 'usuario1', resultado: false, nuevosBarcosHundidos: 1, nuevosBarcosPerdidos:1, 
            nuevosDisparosAcertados: 1, nuevosDisparosFallados: 1 },   // Derrota
        { nombreId: 'usuario3', resultado: true, nuevosBarcosHundidos: 4, nuevosBarcosPerdidos:1, 
        nuevosDisparosAcertados: 8, nuevosDisparosFallados: 10 },  // No existente
        { resultado: true, nuevosBarcosHundidos: 4, nuevosBarcosPerdidos:1, 
            nuevosDisparosAcertados: 8, nuevosDisparosFallados: 10 }, // Falta nombreId

      ];

      for (const perfil of perfiles) {
        const req = { body: perfil };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await actualizarEstadisticas(req, res);
      }
    } catch (error) {
      console.error('Error en el test de crear perfil:', error);
    } finally {
      // Cierra la conexión a la base de datos al finalizar
      mongoose.disconnect();
    }
  })
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));





