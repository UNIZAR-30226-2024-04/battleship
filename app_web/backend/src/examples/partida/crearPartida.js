const mongoose = require('mongoose');
const { crearPartida } = require('../../controllers/partidaController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB')
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      // Lista de partidas a crear
      const partidas = [
        {nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte'}, 
        {nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Norte', extra: 1},  // Sobran campos
        {nombreId1: 'usuario1', bioma: 'Norte'}, // Falta un jugador
        {nombreId1: 'usuario1', nombreId2: 'usuario2', bioma: 'Murcia'},  // Bioma no disponible
        {nombreId1: 'usuario1', nombreId2: 'usuario5', bioma: 'Norte'} // No existe un jugador
      ];
      // Itera sobre la lista de partidas y crea cada una
      for (const partida of partidas) {
        const req = { body: partida };
        const res = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
        await crearPartida(req, res); // Espera a que se complete la creación del partida
      }
    } catch (error) {
      console.error('Error en el test de crear partida:', error);
    } finally {
      // Cierra la conexión a la base de datos al finalizar
      mongoose.disconnect();
    }
  })
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));




