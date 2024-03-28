const mongoose = require('mongoose');
const { iniciarPartida } = require('../../controllers/partidaController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {

      // Lista de partidas a crear
      const partidas = [
        {
          jugador1: '60b9f1f2f9d1c5b9b4f9b8c1',
          jugador2: '60b9f1f2f9d1c5b9b4f9b8c2',
          bioma: 'Norte'
        },
        {
          jugador1: '60b9f1f2f9d1c5b9b4f9b8c3',
          jugador2: '60b9f1f2f9d1c5b9b4f9b8c4',
          bioma: 'Mediterraneo'
        }

      ];
      // Itera sobre la lista de partidas y crea cada una
      for (const partida of partidas) {
        const req = { body: partida };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await iniciarPartida(req, res); // Espera a que se complete la creación del partida
      }
    } catch (error) {
      console.error('Error en el test de crear partida:', error);
    } finally {
      // Cierra la conexión a la base de datos al finalizar
      mongoose.disconnect();
    }
  })
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));





