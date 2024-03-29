const Partida = require('../models/partidaModel');
const Perfil = require('../models/perfilModel');
const Coordenada = require('../data/coordenada')
const biomasDisponibles = require('../data/biomas');
const tableroDim = Coordenada.i.max;  // Dimensiones del tablero


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

// -------------------------------------------- //
// ----------- FUNCIONES EXPORTADAS ----------- //
// -------------------------------------------- //

// Crear una partida
exports.crearPartida = async (req, res) => {
  try {
    const { _id1, _id2, nombreId1, nombreId2, bioma = 'Mediterraneo', ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId1 (o _id1), nombreId2 (o _id2) y bioma');
      console.error("Sobran parámetros, se espera nombreId1 (o _id1), nombreId2 (o _id2) y bioma");
      return;
    }
    // Verificar si alguno de los jugadores está ausente en la solicitud
    if (!nombreId1 && !_id1 || !nombreId2 && !_id2) {
      res.status(400).send('Falta el nombreId1 (o _id1) o nombreId2 (o _id2) en la solicitud');
      console.error("Falta el nombreId1 (o _id1) o nombreId2 (o _id2) en la solicitud");
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
    const jugador1 = await Perfil.findOne(filtro1);
    if (!jugador1) {
      res.status(404).send('No se ha encontrado el jugador 1');
      console.error("No se ha encontrado el jugador 1");
      return;
    } 
    const filtro2 = _id2 ? { _id: _id2 } : { nombreId: nombreId2 };
    const jugador2 = await Perfil.findOne(filtro2);
    if (!jugador2) {
      res.status(404).send('No se ha encontrado el jugador 2');
      console.error("No se ha encontrado el jugador 2");
      return;
    } 
    // Obtenemos los tableros de barcos de los jugadores y generamos un código único
    const tableroBarcos1 = jugador1.tableroInicial;
    const tableroBarcos2 = jugador2.tableroInicial;
    const codigo = generarCodigo();
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
    console.log("Partida creada con éxito", partidaGuardada);
    return partidaGuardada;
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Mostrar tablero de barcos de un jugador 
exports.mostrarMiTablero = async (req, res) => {
  try {
    const { _id, codigo, jugador, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo (o _id) y jugador');
      console.error("Sobran parámetros, se espera codigo (o _id) y jugador");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!codigo && !_id || !jugador) {
      res.status(400).send('Falta el codigo (o _id) y/o jugador');
      console.error("Falta el codigo (o _id) y/o jugador");
      return;
    }
    // Verificar que jugador es 1 o 2
    if (jugador !== 1 && jugador !== 2) {
      res.status(400).send('El jugador debe ser 1 o 2');
      console.error("El jugador debe ser 1 o 2");
      return;
    }
    const filtro = _id ? { _id: _id } : { codigo: codigo };
    const partida = await Partida.findOne(filtro);
    if (partida) {
      const tablero = {
        tableroBarcos: jugador === 1 ? partida.tableroBarcos1 : partida.tableroBarcos2
      };
      console.log('Mi tablero obtenido con éxito');
      res.json(tablero);
      console.log(tablero);
    } else {
      res.status(404).send('Partida no encontrada');
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
  }
};

// Mostrar tablero de barcos del jugador enemigo junto a mis disparos
exports.mostrarTableroEnemigo = async (req, res) => {
  try {
    const { _id, codigo, jugador, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo (o _id) y jugador');
      console.error("Sobran parámetros, se espera codigo (o _id) y jugador");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!codigo && !_id || !jugador) {
      res.status(400).send('Falta el codigo (o _id) y/o jugador');
      console.error("Falta el codigo (o _id) y/o jugador");
      return;
    }
    // Verificar que jugador es 1 o 2
    if (jugador !== 1 && jugador !== 2) {
      res.status(400).send('El jugador debe ser 1 o 2');
      console.error("El jugador debe ser 1 o 2");
      return;
    }
    const filtro = _id ? { _id: _id } : { codigo: codigo };
    const partida = await Partida.findOne(filtro);
    if (partida) {
      const tablero = {
        tableroBarcos: jugador === 1 ? partida.tableroBarcos2 : partida.tableroBarcos1,
        disparosRealizados: jugador === 1 ? partida.disparosRealizados1 : partida.disparosRealizados2
      };
      console.log('Tablero enemigo obtenido con éxito');
      res.json(tablero);
      console.log(tablero);
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
    console.log("Realizar disparo con body", req.body);
    let { codigo, jugador, i, j, ...extraParam } = req.body;

    // Verificar si recibimos una coordenada en vez de dos enteros
    if (extraParam.coordenada && esNumero(extraParam.coordenada.i) && esNumero(extraParam.coordenada.j)){
      i = extraParam.coordenada.i;
      j = extraParam.coordenada.j;
      extraParam = {};
    }

    // Verificar si hay algún parámetro extra que no se espera
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera codigo, jugador, i, j');
      console.error("Sobran parámetros, se espera codigo, jugador, i, j");
      return;
    }

    // Verificar si alguno de los parámetros está ausente
    if (!codigo || !jugador || !i || !j) {
      res.status(400).send('Falta alguno de los siguientes parámetros: codigo, jugador, i o j');
      console.error("Falta alguno de los siguientes parámetros: codigo, jugador, i o j");
      return;
    }

    // Verificar si el numero de jugador es correcto
    if (jugador !== 1 && jugador !== 2) {
      res.status(400).send('El jugador debe ser 1 o 2');
      console.error("El jugador debe ser 1 o 2");
      return;
    }
    
    // Comprobar si i, j son casillas válidas
    if (i < 1 || i > tableroDim || j < 1 || j > tableroDim) {
      res.status(400).send('Las coordenadas i, j deben estar entre 1 y 10');
      console.error("Las coordenadas i, j deben estar entre 1 y 10");
      return;
    }

    // Buscar la partida
    let partida = await Partida.findById(codigo);
    console.log("Partida encontrada", partida);
    if (partida) {

      // Comprobar si la casilla ya fue disparada
      let disparosRealizados = jugador === 1 ? partida.disparosRealizados1 : partida.disparosRealizados2;
      const disparoRepetido = disparosRealizados.find(disparo => disparo.i === i && disparo.j === j);
      if (disparoRepetido) {
        res.status(400).send('Casilla ya disparada');
        console.error("Casilla ya disparada");
        return;
      }

      // Realizar disparo
      let barcoTocado = jugador === 1 ? dispararCoordenada(partida.tableroBarcos2, i, j) :
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
        { codigo: codigo }, // Filtrar
        partida, // Actualizar (partida contiene los cambios)
        { new: true } // Para devolver el documento actualizado
      );

      if (partidaModificada) {
        res.json(partidaModificada );
        console.log("Partida modificada con éxito", partidaModificada);
        return partidaModificada;
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
    const { codigo, jugador, tablero, disparos } = req.body;
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


// Funcion para actualizar las estadisticas de cada jugador al finalizar la partida
exports.actualizarEstadisticasFinales = async (req, res) => {
  try {
    const { codigo } = req.body;
    const partida = await Partida.findById(codigo);
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



