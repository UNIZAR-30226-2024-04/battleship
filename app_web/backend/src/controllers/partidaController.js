const Partida = require('../models/partidaModel');
const Perfil = require('../models/perfilModel');
const Coordenada = require('../data/coordenada');
const Tablero = require('../data/tablero');
const {barcosDisponibles} = require('../data/barco');
const biomasDisponibles = require('../data/biomas');
const {actualizarEstadisticas} = require('./perfilController');
const tableroDim = Coordenada.i.max;  // Dimensiones del tablero
/**
 * @module controllers/partida
 * @description Controlador para las partidas
 * @see module:partidaModel
 * @requires module:partidaModel
 * @requires module:perfilModel
 */

// ------------------------------------------ //
// ----------- FUNCIONES INTERNAS ----------- //
// ------------------------------------------ //

// Función para generar un id de partida único
function generarCodigo() {
  const timestamp = new Date().getTime(); // Obtiene el timestamp actual
  const hash = require('crypto').createHash('sha1'); // Selecciona el algoritmo hash
  hash.update(timestamp.toString()); // Actualiza el hash con el timestamp convertido a cadena
  const codigo = hash.digest('hex'); // Obtiene el hash en formato hexadecimal
  return parseInt(codigo.substring(0, 10), 16); // Convierte los primeros 10 caracteres del hash en un número
}


// Funcion que devuelve el barco (si existe) disparado en la coordenada (i, j).
// Si no hay barco en la coordenada, devuelve null.
function dispararCoordenada(tablero, i, j) {
  for (let barco of tablero) {
    for (let coordenada of barco.coordenadas) {
      if (coordenada.i === i && coordenada.j === j) {
        coordenada.estado = 'Tocado';
        return barco;
      }
    }
  }
  return null;
}

// Función para verificar si el barco que irá en la posición barcoId colisiona con otros barcos
function barcoColisionaPrevios(tablero, barcoCoordenadas, barcoId) {
  if (tablero.length === 0) return false;
  for (let i = 0; i < barcoId; i++) { // Recorrer los otros barcos
    for (const coordenada of tablero[i].coordenadas) {
      for (const nuevaCoordenada of barcoCoordenadas) {
        if (coordenada.i === nuevaCoordenada.i && coordenada.j === nuevaCoordenada.j) {
          return true; // Hay colisión
        }
      }
    }
  }
  return false; // No hay colisión
}

// Function generarTableroAleatorio
// Devuelve un tablero de barcos aleatorio
function generarTableroAleatorio() {
  let tablero = [];
  for (let barco of barcosDisponibles) {
    let barcoId = barcosDisponibles.indexOf(barco);
    let barcoLongitud = barcoId === 0 ? 2 : barcoId === 1 ? 3 :
      barcoId === 2 ? 3 : barcoId === 3 ? 4 : 5;
    while (true) {
      // Definir orientación y coordenadas iniciales
      let orientacion = Math.random() < 0.5;
      if (orientacion) { // Horizontal
        i = Math.floor(Math.random() * tableroDim) + 1;
        j = Math.floor(Math.random() * (tableroDim - barcoLongitud + 1)) + 1;
      } else { // Vertical
        i = Math.floor(Math.random() * (tableroDim - barcoLongitud + 1)) + 1;
        j = Math.floor(Math.random() * tableroDim) + 1;
      }
      // Completa las coordenadas del barco
      let coordenadas = [];
      for (let k = 0; k < barcoLongitud; k++) {
        if (orientacion) { // Horizontal
          coordenadas.push( { i, j: j + k, estado: 'Agua' });
        } else { // Vertical
          coordenadas.push( { i: i + k, j, estado: 'Agua' });
        }
      }
      // Comprueba si el barco colisiona con otros barcos
      if (!barcoColisionaPrevios(tablero, coordenadas, barcoId)) {
        tablero.push({ coordenadas: coordenadas, tipo: barco });
        break;
      }
    }
  }
  return tablero;
}

function generarDisparoAleatorio(disparosRealizados) {
  let i = Math.floor(Math.random() * tableroDim) + 1;
  let j = Math.floor(Math.random() * tableroDim) + 1;
  let disparoRepetido = disparosRealizados.find(disparo => disparo.i === i && disparo.j === j);
  while (disparoRepetido) {
    i = Math.floor(Math.random() * tableroDim) + 1;
    j = Math.floor(Math.random() * tableroDim) + 1;
    disparoRepetido = disparosRealizados.find(disparo => disparo.i === i && disparo.j === j);
  }
  return { i, j };
}

// -------------------------------------------- //
// -------------- PARTIDA BASICA -------------- //
// -------------------------------------------- //

/**
 * @function crearPartida
 * @description Crea una partida con dos jugadores (_id, nombreId) y un bioma, la guarda en la base de datos y devuelve la partida creada
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id1] - El id del jugador 1, si no se proporciona se espera el nombreId1
 * @param {String} [req.body._id2] - El id del jugador 2, si no se proporciona se espera el nombreId2
 * @param {String} [req.body.nombreId1] - El nombreId del jugador 1
 * @param {String} [req.body.nombreId2] - El nombreId del jugador 2
 * @param {BiomasDisponibles} req.body.bioma - El bioma de la partida
 * @param {Boolean} [req.body.amistosa] - Indica si la partida es amistosa, por defecto es false
 * @param {Object} res - El objeto despuesta HTTP con el codigo de la partida creada TODO: CAMBIAR ESTO EN BACKEND
 * @param {Number} res.codigo - El código de la partida
 * @example 
 * peticion = { body: { nombreId1: 'jugador1', nombreId2: 'jugador2', bioma: 'Mediterraneo' } }
 * respuesta = { json: () => {} }
 * await crearPartida(peticion, respuesta)
 */
exports.crearPartida = async (req, res) => {
  try {
    const { _id1, _id2, nombreId1, nombreId2, bioma = 'Mediterraneo', amistosa = true, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId1 (o _id1), nombreId2 (o _id2) y bioma');
      console.error("Sobran parámetros, se espera nombreId1 (o _id1), nombreId2 (o _id2) y bioma");
      return;
    }
    // Verificar si falta el nombreId1 (o _id1) 
    if (!nombreId1 && !_id1) {
      res.status(400).send('Falta el nombreId1 (o _id1) del jugador 1');
      console.error("Falta el nombreId1 (o _id1) del jugador 1");
      return;
    }
    // Verificar si el bioma elegido está en la lista de biomas disponibles
    if (!biomasDisponibles.includes(bioma)) {
      const biomasMensaje = biomasDisponibles.join(', '); // Convierte la lista de biomas en un string separado por comas
      res.status(400).send('El bioma debe ser alguno de:', biomasMensaje);
      console.error("El bioma debe ser alguno de:", biomasMensaje);
      return;
    }
    // Verificar que existen los perfiles
    const filtro1 = _id1 ? { _id: _id1 } : { nombreId: nombreId1 };
    let jugador1 = await Perfil.findOne(filtro1);
    if (!jugador1) {
      res.status(404).send('No se ha encontrado el jugador 1');
      console.error("No se ha encontrado el jugador 1");
      return;
    }
    let jugador2 = undefined;
    let filtro2 = {};
    if (nombreId2 || _id2) {
      filtro2 = _id2 ? { _id: _id2 } : { nombreId: nombreId2 };
      jugador2 = await Perfil.findOne(filtro2);
      if (!jugador2) {
        res.status(404).send('No se ha encontrado el jugador 2');
        console.error("No se ha encontrado el jugador 2");
        return;
      }
      if (jugador1.nombreId === jugador2.nombreId) {
        res.status(400).send('Los jugadores deben ser diferentes');
        console.error("Los jugadores deben ser diferentes");
        return;
      }
      if (jugador2.codigoPartidaActual !== -1) {
        res.status(400).send('El jugador 2 ya está en una partida');
        console.error("El jugador 2 ya está en una partida");
        return;
      }
    }
    if (jugador1.codigoPartidaActual !== -1) {
      res.status(400).send('El jugador 1 ya está en una partida');
      console.error("El jugador 1 ya está en una partida");
      return;
    }
    // Obtenemos los tableros de barcos de los jugadores y generamos un código único
    const tableroBarcos1 = jugador1.tableroInicial;
    let tableroBarcos2;
    if (jugador2 === undefined) {
      tableroBarcos2 = generarTableroAleatorio();
    } else {
      tableroBarcos2 = jugador2.tableroInicial;
    }
    const codigo = generarCodigo();
    // Actualizamos los códigos de partida actuales de los jugadores
    jugador1.codigoPartidaActual = codigo;
    await Perfil.findOneAndUpdate(
      filtro1, // Filtrar
      jugador1, // Actualizar (jugador1 contiene los cambios)
      { new: true } // Para devolver el documento actualizado
    );
    if (jugador2 !== undefined) {
      jugador2.codigoPartidaActual = codigo;
      await Perfil.findOneAndUpdate(
        filtro2, // Filtrar
        jugador2, // Actualizar (jugador2 contiene los cambios)
        { new: true } // Para devolver el documento actualizado
      );
    } else { 
      console.log('Jugador 2 es IA');
    }
    const nuevaPartida = new Partida({ 
      codigo, 
      nombreId1, 
      nombreId2,
      tableroBarcos1,
      tableroBarcos2,
      bioma,
      amistosa
    });

    const partidaGuardada = await nuevaPartida.save(); // ESTA LINEA DA FALLO COJONES
    res.json({ codigo: partidaGuardada.codigo });
    console.log('Partida creada con éxito');
  } catch (error) {
    res.status(500).send('Hubo un error creando la partida'+ error.message);
    console.error('Hubo un error creando la partida', error);
  }
};

/**
 * @function mostrarMiTablero
 * @description Devuelve el tablero de barcos y los disparos realizados del jugador en la partida
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id] - El id de la partida, si no se proporciona se espera el codigo
 * @param {Number} [req.body.codigo] - El codigo de la partida
 * @param {String} req.body.nombreId - El nombreId del jugador
 * @param {Object} res - El tablero de barcos y los disparos realizados del jugador
 * @param {Tablero} res.tableroBarcos - El tablero de barcos del jugador y su estado actual
 * @param {Coordenada[]} res.disparosEnemigos - Los disparos realizados por el jugador enemigo
 * @example
 * peticion = { body: { codigo: '1234567890', jugador: 1 } }
 * respuesta = { json: () => {} }
 * await mostrarMiTablero(peticion, respuesta)
 */
exports.mostrarMiTablero = async (req, res) => {
  try {
    const { _id, codigo, nombreId, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo (o _id) y jugador');
      console.error("Sobran parámetros, se espera codigo (o _id) y jugador");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!codigo && !_id || !nombreId) {
      res.status(400).send('Falta el codigo (o _id) y/o jugador');
      console.error("Falta el codigo (o _id) y/o jugador");
      return;
    }
    // Verificar que existe la partida
    const filtro = _id ? { _id: _id } : { codigo: codigo };
    const partidaActual = await Partida.findOne(filtro);
    if (partidaActual) {
      const jugador1 = await Perfil.findOne({ nombreId: partidaActual.nombreId1 });
      let jugador2 = { nombreId: "IA" };
      if (partidaActual.nombreId2) {
        jugador2 = await Perfil.findOne({ nombreId: partidaActual.nombreId2 });
      }
      // Comprobamos que el jugador está en la partida
      var jugador = 0;
      if (jugador1.nombreId === nombreId) {
        jugador = 1;
      } else if (jugador2.nombreId === nombreId) {
        jugador = 2;
      } else {
        res.status(404).send('El jugador no está en la partida');
        console.error('El jugador no está en la partida');
        return;
      }
      const tableroDisparos = {
        tableroBarcos: jugador === 1 ? partidaActual.tableroBarcos1 : partidaActual.tableroBarcos2,
        disparosEnemigos: jugador === 1 ? partidaActual.disparosRealizados2 : partidaActual.disparosRealizados1
      };
      console.log('Mi tablero obtenido con éxito');
      res.json(tableroDisparos);
      console.log(tableroDisparos);
      return tableroDisparos;
    } else {
      res.status(404).send('Partida no encontrada');
      console.error('Partida no encontrada');
      return;
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error('Hubo un error');
    return;
  }
};

/**
 * @function mostrarTableroEnemigo
 * @description Devuelve el tablero de barcos del jugador enemigo en la partida
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id] - El id de la partida, si no se proporciona se espera el codigo
 * @param {String} [req.body.codigo] - El codigo de la partida
 * @param {String} req.body.nombreId - El nombreId del jugador
 * @param {Object} res - El objeto de respuesta HTTP
 * @param {Coordenada[]} res.misDisparos - Los disparos realizados por mi
 * @param {Coordenada[]} res.barcosHundidos - Los barcos del enemigo hundidos por mi
 * @example
 * peticion = { body: { codigo: '1234567890', jugador: 1 } }
 * respuesta = { json: () => {} }
 * await mostrarTableroEnemigo(peticion, respuesta)
 */
exports.mostrarTableroEnemigo = async (req, res) => {
  try {
    const { _id, codigo, nombreId, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo (o _id) y jugador');
      console.error("Sobran parámetros, se espera codigo (o _id) y jugador");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!codigo && !_id || !nombreId) {
      res.status(400).send('Falta el codigo (o _id) y/o jugador');
      console.error("Falta el codigo (o _id) y/o jugador");
      return;
    }
    // Verificar que existe la partida
    const filtro = _id ? { _id: _id } : { codigo: codigo };
    const partidaActual = await Partida.findOne(filtro);
    if (partidaActual) {
      const jugador1 = await Perfil.findOne({ nombreId: partidaActual.nombreId1 });
      let jugador2 = { nombreId: "IA" };
      if (partidaActual.nombreId2) {
        jugador2 = await Perfil.findOne({ nombreId: partidaActual.nombreId2 });
      }
      // Comprobamos que el jugador está en la partida
      var jugador = 0;
      if (jugador1.nombreId === nombreId) {
        jugador = 1;
      } else if (jugador2.nombreId === nombreId) {
        jugador = 2;
      } else {
        res.status(404).send('El jugador no está en la partida');
        console.error('El jugador no está en la partida');
        return;
      }

      // Obtengo los barcos hundidos en el tablero enemigo
      let listaBarcosHundidos = [];
      for (let barco of jugador === 1 ? partidaActual.tableroBarcos2 : partidaActual.tableroBarcos1) {
        if (barco.coordenadas.some(coordenada => coordenada.estado === 'Hundido')) {
          barcosHundidos.push(barco);
        }
      }

      const disparosBarcos = {
        misDisparos: jugador === 1 ? partidaActual.disparosRealizados1 : partidaActual.disparosRealizados2,
        barcosHundidos: listaBarcosHundidos
      };
      console.log('Tablero enemigo obtenido con éxito');
      res.json(disparosBarcos);
      console.log(disparosBarcos);
      return disparosBarcos;
    } else {
      res.status(404).send('Partida no encontrada');
      console.error('Partida no encontrada');
      return;
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error('Hubo un error');
    return;
  }
};

/**
 * @function mostrarTableros
 * @description Devuelve los tableros y disparos realizados de ambos jugadores en la partida
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id] - El id de la partida, si no se proporciona se espera el codigo
 * @param {String} [req.body.codigo] - El codigo de la partida
 * @param {String} req.body.nombreId - El nombreId del jugador
 * @param {Object} res - El objeto de respuesta HTTP
 * @param {Tablero} res.tableroBarcos - El tablero de barcos del jugador y su estado actual
 * @param {Coordenada[]} res.disparosEnemigos - Los disparos realizados por el jugador enemigo
 * @param {Coordenada[]} res.misDisparos - Los disparos realizados por mi
 * @param {Coordenada[]} res.barcosHundidos - Los barcos del enemigo hundidos por mi
 * @example
 * peticion = { body: { codigo: '1234567890' } }
 * respuesta = { json: () => {} }
 * await mostrarTableros(peticion, respuesta)
 */
exports.mostrarTableros = async (req, res) => {
  try {
    const { _id, codigo, nombreId, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo (o _id)');
      console.error("Sobran parámetros, se espera codigo (o _id)");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if ((!codigo && !_id) || !nombreId) {
      res.status(400).send('Falta el codigo (o _id) y/o jugador');
      console.error("Falta el codigo (o _id) y/o jugador");
      return;
    }
    // Verificar que existe la partida
    const filtro = _id ? { _id: _id } : { codigo: codigo };
    const partidaActual = await Partida.findOne(filtro);
    if (partidaActual) {      
      const jugador1 = await Perfil.findOne({ nombreId: partidaActual.nombreId1 });
      let jugador2 = { nombreId: "IA" };
      if (partidaActual.nombreId2) {
        jugador2 = await Perfil.findOne({ nombreId: partidaActual.nombreId2 });
      }
      // Comprobamos que el jugador está en la partida
      var jugador = 0;
      if (jugador1.nombreId === nombreId) {
        jugador = 1;
      } else if (jugador2.nombreId === nombreId) {
        jugador = 2;
      } else {
        res.status(404).send('El jugador no está en la partida');
        console.error('El jugador no está en la partida');
        return;
      }

      // Obtengo los barcos hundidos en el tablero enemigo
      let listaBarcosHundidos = [];
      for (let barco of jugador === 1 ? partidaActual.tableroBarcos2 : partidaActual.tableroBarcos1) {
        if (barco.coordenadas.some(coordenada => coordenada.estado === 'Hundido')) {
          barcosHundidos.push(barco);
        }
      }

      const tableros = {
        tableroBarcos: jugador === 1 ? partidaActual.tableroBarcos1 : partidaActual.tableroBarcos2,
        disparosEnemigos: jugador === 1 ? partidaActual.disparosRealizados2 : partidaActual.disparosRealizados1,
        misDisparos: jugador === 1 ? partidaActual.disparosRealizados1 : partidaActual.disparosRealizados2,
        barcosHundidos: listaBarcosHundidos
      };
      console.log('Tableros obtenidos con éxito');
      res.json(tableros);
      console.log(tableros);
      return tableros;
    } else {
      res.status(404).send('Partida no encontrada');
      console.error('Partida no encontrada');
      return;
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error('Hubo un error');
    return;
  }
};

/**
 * @function realizarDisparo
 * @description Realiza un disparo en la coordenada (i, j) del enemigo y actualiza el estado de la partida
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id] - El id de la partida, si no se proporciona se espera el codigo
 * @param {String} [req.body.codigo] - El codigo de la partida
 * @param {String} req.body.nombreId - El nombreId del jugador
 * @param {Number} req.body.i - La coordenada i del disparo
 * @param {Number} req.body.j - La coordenada j del disparo
 * @param {Object} res - El objeto de respuesta HTTP
 * @param {Object} res.disparoRealizado - El disparo realizado con sus coordenadas y estado
 * @param {Object} [res.barcoCoordenadas] - Las coordenadas del barco disparado, si se ha hundido
 * @param {String} res.eventoOcurrido - El evento ocurrido en la partida
 * @param {Boolean} res.finPartida - Indica si la partida ha terminado
 * @param {String} res.clima - El clima de la partida
 * @param {Object} [res.turnoIA] - El turno de la IA, si la partida es contra la IA
 * @param {Object} res.turnoIA.disparoRealizado - El disparo realizado por la IA
 * @param {Object} [res.turnoIA.barcoCoordenadas] - Las coordenadas del barco disparado por la IA, si se ha hundido
 * @param {String} res.turnoIA.eventoOcurrido - El evento ocurrido en la partida
 * @param {Boolean} res.turnoIA.finPartida - Indica si la partida ha terminado
 * @param {String} res.turnoIA.clima - El clima de la partida
 * @returns {Partida} La partida modificada
 * @example
 * peticion = { body: { codigo: '1234567890', nombreId: 'jugador1', i: 1, j: 1 } }
 * respuesta = { json: () => {} }
 * await realizarDisparo(peticion, respuesta)
 */
exports.realizarDisparo = async (req, res) => {
  try {
    const { _id, codigo, nombreId, i, j, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra que no se espera
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo (o _id), jugador, i, j');
      console.error("Sobran parámetros, se espera codigo (o _id), jugador, i, j");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if ((!codigo && !_id) || !nombreId || !i || !j) {
      res.status(400).send('Falta alguno de los siguientes parámetros: codigo (o _id), nombreId, i, j');
      return;
    }
    // Comprobar si i, j es casilla válida
    if (i < 1 || i > tableroDim || j < 1 || j > tableroDim) {
      res.status(400).send('Las coordenadas i, j deben estar entre 1 y 10');
      console.error("Las coordenadas i, j deben estar entre 1 y 10");
      return;
    }
    // Verificar que existe la partida
    const filtro = _id ? { _id: _id } : { codigo: codigo };
    const partidaActual = await Partida.findOne(filtro);
    if (partidaActual) {
      let jugador1 = await Perfil.findOne({ nombreId: partidaActual.nombreId1 });
      let jugador2 = { nombreId: "IA" };
      if (partidaActual.nombreId2) {
        jugador2 = await Perfil.findOne({ nombreId: partidaActual.nombreId2 });
      }
      // Comprobamos que el jugador está en la partida
      var jugador = 0;
      if (jugador1.nombreId === nombreId) {
        jugador = 1;
      } else if (jugador2.nombreId === nombreId) {
        jugador = 2;
      } else {
        res.status(404).send('El jugador no está en la partida');
        console.error('El jugador no está en la partida');
        return;
      }
      // Comprobar si es el turno del jugador
      if (jugador === 1 && partidaActual.contadorTurno % 2 === 0 || 
            jugador === 2 && partidaActual.contadorTurno % 2 === 1) {
        res.status(400).send('No es el turno del jugador');
        console.error('No es el turno del jugador');
        return;
      }

      let estadisticasJugadores = [
        { victoria: undefined, nuevosBarcosHundidos: 0, nuevosBarcosPerdidos: 0,
          nuevosDisparosAcertados: 0, nuevosDisparosFallados: 0, nuevosTrofeos: 0,
          nombreId: jugador1.nombreId },
        { victoria: undefined, nuevosBarcosHundidos: 0, nuevosBarcosPerdidos: 0,
          nuevosDisparosAcertados: 0, nuevosDisparosFallados: 0, nuevosTrofeos: 0,
          nombreId: jugador2.nombreId }
      ]

      const partidaContraIA = !partidaActual.nombreId2;
      // Realizar disparo
      let barcoDisparado = jugador === 1 ? dispararCoordenada(partidaActual.tableroBarcos2, i, j) :
      dispararCoordenada(partidaActual.tableroBarcos1, i, j);
      let disparo = { i, j, estado: 'Agua' };
      if (barcoDisparado) {
        estadisticasJugadores[jugador - 1].nuevosDisparosAcertados++;
        disparo.estado = 'Tocado'; // Los disparos solo son Agua o Tocado
        if (barcoDisparado.coordenadas.every(coordenada => coordenada.estado === 'Tocado')) {
          estadisticasJugadores[jugador - 1].nuevosBarcosHundidos++;
          estadisticasJugadores[jugador === 1 ? 1 : 0].nuevosBarcosPerdidos++;
          barcoDisparado.coordenadas.map(coordenada => coordenada.estado = 'Hundido');
          disparo.estado = 'Hundido';
        }
      } else {  // Sólo cambia el turno si se falla el disparo
        estadisticasJugadores[jugador - 1].nuevosDisparosFallados++;
        partidaActual.contadorTurno++;
      }
      let disparosRealizados = jugador === 1 ? partidaActual.disparosRealizados1 :
                                                partidaActual.disparosRealizados2;
      disparosRealizados.push(disparo);
      jugador === 1 ? partidaActual.disparosRealizados1 = disparosRealizados : 
        partidaActual.disparosRealizados2 = disparosRealizados;

      
      // Comprobar si la partida ha terminado
      let finPartida = false;
      if (jugador === 1) {
        finPartida = partidaActual.tableroBarcos2.every(barco =>
          barco.coordenadas.every(coordenada => coordenada.estado === 'Hundido'));
      } else {
        finPartida = partidaActual.tableroBarcos1.every(barco =>
          barco.coordenadas.every(coordenada => coordenada.estado === 'Hundido'));
      }

      if (finPartida ) {
        if (jugador === 1) {
          estadisticasJugadores[0].victoria = 1;
          estadisticasJugadores[1].victoria = 0;
          partidaActual.ganador = jugador1.nombreId;
        } else {
          estadisticasJugadores[1].victoria = 1;
          estadisticasJugadores[0].victoria = 0;
          partidaActual.ganador = jugador2.nombreId;
        }
        jugador1.codigoPartidaActual = -1;
        jugador2.codigoPartidaActual = -1;
        await Perfil.findOneAndUpdate(
          { nombreId: jugador1.nombreId }, // Filtrar
          jugador1, // Actualizar (jugador1 contiene los cambios)
          { new: true } // Para devolver el documento actualizado
        );
        await Perfil.findOneAndUpdate(
          { nombreId: jugador2.nombreId }, // Filtrar
          jugador2, // Actualizar (jugador2 contiene los cambios)
          { new: true } // Para devolver el documento actualizado
        );
      }


      let turnosIA = [];
      if (partidaContraIA && disparo.estado === 'Agua' && !finPartida) {
        console.log("Turno de la IA");
        let juegaIA = true;
        while (juegaIA) {
          let posibleDisparoIA = generarDisparoAleatorio(partidaActual.disparosRealizados2);
          let barcoDisparadoIA = dispararCoordenada(partidaActual.tableroBarcos1, 
            posibleDisparoIA.i, posibleDisparoIA.j);
          let disparoIA = { i: posibleDisparoIA.i, j: posibleDisparoIA.j, estado: 'Agua' };
          if (barcoDisparadoIA) {
            disparoIA.estado = 'Tocado';
            if (barcoDisparado.coordenadas.every(coordenada => coordenada.estado === 'Tocado')) {
              estadisticasJugadores[0].nuevosBarcosPerdidos++;
              barcoDisparadoIA.coordenadas.map(coordenada => coordenada.estado = 'Hundido');
              disparoIA.estado = 'Hundido';
            }
          }
          partidaActual.disparosRealizados2.push(disparoIA);

          // Comprobar si la partida ha terminado
          let finPartidaIA = partidaActual.tableroBarcos1.every(barco =>
            barco.coordenadas.every(coordenada => coordenada.estado === 'Hundido'));
          if (finPartidaIA) {
            partidaActual.ganador = 'IA';
          }

          let turnoIA = {
            disparoRealizado: disparoIA,
            barcoCoordenadas: (disparoIA.estado === 'Hundido') ? barcoDisparadoIA : undefined,
            eventoOcurrido: undefined, // Evento ocurrido en la partida
            finPartida: finPartidaIA,
            clima: partidaActual.clima
          };
          turnosIA.push(turnoIA);
          console.log('turnosIA:',turnosIA.length);
          juegaIA = disparoIA.estado !== 'Agua' && !finPartidaIA;
        }
      }

      // Actualizar la partida
      const partidaModificada = await Partida.findOneAndUpdate(
        filtro, // Filtrar
        partidaActual, // Actualizar (partida contiene los cambios)
        { new: true } // Para devolver el documento actualizado
      );

      if (partidaModificada) {
        if (partidaContraIA && disparo.estado === 'Agua') {

        }
        const respuestaDisparo = {
          disparoRealizado: disparo,
          barcoCoordenadas: (disparo.estado === 'Hundido') ? barcoDisparado : undefined,
          eventoOcurrido: undefined, // Evento ocurrido en la partida
          finPartida: finPartida,
          clima: partidaActual.clima,
          turnosIA: turnosIA
        };

        // Actualizar estadisticas de los jugadores
        let tempRes1 = { json: () => {}, status: function(s) { 
          this.statusCode = s; return this;} };
        await actualizarEstadisticas({ body: estadisticasJugadores[0] }, tempRes1);
        if (tempRes1.statusCode !== undefined && tempRes1.statusCode !== 200) {
          res.status(500).send('Hubo un error al actualizar las estadísticas');
          console.error("Hubo un error al actualizar las estadísticas");
          return;
        }

        if (!partidaContraIA) {
          let tempRes2 = { json: () => {}, status: function(s) {
            this.statusCode = s; return this;} };
          await actualizarEstadisticas({ body: estadisticasJugadores[1] }, res);
          if (tempRes2.statusCode !== undefined && tempRes2.statusCode !== 200) {
            res.status(500).send('Hubo un error al actualizar las estadísticas');
            console.error("Hubo un error al actualizar las estadísticas");
            return;
          }
        }
        
        res.json(respuestaDisparo);
        console.log("Partida modificada con éxito");
      } else {
        res.status(404).send('No se ha encontrado la partida a actualizar');
        console.error("No se ha encontrado la partida a actualizar");
      }
    } else {
      res.status(404).send('Partida no encontrada');
      console.error("Partida no encontrada");
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Hubo un error");
  }
};


// Actualizar estado de la partida tras un disparo o habilidad del adversario
// Devuelve mi tablero y los disparos realizados
/**
 * @function actualizarEstadoPartida
 * @description Actualiza el estado de la partida tras un disparo o habilidad del adversario
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id] - El id de la partida, si no se proporciona se espera el codigo
 * @param {String} [req.body.codigo] - El codigo de la partida
 * @param {Number} req.body.jugador - El número del jugador (1 o 2)
 * @param {Object[]} req.body.tablero - El tablero de barcos del jugador
 * @param {Object[]} req.body.disparos - Los disparos realizados por el jugador
 * @param {Object} res - El objeto de respuesta HTTP
 * @returns {Partida} La partida modificada
 * @example
 * peticion = { body: { codigo: '1234567890', jugador: 1, tablero: [], disparos: [] } }
 * respuesta = { json: () => {} }
 * await actualizarEstadoPartida(peticion, respuesta)
 */
exports.actualizarEstadoPartida = async (req, res) => {
  try {
    const { codigo, jugador } = req.body;
    const partidaActual = await Partida.findById(codigo);
    if (partidaActual) {
      if (jugador === 1) {
        partidaActual.tableroBarcos1 = tablero;
        partidaActual.disparosRealizados1 = disparos;
      } else {
        partidaActual.tableroBarcos2 = tablero;
        partidaActual.disparosRealizados2 = disparos;
      }
      const partidaGuardada = await partidaActual.save();
      res.json(partidaGuardada);
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Funcion para guardar las estadisticas de cada jugador al finalizar la partida
// Devuelve las estadisticas de la partida de ambos jugadores
/**
 * @function actualizarEstadisticasFinales
 * @description Actualiza las estadísticas de los jugadores al finalizar la partida
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id] - El id de la partida, si no se proporciona se espera el codigo
 * @param {String} [req.body.codigo] - El codigo de la partida
 * @param {Object} res - El objeto de respuesta HTTP
 * @returns {Object} Las estadísticas de la partida de ambos jugadores
 * @example
 * peticion = { body: { codigo: '1234567890' } }
 * respuesta = { json: () => {} }
 * await actualizarEstadisticasFinales(peticion, respuesta)
 * @see module:perfilController.actualizarEstadisticas
 * @requires module:perfilController.actualizarEstadisticas
 */
exports.actualizarEstadisticasFinales = async (req, res) => {
  try {
    const { codigo } = req.body;
    const partidaActual = await Partida.findById(codigo);
    if (partidaActual) {
      // Actualizar estadisticas de los jugadores
      const estadisticasJ1 = {
        nombreId: partidaActual.nombreId1,                             // Nombre del jugador 1
        victoria: partidaActual.ganador === partidaActual.nombreId1 ? 1 : 0, // 1 si ganó, 0 si perdió. 
        nuevosBarcosHundidos: partidaActual.tableroBarcos2.filter(barco => barco.barcoHundido).length,
        nuevosBarcosPerdidos: partidaActual.tableroBarcos1.filter(barco => barco.barcoHundido).length,
        nuevosDisparosAcertados: partidaActual.disparosRealizados1.filter(disparo => disparo.resultado === 'Tocado' || disparo.resultado === 'Hundido').length,
        nuevosDisparosFallados: partidaActual.disparosRealizados1.filter(disparo => disparo.resultado === 'Agua').length,
        nuevosTrofeos: 20 // Place holder === TODO ELO
      };
      const estadisticasJ2 = {
        nombreId: partidaActual.nombreId2,                             // Nombre del jugador 1
        victoria: partidaActual.ganador === partidaActual.nombreId2 ? 1 : 0, // 1 si ganó, 0 si perdió. 
        nuevosBarcosHundidos: partidaActual.tableroBarcos1.filter(barco => barco.barcoHundido).length,
        nuevosBarcosPerdidos: partidaActual.tableroBarcos2.filter(barco => barco.barcoHundido).length,
        nuevosDisparosAcertados: partidaActual.disparosRealizados2.filter(disparo => disparo.resultado === 'Tocado' || disparo.resultado === 'Hundido').length,
        nuevosDisparosFallados: partidaActual.disparosRealizados2.filter(disparo => disparo.resultado === 'Agua').length,
        nuevosTrofeos: 20 // Place holder === TODO ELO
      };

      // Llamar a la función de perfilController para actualizar las estadísticas
      const req1 = { body: estadisticasJ1 };
      const req2 = { body: estadisticasJ2 };
      const res1 = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
      const res2 = { json: () => {}, status: () => ({ send: () => {} }) }; // No hace nada
      await actualizarEstadisticas(req1, res1);
      await actualizarEstadisticas(req2, res2);
      res.json({ estadisticasJ1, estadisticasJ2 });
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};


// Funcion para obtener el chat de una partida
/**
 * @function obtenerChat
 * @description Devuelve el chat de la partida
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id] - El id de la partida, si no se proporciona se espera el codigo
 * @param {String} [req.body.codigo] - El codigo de la partida
 * @param {Object} res - El objeto de respuesta HTTP
 * @returns {Object[]} El chat de la partida
 * @example
 * peticion = { body: { codigo: '1234567890' } }
 * respuesta = { json: () => {} }
 * await obtenerChat(peticion, respuesta)
 */
exports.obtenerChat = async (req, res) => {
  try {
    const { _id, codigo, ...extraParam  } = req.body;
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo (o _id), autor, mensaje');
      console.error("Sobran parámetros, se espera codigo (o _id), autor, mensaje");
      return;
    }
    if (!codigo && !_id) {
      res.status(400).send('Falta el codigo de partida');
      console.error("Falta el codigo de partida");
      return;
    }
    const filtro = _id ? { _id: _id } : { codigo: codigo };
    const partidaActual = await Partida.findOne(filtro);
    if (partidaActual) {
      res.json(partidaActual.chat);
    } else {
      res.status(404).send('Partida no encontrada');
      console.error('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error('Hubo un error');
  }
};

// Funcion para enviar un mensaje al chat de una partida
/**
 * @function enviarMensaje
 * @description Envia un mensaje al chat de la partida
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} [req.body._id] - El id de la partida, si no se proporciona se espera el codigo
 * @param {String} [req.body.codigo] - El codigo de la partida
 * @param {Number} req.body.autor - El número del jugador que envía el mensaje (1 o 2)
 * @param {String} req.body.mensaje - El mensaje a enviar
 * @param {Object} res - El objeto de respuesta HTTP
 * @returns {Partida} La partida modificada
 * @example
 * peticion = { body: { codigo: '1234567890', autor: 1, mensaje
 * : 'Hola' }
 * respuesta = { json: () => {} }
 * await enviarMensaje(peticion, respuesta)
 */
exports.enviarMensaje = async (req, res) => {
  try {
    const { _id, codigo, autor, mensaje, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra que no se espera
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo (o _id), autor, mensaje');
      console.error("Sobran parámetros, se espera codigo (o _id), autor, mensaje");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!codigo && !_id || !autor || !mensaje) {
      res.status(400).send('Falta alguno de los siguientes parámetros: codigo (o _id), autor o mensaje');
      console.error("Falta alguno de los siguientes parámetros: codigo (o _id), autor o mensaje");
      return;
    }
    // Verificar si el numero de jugador es correcto
    if (autor !== 1 && autor !== 2) {
      res.status(400).send('El jugador debe ser 1 o 2');
      console.error("El jugador debe ser 1 o 2");
      return;
    }
    // Verificar que existe la partida
    const filtro = _id ? { _id: _id } : { codigo: codigo };
    const partidaActual = await Partida.findOne(filtro);
    if (partidaActual) {
      let chat = partidaActual.chat;
      chat.push({ mensaje, autor, timestamp: new Date() });

      // Actualizar la partida
      const partidaModificada = await Partida.findOneAndUpdate(
        filtro, // Filtrar
        partidaActual, // Actualizar (partida contiene los cambios)
        { new: true } // Para devolver el documento actualizado
      );
      if (partidaModificada) {
        res.json(partidaModificada );
        console.log("Partida modificada con éxito");
      } else {
        res.status(404).send('No se ha encontrado la partida a actualizar');
        console.error("No se ha encontrado la partida a actualizar");
      }
    } else {
      console.error('Partida no encontrada');
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    console.error('Hubo un error', error);
    res.status(500).send('Hubo un error');
  }
};

