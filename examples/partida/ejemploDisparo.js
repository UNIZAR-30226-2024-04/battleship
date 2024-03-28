const mongoose = require('mongoose');
const { iniciarPartida } = require('../../controllers/partidaController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      const partidas = [
        {
          jugador1: '60b9f1f2f9d1c5b9b4f9b8c1',
          jugador2: '60b9f1f2f9d1c5b9b4f9b8c2',
          bioma: 'Cantabrico'
        },
      ];

      // Itera sobre la lista de partidas y crea cada una
      for (const partida of partidas) {
        const req = { body: partida };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await iniciarPartida(req, res); // Espera a que se complete la creación del partida
      }
      
      // Lista de disparos realizados a crear
      const disparosJ1 = [
        {
          idPartida: 1,
          jugador: 1,
          coordenada: { x: 1, y: 1 }
        },
        {
          idPartida: 1,
          jugador: 1,
          coordenada: { x: 3, y: 3 }
        },
        {
          idPartida: 1,
          jugador: 1,
          coordenada: { x: 5, y: 5 }
        }
      ];
      const disparosJ2 = [
        {
          idPartida: 1,
          jugador: 2,
          coordenada: { x: 2, y: 2 }
        },
        {
          idPartida: 1,
          jugador: 2,
          coordenada: { x: 4, y: 4 }
        },
        {
          idPartida: 1,
          jugador: 2,
          coordenada: { x: 6, y: 6 }
        }
      ];

      // Itera sobre la lista de disparos y los genera
      for (const disparo of disparosJ1) {
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





