const mongoose = require('mongoose');
const { iniciarPartida, realizarDisparo } = require('../../controllers/partidaController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      const codigo = 587819398598;
      // Lista de disparos realizados a crear
      const disparos = [
        // {codigo: codigo, nombreId: 1, i: 1, j: 1}, // Tocado
        // {codigo: codigo, nombreId: 1, i: 1, j: 2}, // No es el turno del jugador
        // {codigo: codigo, nombreId: 2, i: 1, j: 1}, 
        // {codigo: codigo, nombreId: 1, i: 1, j: 2}, // Hundido
        {codigo: codigo, nombreId: 'usuario1', i: 1, j: 3}, // Agua
        // {codigo: codigo, nombreId: 1, i: 1, j: 1}, // Repetido
        // {codigo: codigo, nombreId: 1, i: 1, j: 3, extra: 1}, // Sobran campos
        // {nombreId: 1, i: 1, j: 3}, // Faltan campos
        // {codigo: codigo, nombreId: 3, i: 1, j: 3}, // nombreId inválido
        // {codigo: codigo, nombreId: 1, i: -1, j: 11}, // Disparo inválido
        // {codigo: 1, nombreId: 1, i: 1, j: 3}, // Partida no existente
      ];

      // Itera sobre la lista de disparos y los genera
      for (const disparo of disparos) {
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





