const mongoose = require('mongoose');
const { iniciarPartida, realizarDisparoTorpedoRecargado } = require('../../controllers/partidaController');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(async () => {
    console.log('Conectado a MongoDB...');
    try {
      const codigo = 694689614036;
      // Lista de disparos realizados a crear
      const disparos = [
        //{codigo: codigo, nombreId: 'usuario1', turnoRecarga: true}, // Agua
        {codigo: codigo, nombreId: 'usuario1', i: 4, j: 5 }, // Agua
      ];

      // Itera sobre la lista de disparos y los genera
      for (const disparo of disparos) {
        const req = { body: disparo };
        let res = { json: function(_json) {this._json = _json; return this;}, status: function(s) {
          this.statusCode = s; return this; }, send: () => {} };
        await realizarDisparoTorpedoRecargado(req, res); // Espera
        console.log('Disparo realizado:', res._json);
        if (res._json && res._json.turnosIA) {
          console.log('Turnos de la IA:', res._json.turnosIA);
        }
      }
    } catch (error) {
      console.error('Error en el test de disparos:', error);
    } finally {
      // Cierra la conexión a la base de datos al finalizar
      mongoose.disconnect();
    }
  })
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));





