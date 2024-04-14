const Partida = require('../models/partidaModel');
const Perfil = require('../models/perfilModel');
const Coordenada = require('../data/coordenada')
const biomasDisponibles = require('../data/biomas');
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
function barcoColisiona(tablero, barco, barcoId) {
  for (let i = 0; i < barcoId; i++) { // Recorrer los otros barcos
    for (const coordenada of tablero[i].coordenadas) {
      for (const nuevaCoordenada of barco) {
        if (coordenada.i === nuevaCoordenada.i && coordenada.j === nuevaCoordenada.j) {
          return true; // Hay colisión
        }
      }
    }
  }
  for (let i = barcoId + 1; i < tablero.length; i++) {
    for (const coordenada of tablero[i].coordenadas) { // Recorrer los otros barcos
      for (const nuevaCoordenada of barco) {
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
  const tablero = [];
  for (let barco of barcosDisponibles) {
    let barcoGenerado = false;
    while (!barcoGenerado) {
      const orientacion = Math.random() < 0.5 ? 'horizontal' : 'vertical';
      const i = Math.floor(Math.random() * tableroDim) + 1;
      const j = Math.floor(Math.random() * tableroDim) + 1;
      const coordenadas = [];
      const barcoLongitud = barcosDisponibles.indexOf(barco) === 0 ? 2 : 
        barcosDisponibles.indexOf(barco) === 1 ? 3 :
        barcosDisponibles.indexOf(barco) === 2 ? 3 :
        barcosDisponibles.indexOf(barco) === 3 ? 4 : 5;
      for (let k = 0; k < barcoLongitud; k++) {
        if (orientacion === 'horizontal') {
          coordenadas.push(new Coordenada(i + k, j));
        } else {
          coordenadas.push(new Coordenada(i, j + k));
        }
      }
      // Comprobar si el barco colisiona con otros barcos
      for (let i = 0; i < tablero.length; i++) {
        if (barcoColisiona(tablero, coordenadas, i)) {
          continue;
        }
      }
      tablero.push({ coordenadas: coordenadas, tipo: barco });
      barcoGenerado = true;
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
 * @param {Partida} res - La partida creada
 * @param {Number} res.codigo - El código de la partida
 * @example 
 * peticion = { body: { nombreId1: 'jugador1', nombreId2: 'jugador2', bioma: 'Mediterraneo' } }
 * respuesta = { json: () => {} }
 * await crearPartida(peticion, respuesta)
 */
exports.crearPartida = async (req, res) => {
  try {
    const { _id1, _id2, nombreId1, nombreId2, bioma = 'Mediterraneo', ...extraParam } = req.body;
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
    if (jugador2) {
      tableroBarcos2 = jugador2.tableroInicial;
    } else {
      tableroBarcos2 = generarTableroAleatorio();
    }
    const codigo = generarCodigo();
    // Actualizamos los códigos de partida actuales de los jugadores
    jugador1.codigoPartidaActual = codigo;
    await Perfil.findOneAndUpdate(
      filtro1, // Filtrar
      jugador1, // Actualizar (jugador1 contiene los cambios)
      { new: true } // Para devolver el documento actualizado
    );
    if (jugador2) {
      jugador2.codigoPartidaActual = codigo;
      await Perfil.findOneAndUpdate(
        filtro2, // Filtrar
        jugador2, // Actualizar (jugador2 contiene los cambios)
        { new: true } // Para devolver el documento actualizado
      );
    }
    jugador1.contraseña = undefined;
    jugador1.listaAmigos = undefined;
    jugador1.solicitudesAmistad = undefined;
    jugador1.correo = undefined;
    jugador1.tableroInicial = undefined;
    jugador1.mazoHabilidades = undefined;

    if (jugador2) {
      jugador2.contraseña = undefined;
      jugador2.listaAmigos = undefined;
      jugador2.solicitudesAmistad = undefined;
      jugador2.correo = undefined;
      jugador2.tableroInicial = undefined;
      jugador2.mazoHabilidades = undefined;
    }

    const partida = new Partida({ 
      codigo, 
      jugador1, 
      jugador2, 
      tableroBarcos1,
      tableroBarcos2,
      bioma
    });
    const partidaGuardada = await partida.save();
    res.json(partidaGuardada); 
    return partidaGuardada;
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error('Hubo un error');
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
 * @param {Tablero} res.tableroBarcos - El tablero de barcos del jugador
 * @param {Coordenada[]} res.disparosRealizados - Los disparos realizados por el jugador
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
    const partida = await Partida.findOne(filtro);
    if (partida) {
      const jugador1 = await Perfil.findById(partida.jugador1);
      const jugador2 = await Perfil.findById(partida.jugador2);
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
        tableroBarcos: jugador === 1 ? partida.tableroBarcos1 : partida.tableroBarcos2,
        disparosRealizados: jugador === 1 ? partida.disparosRealizados2 : partida.disparosRealizados1
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
 * @returns {Tablero} El tablero de barcos del jugador enemigo
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
    const partida = await Partida.findOne(filtro);
    if (partida) {
      const jugador1 = await Perfil.findById(partida.jugador1);
      const jugador2 = await Perfil.findById(partida.jugador2);
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
      const tablero = {
        tableroBarcos: jugador === 1 ? partida.disparosRealizados1 : partida.disparosRealizados2
      };
      console.log('Tablero enemigo obtenido con éxito');
      res.json(tablero);
      console.log(tablero);
      return tablero;
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
 * @returns {Object} Los tableros y disparos realizados de ambos jugadores
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
    const partida = await Partida.findOne(filtro);
    if (partida) {      
      const jugador1 = await Perfil.findById(partida.jugador1);
      const jugador2 = await Perfil.findById(partida.jugador2);
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
      const tableros = {
        tableroBarcos1: partida.tableroBarcos1,
        tableroBarcos2: partida.tableroBarcos2,
        disparosRealizados1: partida.disparosRealizados1,
        disparosRealizados2: partida.disparosRealizados2
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
    if (!codigo && !_id || !nombreId || !i || !j) {
      res.status(400).send('Falta alguno de los siguientes parámetros: codigo (o _id), jugador, i o j');
      console.error("Falta alguno de los siguientes parámetros: codigo (o _id), jugador, i o j");
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
    const partida = await Partida.findOne(filtro);
    if (partida) {
      const jugador1 = await Perfil.findById(partida.jugador1);
      const jugador2 = await Perfil.findById(partida.jugador2);
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
      if (jugador === 1 && partida.contadorTurno % 2 === 0 || 
            jugador === 2 && partida.contadorTurno % 2 === 1) {
        res.status(400).send('No es el turno del jugador');
        console.error('No es el turno del jugador');
        return;
      }

      const partidaContraIA = !partida.jugador2;
      // Realizar disparo
      let barcoDisparado = jugador === 1 ? dispararCoordenada(partida.tableroBarcos2, i, j) :
      dispararCoordenada(partida.tableroBarcos1, i, j);
      let disparo = { i, j, estado: 'Agua' };
      if (barcoDisparado) { 
        disparo.estado = 'Tocado'; // Los disparos solo son Agua o Tocado
        if (barcoDisparado.coordenadas.every(coordenada => coordenada.estado === 'Tocado')) {
          barcoDisparado.coordenadas.map(coordenada => coordenada.estado = 'Hundido');
          disparo.estado = 'Hundido';
        }
      } else {  // Sólo cambia el turno si se falla el disparo
        partida.contadorTurno++;
      }
      let disparosRealizados = jugador === 1 ? partida.disparosRealizados1 :
                                              partida.disparosRealizados2;
      disparosRealizados.push(disparo);
      jugador === 1 ? partida.disparosRealizados1 = disparosRealizados : 
        partida.disparosRealizados2 = disparosRealizados;

      
      // Comprobar si la partida ha terminado
      let finPartida = false;
      if (jugador === 1) {
        finPartida = partida.tableroBarcos2.every(barco =>
          barco.coordenadas.every(coordenada => coordenada.estado === 'Hundido'));
      } else {
        finPartida = partida.tableroBarcos1.every(barco =>
          barco.coordenadas.every(coordenada => coordenada.estado === 'Hundido'));
      }

      if (finPartida ) {
        let jugador1 = await Perfil.findById(partida.jugador1);
        let jugador2 = await Perfil.findById(partida.jugador2);
        if (jugador === 1) {
          partida.ganador = jugador1.nombreId;
        } else {
          partida.ganador = jugador2.nombreId;
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
      
      if (partidaContraIA && disparo.estado === 'Agua' && !finPartida) {
        const psoibleDisparoIA = generarDisparoAleatorio(partida.disparosRealizados2);
        let barcoDisparadoIA = dispararCoordenada(partida.tableroBarcos1, 
          posibleDisparoIA.i, posibleDisparoIA.j);
          let disparoIA = { i: disparoIA.i, j: disparoIA.j, estado: 'Agua' };
        if (barcoDisparadoIA) {
          disparoIA.estado = 'Tocado';
          barcoDisparadoIA.coordenadas.every(coordenada => coordenada.estado === 'Tocado') && 
          barcoDisparadoIA.coordenadas.map(coordenada => coordenada.estado = 'Hundido') &&
          (disparoIA.estado = 'Hundido');
        }
        partida.disparosRealizados2.push(disparoIA);

        // Comprobar si la partida ha terminado
        finPartidaIA = partida.tableroBarcos1.every(barco =>
          barco.coordenadas.every(coordenada => coordenada.estado === 'Hundido'));
        if (finPartidaIA) {
          partida.ganador = 'IA';
        }
      }

      // Actualizar la partida
      const partidaModificada = await Partida.findOneAndUpdate(
        filtro, // Filtrar
        partida, // Actualizar (partida contiene los cambios)
        { new: true } // Para devolver el documento actualizado
      );

      if (partidaModificada) {
        let turnoIA = undefined;
        if (partidaContraIA && disparo.estado === 'Agua') {
          turnoIA = {
            disparoRealizado: disparoIA,
            barcoCoordenadas: (disparoIA.estado === 'Hundido') ? barcoDisparadoIA : undefined,
            eventoOcurrido: undefined, // Evento ocurrido en la partida
            finPartida: finPartidaIA,
            clima: partida.clima
          }
        }
        const respuestaDisparo = {
          disparoRealizado: disparo,
          barcoCoordenadas: (disparo.estado === 'Hundido') ? barcoDisparado : undefined,
          eventoOcurrido: undefined, // Evento ocurrido en la partida
          finPartida: finPartida,
          clima: partida.clima,
          turnoIA: turnoIA
        };
        
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
    const partida = await Partida.findById(codigo);
    if (partida) {
      if (jugador === 1) {
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

// Necesitamos alterar las estadisticas almacenadas en el perfil de los jugadores
const { actualizarEstadisticas } = require('./perfilController');
const Tablero = require('../data/tablero');
const { coordenadas } = require('../data/barco');

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
    const partida = await Partida.findById(codigo);
    if (partida) {
      // Actualizar estadisticas de los jugadores
      const estadisticasJ1 = {
        nombreId: partida.jugador1,                             // Nombre del jugador 1
        victoria: partida.ganador === partida.jugador1 ? 1 : 0, // 1 si ganó, 0 si perdió. 
        nuevosBarcosHundidos: partida.tableroBarcos2.filter(barco => barco.barcoHundido).length,
        nuevosBarcosPerdidos: partida.tableroBarcos1.filter(barco => barco.barcoHundido).length,
        nuevosDisparosAcertados: partida.disparosRealizados1.filter(disparo => disparo.resultado === 'Tocado' || disparo.resultado === 'Hundido').length,
        nuevosDisparosFallados: partida.disparosRealizados1.filter(disparo => disparo.resultado === 'Agua').length,
        nuevosTrofeos: 20 // Place holder === TODO ELO
      };
      const estadisticasJ2 = {
        nombreId: partida.jugador2,                             // Nombre del jugador 1
        victoria: partida.ganador === partida.jugador2 ? 1 : 0, // 1 si ganó, 0 si perdió. 
        nuevosBarcosHundidos: partida.tableroBarcos1.filter(barco => barco.barcoHundido).length,
        nuevosBarcosPerdidos: partida.tableroBarcos2.filter(barco => barco.barcoHundido).length,
        nuevosDisparosAcertados: partida.disparosRealizados2.filter(disparo => disparo.resultado === 'Tocado' || disparo.resultado === 'Hundido').length,
        nuevosDisparosFallados: partida.disparosRealizados2.filter(disparo => disparo.resultado === 'Agua').length,
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
    const partida = await Partida.findOne(filtro);
    if (partida) {
      res.json(partida.chat);
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
    const partida = await Partida.findOne(filtro);
    if (partida) {
      let chat = partida.chat;
      chat.push({ mensaje, autor, timestamp: new Date() });

      // Actualizar la partida
      const partidaModificada = await Partida.findOneAndUpdate(
        filtro, // Filtrar
        partida, // Actualizar (partida contiene los cambios)
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

