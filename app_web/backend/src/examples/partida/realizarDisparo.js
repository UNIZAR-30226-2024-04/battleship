const mongoose = require('mongoose');
const { iniciarPartida, realizarDisparo } = require('../../controllers/partidaController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      const codigo = 1081861550660;
      // Lista de disparos realizados a crear
      const disparos = [
        {codigo: codigo, jugador: 1, i: 1, j: 1}, // Tocado
        {codigo: codigo, jugador: 1, i: 1, j: 2}, // No es el turno del jugador
        {codigo: codigo, jugador: 2, i: 1, j: 1}, 
        {codigo: codigo, jugador: 1, i: 1, j: 2}, // Hundido
        {codigo: codigo, jugador: 2, i: 1, j: 3}, // Agua
        {codigo: codigo, jugador: 1, i: 1, j: 1}, // Repetido
        {codigo: codigo, jugador: 1, i: 1, j: 3, extra: 1}, // Sobran campos
        {jugador: 1, i: 1, j: 3}, // Faltan campos
        {codigo: codigo, jugador: 3, i: 1, j: 3}, // Jugador inválido
        {codigo: codigo, jugador: 1, i: -1, j: 11}, // Disparo inválido
        {codigo: 1, jugador: 1, i: 1, j: 3}, // Partida no existente
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





