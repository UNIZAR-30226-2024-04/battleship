const Partida = require('../models/partidaModel');
const Coordenada = require('../data/coordenada')
const tableroDim = Coordenada.i.max;  // Dimensiones del tablero


// ------------------------------------------ //
// ----------- FUNCIONES INTERNAS ----------- //
// ------------------------------------------ //

// Función para generar un id de partida único
function generarIdPartida() {
  const timestamp = new Date().getTime(); // Obtiene el timestamp actual
  const hash = require('crypto').createHash('sha1'); // Selecciona el algoritmo hash
  hash.update(timestamp.toString()); // Actualiza el hash con el timestamp convertido a cadena
  const idPartida = hash.digest('hex'); // Obtiene el hash en formato hexadecimal
  return parseInt(idPartida.substring(0, 10), 16); // Convierte los primeros 10 caracteres del hash en un número
}

// -------------------------------------------- //
// ----------- FUNCIONES EXPORTADAS ----------- //
// -------------------------------------------- //

// Iniciar una partida
exports.iniciarPartida = async (req, res) => {
  try {
    const { jugador1, jugador2, bioma, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera jugador1 y jugador2');
      console.error("Sobran parámetros, se espera jugador1 y jugador2");
      return;
    }
    const idPartida = generarIdPartida();
    const partida = new Partida({ idPartida, jugador1, jugador2, bioma, ...extraParam });
    const partidaGuardada = await partida.save();
    res.json(partidaGuardada);
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Mostrar tablero de barcos de un jugador 
exports.mostrarMiTableroBarcos = async (req, res) => {
  try {
    const { idPartida, jugador, ...extraParam } = req.params;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera idPartida e jugador');
      console.error("Sobran parámetros, se espera idPartida e jugador");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!idPartida || !jugador) {
      res.status(400).send('Falta el idPartida y/o jugador');
      console.error("Falta el idPartida y/o jugador");
      return;
    }
    if (jugador !== '1' || jugador !== '2') {
      res.status(400).send('El jugador debe ser 1 o 2');
      console.error("El jugador debe ser 1 o 2");
      return;
    }
    const partida = await Partida.findById(idPartida);
    if (partida) {
      const tablero = {
        tableroBarcos: jugador === '1' ? partida.tableroBarcos1 : partida.tableroBarcos2
      };
      res.json(tablero);
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Mostrar tablero de barcos del jugador enemigo
exports.mostrarTableroEnemigo = async (req, res) => {
  try {
    const { idPartida, jugador, ...extraParam } = req.params;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera idPartida e jugador');
      console.error("Sobran parámetros, se espera idPartida e jugador");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!idPartida || !jugador) {
      res.status(400).send('Falta el idPartida y/o jugador');
      console.error("Falta el idPartida y/o jugador");
      return;
    }
    if (jugador !== '1' || jugador !== '2') {
      res.status(400).send('El jugador debe ser 1 o 2');
      console.error("El jugador debe ser 1 o 2");
      return;
    }
    const partida = await Partida.findById(idPartida);
    if (partida) {
      const tablero = {
        tableroBarcos: jugador === '1' ? partida.tableroBarcos2 : partida.tableroBarcos1,
        disparosRealizados: jugador === '1' ? partida.disparosRealizados1 : partida.disparosRealizados2
    };
      res.json(tablero);
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Funcion para comprobar que un dato es un numero
function esNumero(numero) {
  return !isNaN(numero);
}

// Funcion que devuelve el barco (si existe) disparado en esa coordenada. En caso contrario devuelve null
function dispararCoordenada(tablero, i, j) {
  for (let barco of tablero) {
      for (let coordenada of barco) {
          if (coordenada.i === i && coordenada.j === j) {
              // Marcar la coordenada como disparada
              coordenada.estado = 'Tocado';
              return barco; // Se encontró un barco en estas coordenadas
          }
      }
  }
  return null; // No se encontró ningún barco en estas coordenadas
}

// Realizar un disparo
exports.realizarDisparo = async (req, res) => {
  try {
    const { idPartida, jugador, i, j, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera idPartida, jugador, i, j');
      console.error("Sobran parámetros, se espera idPartida, jugador, i, j");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!idPartida || !jugador || !i || !j) {
      res.status(400).send('Falta alguno de los siguientes parámetros: idPartida, jugador, i o j');
      console.error("Falta alguno de los siguientes parámetros: idPartida, jugador, i o j");
      return;
    }
    if (jugador !== '1' || jugador !== '2') {
      res.status(400).send('El jugador debe ser 1 o 2');
      console.error("El jugador debe ser 1 o 2");
      return;
    }
    if (!esNumero(i) || !esNumero(j)) {
      res.status(400).send('Las coordenadas i, j deben ser numéricas');
      console.error("Las coordenadas i, j deben ser numéricas");
      return;
    }
    // Comprobar si i, j son casillas válidas
    if (i < 1 || i > tableroDim || j < 1 || j > tableroDim) {
      res.status(400).send('Las coordenadas i, j deben estar entre 1 y 10');
      console.error("Las coordenadas i, j deben estar entre 1 y 10");
      return;
    }
    let partida = await Partida.findById(idPartida);
    if (partida) {
      // Comprobar si la casilla ya fue disparada
      let disparosRealizados = jugador === '1' ? partida.disparosRealizados1 : partida.disparosRealizados2;
      const disparoRepetido = disparosRealizados.find(disparo => disparo.i === i && disparo.j === j);
      if (disparoRepetido) {
        res.status(400).send('Casilla ya disparada');
        console.error("Casilla ya disparada");
        return;
      }
      // Realizar disparo
      let barcoTocado = jugador === '1' ? dispararCoordenada(partida.tableroBarcos2, i, j) :
        dispararCoordenada(partida.tableroBarcos1, i, j);
      // Actualizar disparosRealizados y tableroBarcos
      let disparo = { i, j, resultado: 'Agua' };
      if (barcoTocado) { 
        barcoTocado.every(coordenada => coordenada.estado === 'Tocado') && 
          barcoTocado.map(coordenada => coordenada.estado = 'Hundido');    
        disparo.resultado = 'Tocado'; // Los disparos solo son Agua o Tocado
      }
      disparosRealizados.push(disparo);
      // Actualizar la partida
      const partidaModificada = await Partida.findOneAndUpdate(
        { idPartida: idPartida }, // Filtrar
        partida, // Actualizar (partida contiene los cambios)
        { new: true } // Para devolver el documento actualizado
      );
      if (partidaModificada) {
        res.json(partidaModificada );
        console.log("Partida modificada con éxito", partidaModificada);
      } else {
        res.status(404).send('No se ha encontrado la partida a actualizar');
        console.error("No se ha encontrado la partida a actualizar");
      }
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
    const { idPartida, jugador, tablero, disparos } = req.body;
    const partida = await Partida.findById(idPartida);
    if (partida) {
      if (jugador === '1') {
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



