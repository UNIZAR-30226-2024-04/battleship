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


// Funcion para actualizar las estadisticas de cada jugador al finalizar la partida
exports.actualizarEstadisticasFinales = async (req, res) => {
  try {
    const { idPartida } = req.body;
    const partida = await Partida.findById(idPartida);
    if (partida) {
      const jugador1 = partida.jugador1;
      const jugador2 = partida.jugador2;
      const ganador = partida.ganador;

      // Actualizar estadisticas de partidas jugadas de ambos jugadores
      jugador1.partidasJugadas++;
      jugador2.partidasJugadas++;
      
      // Actualizar estadisticas de partidas ganadas del ganador
      if (jugador1.nombreId === ganador.nombreId) {
        jugador1.partidasGanadas++;
      } else {
        jugador2.partidasGanadas++;
      }

      // Actualizar estadisticas de barcos hundidos del jugador 1 y barcos perdidos del jugador 2
      // Recorro partida.tableroBarcos2 para contar los barcos hundidos
      barcosHundidos1 = 0;
      for (let i = 0; i < partida.tableroBarcos2.length; i++) {
        if (partida.tableroBarcos2[i].barcoHundido) {
          barcosHundidos1++;
        }
      }
      jugador1.barcosEnemigosHundidos += barcosHundidos1;
      jugador1.barcosAliadosPerdidos += barcosHundidos1;

      // Actualizar estadisticas de barcos hundidos del jugador 2 y barcos perdidos del jugador 1
      // Recorro partida.tableroBarcos1 para contar los barcos hundidos
      barcosHundidos2 = 0;
      for (let i = 0; i < partida.tableroBarcos1.length; i++) {
        if (partida.tableroBarcos1[i].barcoHundido) {
          barcosHundidos2++;
        }
      }
      jugador2.barcosEnemigosHundidos += barcosHundidos2;
      jugador2.barcosAliadosPerdidos += barcosHundidos2;

      // Actualizar estadisticas de disparos acertados y fallados del jugador 1
      jugador1.disparosAcertados += partida.disparosRealizados1.filter(disparo => disparo.resultado === 'Tocado' || disparo.resultado === 'Hundido').length;
      jugador1.disparosFallados += partida.disparosRealizados1.filter(disparo => disparo.resultado === 'Agua').length;

      // Actualizar estadisticas de disparos acertados y fallados del jugador 2
      jugador2.disparosAcertados += partida.disparosRealizados2.filter(disparo => disparo.resultado === 'Tocado' || disparo.resultado === 'Hundido').length;
      jugador2.disparosFallados += partida.disparosRealizados2.filter(disparo => disparo.resultado === 'Agua').length;

      // Guardar los cambios en la base de datos
      const jugador1Guardado = await jugador1.save();
      const jugador2Guardado = await jugador2.save();
      res.json({ jugador1: jugador1Guardado, jugador2: jugador2Guardado }); // Devuelvo los jugadores actualizados
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};



