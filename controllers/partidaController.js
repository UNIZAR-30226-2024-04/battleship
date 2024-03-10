const Partida = require('../models/partidaModel');

// Iniciar una partida
exports.iniciarPartida = async (req, res) => {
  const { jugador1, jugador2 } = req.body;
  try {
    const partida = new Partida({ jugador1, jugador2 });
    const partidaGuardada = await partida.save();
    res.json(partidaGuardada);
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Mostrar tablero de barcos de un jugador
exports.mostrarTableroBarcos = async (req, res) => {
  try {
    const { idPartida, idJugador } = req.params;
    const partida = await Partida.findById(idPartida);
    if (partida) {
      const tablero = idJugador === '1' ? partida.tableroBarcos1 : partida.tableroBarcos2;
      res.json(tablero);
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Realizar un disparo
exports.realizarDisparo = async (req, res) => {
  try {
    const { idPartida, idJugador, x, y } = req.body;
    const partida = await Partida.findById(idPartida);
    if (partida) {
      const tablero = idJugador === '1' ? partida.tableroBarcos2 : partida.tableroBarcos1;
      const disparos = idJugador === '1' ? partida.disparosRealizados1 : partida.disparosRealizados2;
      const resultado = realizarDisparo(tablero, disparos, x, y);
      res.json(resultado);
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Actualizar estado de la partida tras un disparo o habilidad del adversario
exports.actualizarEstadoPartida = async (req, res) => {
  try {
    const { idPartida, idJugador, tablero, disparos } = req.body;
    const partida = await Partida.findById(idPartida);
    if (partida) {
      if (idJugador === '1') {
        partida.tableroBarcos1 = tablero;
        partida.disparosRealizados1 = disparos;
      } else {
        partida.tableroBarcos2 = tablero;
        partida.disparosRealizados2 = disparos;
      }
      const partidaGuardada = await partida.save();
      res.json(partidaGuardada);
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

