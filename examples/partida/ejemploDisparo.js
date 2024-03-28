const mongoose = require('mongoose');
const { iniciarPartida, realizarDisparo } = require('../../controllers/partidaController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      id = 0;
      const partida =
        {
          jugador1: '60b9f1f2f9d1c5b9b4f9b8c1',
          jugador2: '60b9f1f2f9d1c5b9b4f9b8c2',
          bioma: 'Cantabrico'
        };

      const req = { body: partida };
      const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
      await iniciarPartida(req, res); // Espera a que se complete la creación del partida
      id = res.idPartida;

      console.log('Partida creada con id:', id);
      // Lista de disparos realizados a crear
      const disparosJ1 = [
        {
          idPartida: id,
          jugador: 1,
          i: 1, j: 1
        },
        {
          idPartida: id,
          jugador: 1,
          coordenada: { i: 3, j: 3 }
        },
        {
          idPartida: id,
          jugador: 1,
          i: 5, j: 5
        }
      ];
      const disparosJ2 = [
        {
          idPartida: id,
          jugador: 2,
          i: 2, j: 2
        },
        {
          idPartida: id,
          jugador: 2,
          coordenada: { i: 4, j: 4 }
        },
        {
          idPartida: id,
          jugador: 2,
          i: 6, j: 6
        }
      ];

      // Itera sobre la lista de disparos y los genera
      for (const disparo of disparosJ1) {
        const req = { body: disparo };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await realizarDisparo(req, res); // Espera 
      }
      for (const disparo of disparosJ2) {
        const req = { body: disparo };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await realizarDisparo(req, res); // Espera
      }
    } catch (error) {
      console.error('Error en el test de disparos:', error);
    } finally {
      // Cierra la conexión a la base de datos al finalizar
      mongoose.disconnect();
    }
  })
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));





