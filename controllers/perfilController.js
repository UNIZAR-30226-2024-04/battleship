const Perfil = require('../models/perfilModel');
const bcrypt = require('bcrypt'); // Para hash de constraseña
const jwt = require('jsonwebtoken'); // Para generar tokens JWT
const crypto = require('crypto'); // Para generar claves secretas
const habilidadesDisponibles = require('../data/habilidades')
// const Barco = require('../data/barco')
const Tablero = require('../data/tablero')
// Crear un perfil
exports.crearPerfil = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, contraseña, correo, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId, contraseña y correo');
      console.error("Sobran parámetros, se espera nombreId, contraseña y correo");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId || !contraseña || !correo) {
      res.status(400).send('Falta el nombreId, la contraseña y/o el correo');
      console.error("Falta el nombreId, la contraseña y/o el correo");
      return;
    }
    // Comprobar que la contraseña cumple con los requisitos
    if (!verificarContraseña(contraseña)) {
      res.status(400).send('La contraseña debe tener al menos 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial');
      console.error("La contraseña debe tener al menos 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial");
      return;
    }
    // Comprobar que el correo es válido
    if (!verificarCorreo(correo)) {
      res.status(400).send('El correo no es válido: ');
      console.error("El correo no es válido");
      return;
    }
    // Generar hash de la contraseña
    const hashContraseña = await bcrypt.hash(contraseña, 10); // 10 es el número de saltos de hashing

    // Comprobar que no existe perfil con ese id
    const doc = await Perfil.findOne({ nombreId: nombreId });
    if (doc) {
      res.status(400).send('Ya existe un perfil con ese nombre de usuario');
      console.error("Ya existe un perfil con ese nombre de usuario");
      return;
    }

    // Crear un tablero aleatorio con un barco de 5 casillas de largo. Coordenadas de izda a derecha o de arriba a abajo.
    const tableroInicial = [
      [{ x: 1, y: 1 }, { x: 1, y: 2 }],
      [{ x: 7, y: 1 }, { x: 8, y: 1 }, { x: 9, y: 1 }],
      [{ x: 3, y: 10 }, { x: 4, y: 10 }, { x: 5, y: 10 }],
      [{ x: 4, y: 4 }, { x: 5, y: 5 }, { x: 6, y: 6 }, { x: 7, y: 7 }],
      [{ x: 10, y: 6 }, { x: 10, y: 7 }, { x: 10, y: 8 }, { x: 10, y: 9 }, { x: 10, y: 10 }]
    ];
      
    
    // Creación del perfil en la base de datos
    const nuevoPerfil = new Perfil({
      nombreId,
      contraseña: hashContraseña,
      correo,
      tableroInicial
    });

    // Guardar el perfil en la base de datos
    const perfilGuardado = await nuevoPerfil.save();
    // Enviar la respuesta al cliente
    res.json(perfilGuardado);
    console.log("Perfil creado con éxito", perfilGuardado);
    return perfilGuardado;
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al crear el perfil", error);
  }
};

// Modificar datos personales de un perfil
exports.modificarPerfilDatosPersonales = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, contraseña, correo, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId, contraseña y/o correo');
      console.error("Sobran parámetros, se espera nombreId, contraseña y/o correo");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).send('Falta el nombreId en la solicitud');
      console.error("Falta el nombreId en la solicitud");
      return;
    }
    // Comprobar que la contraseña cumple con los requisitos
    if (contraseña && !verificarContraseña(contraseña)) {
      res.status(400).send('La contraseña debe tener al menos 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial');
      console.error("La contraseña debe tener al menos 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial");
      return;
    }
    // Comprobar que el correo es válido
    if (correo && !verificarCorreo(correo)) {
      res.status(400).send('El correo no es válido');
      console.error("El correo no es válido");
      return;
    }
    // Generar hash de la contraseña si se proporciona
    let hashContraseña; // valor undefined (si no se le da valor, no se tendrá en cuenta en el $set)
    if (contraseña) {
      hashContraseña = await bcrypt.hash(contraseña, 10); // 10 es el número de saltos de hashing
    }
    // Buscar y actualizar el perfil en la base de datos
    const perfilModificado = await Perfil.findOneAndUpdate(
      { nombreId: nombreId }, // Filtro para encontrar el perfil a modificar
      {
        $set: {
          contraseña: hashContraseña,
          correo: correo
        }
      },
      { new: true } // Para devolver el documento actualizado
    );

    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfilModificado) {
      res.json(perfilModificado);
      console.log("Perfil modificado con éxito", perfilModificado);
    } else {
      res.status(404).send('No se ha encontrado el perfil a modificar');
      console.error("No se ha encontrado el perfil a modificar");
    }

  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al modificar el perfil", error);
  }
};

// Modificar mazo de un perfil
exports.modificarMazo = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, mazoHabilidades = [], ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId y mazoHabilidades');
      console.error("Sobran parámetros, se espera nombreId y mazoHabilidades");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).send('Falta el nombreId en la solicitud');
      console.error("Falta el nombreId en la solicitud");
      return;
    }
    // Verificar si mazoHabilidades es un array y tiene como máximo 3 elementos
    if (!Array.isArray(mazoHabilidades) || mazoHabilidades.length > 3) {
      res.status(400).send('El mazo debe tener como máximo 3 habilidades');
      console.error("El mazo debe tener como máximo 3 habilidades");
      return;
    }
    // Verificar si todas las habilidades elegidas están en la lista de habilidades disponibles
    const habilidadesNoDisponibles = mazoHabilidades.filter(habilidad => !habilidadesDisponibles.includes(habilidad));
    if (habilidadesNoDisponibles.length > 0) {
      res.status(400).send('Las habilidades deben ser Rafaga, Recargado, Sonar, Mina o Teledirigido');
      console.error("Las habilidades deben ser Rafaga, Recargado, Sonar, Mina o Teledirigido");
      return;
    }
    // Buscar y actualizar el perfil en la base de datos
    const perfilModificado = await Perfil.findOneAndUpdate(
      { nombreId: nombreId }, // Filtro para encontrar el perfil a modificar
      {
        $set: {
          mazoHabilidades: mazoHabilidades
        }
      },
      { new: true } // Para devolver el documento actualizado
    );

    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfilModificado) {
      res.json(perfilModificado);
      console.log("Mazo modificado con éxito", perfilModificado);
    } else {
      res.status(404).send('No se ha encontrado el perfil a modificar');
      console.error("No se ha encontrado el perfil a modificar");
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al modificar el mazo", error);
  }
};

// Función para verificar si un barco es horizontal
function esBarcoHorizontal(barco) {
  return barco.length > 1 && barco[0].y == barco[1].y;
}

// Función para devolver un barco trasladado y/o rotado dentro del tablero
function moverBarco(barco, nuevaXProa, nuevaYProa, rotar) {
  nuevoBarco = barco;
  // Definir traslación y mover proa
  if (nuevaXProa) {
    nuevoBarco[0].x = nuevaXProa;
    difX = nuevaXProa - barco[0].x;
  } else difX = 0;
  if (nuevaYProa) {
    nuevoBarco[0].y = nuevaYProa;
    difY = nuevaYProa - barco[0].y;
  } else difY = 0;
  // Mover resto del barco
  if (rotar) {  // Rotar y trasladar
    if (esBarcoHorizontal(barco)) {
      for (let i = 1; i < barco.length; i++) {
        nuevaX = nuevoBarco[i].x - i + difX;
        if (1 <= nuevaX && nuevaX <= 10) nuevoBarco[i].x = nuevaX;
        else return null;
        nuevaY = nuevoBarco[i].y - i + difY;
        if (1 <= nuevaY && nuevaY <= 10) nuevoBarco[i].y = nuevaY;
        else return null;
      }
    } else {  // Barco vertical
      for (let i = 1; i < barco.length; i++) {
        nuevaX = nuevoBarco[i].x + i + difX;
        if (1 <= nuevaX && nuevaX <= 10) nuevoBarco[i].x = nuevaX;
        else return null;
        nuevaY = nuevoBarco[i].y + i + difY;
        if (1 <= nuevaY && nuevaY <= 10) nuevoBarco[i].y = nuevaY;
        else return null;
      }
    }
  } else {  // Solo trasladar
    for (let i = 1; i < barco.length; i++) {
      nuevaX = nuevoBarco[i].x + difX;
      if (1 <= nuevaX && nuevaX <= 10) nuevoBarco[i].x = nuevaX;
      else return null;
      nuevaY = nuevoBarco[i].y + difY;
      if (1 <= nuevaY && nuevaY <= 10) nuevoBarco[i].y = nuevaY;
      else return null;
    }
  }
  // El movimiento está en rango del tablero
  return nuevoBarco;
}

// Función para verificar si el barco que irá en la posición barcoId colisiona con otros barcos
function barcoColisiona(tablero, nuevoBarco, barcoId) {
  for (let i = 0; i < barcoId; i++) { // Recorrer los otros barcos
    for (const coordenada of tablero[i]) {
      for (const nuevaCoordenada of nuevoBarco) {
        if (coordenada.x === nuevaCoordenada.x && coordenada.y === nuevaCoordenada.y) {
          return true; // Hay colisión
        }
      }
    }
  }
  for (let i = barcoId + 1; i < tablero.length; i++) {
    for (const coordenada of tablero[i]) { // Recorrer los otros barcos
      for (const nuevaCoordenada of nuevoBarco) {
        if (coordenada.x === nuevaCoordenada.x && coordenada.y === nuevaCoordenada.y) {
          return true; // Hay colisión
        }
      }
    }
  }
  return false; // No hay colisión
}

// Modificar tablero de un perfil
exports.modificarTablero = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, barcoId = 0, nuevaXProa, nuevaYProa, rotar, ...extraParam } = req.body;  // Consideramos proa la coordenada más izda/arriba si barco horizontal/vertical
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId, barcoId, nuevaXProa, nuevaYProa y/o rotar');
      console.error("Sobran parámetros, se espera nombreId, barcoId, nuevaXProa, nuevaYProa y/o rotar");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).send('Falta el nombreId en la solicitud');
      console.error("Falta el nombreId en la solicitud");
      return;
    }
    // Verificar que los parámetros del movimiento son numéricos
    if (!esNumero(barcoId) || (nuevaXProa && !esNumero(nuevaXProa)) || (nuevaYProa && !esNumero(nuevaYProa)) 
      || (rotar && !esNumero(rotar))) {
      res.status(400).send('Los parámetros del movimiento deben ser numéricos');
      console.error("Los parámetros del movimiento deben ser numéricos");
      return;
    }
    // Verificar que barcoId es un índice válido de tableroInicial
    if (barcoId < 0 || barcoId >= tableroInicial.length) {
      res.status(400).send('barcoId debe estar entre 0 y ${tableroInicial.length - 1}');
      console.error("barcoId debe estar entre 0 y ${tableroInicial.length - 1}");
      return;
    }
    // Verificar que la nueva coordenada de proa está en el rango correcto
    if (nuevaXProa < 1 || nuevaXProa > 10 || nuevaYProa < 1 || nuevaYProa > 10) {
      res.status(400).send('Las coordenadas de la nueva proa deben estar entre 1 y 10');
      console.error('Las coordenadas de la nueva proa deben estar entre 1 y 10');
      return;
    }
    // Buscar el perfil en la base de datos y obtener su tableroInicial
    const perfil = await Perfil.findOne({ nombreId: nombreId });
    if (!perfil) {
      res.status(404).send('No se ha encontrado el perfil a modificar');
      console.error("No se ha encontrado el perfil a modificar");
      return;
    } 
    tableroInicial = perfil.tableroInicial;
    barco = tableroInicial[barcoId];
    // Verificar que la nueva posición del barco está en el rango correcto
    nuevoBarco = moverBarco(barco, nuevaXProa, nuevaYProa, rotar);
    if (nuevoBarco) {
      // Verificar que la nueva posición del barco no colisiona con otros barcos
      if (barcoColisiona(tableroInicial, nuevoBarco, barcoId)) {
        res.status(404).send('El movimiento del barco colisiona con otros barcos');
        console.error("El movimiento del barco colisiona con otros barcos");
        return;
      }
    } else {
      res.status(404).send('El movimiento del barco se sale del tablero');
      console.error("El movimiento del barco se sale del tablero");
      return;
    }
    // Buscar y actualizar el perfil en la base de datos
    const perfilModificado = await Perfil.findOneAndUpdate(
      { nombreId: nombreId }, // Filtro para encontrar el perfil a modificar
      {
        $set: {
          tableroInicial: tableroInicial
        }
      },
      { new: true } // Para devolver el documento actualizado
    );
    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfilModificado) {
      res.json(perfilModificado);
      console.log("Tablero inicial modificado con éxito", perfilModificado);
    } else {
      res.status(404).send('No se ha encontrado el perfil a modificar');
      console.error("No se ha encontrado el perfil a modificar");
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al modificar el tablero inicial", error);
  }
};

// Modificar estadisticas de un perfil tras partida
exports.actualizarEstadisticas = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, victoria, nuevosBarcosHundidos, nuevosBarcosPerdidos, nuevosDisparosAcertados, 
      nuevosDisparosFallados, nuevosTrofeos = 0, ...extraParam} = req.body; // Por defecto, no hay trofeos en juego
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId, victoria, nuevosBarcosHundidos, nuevosBarcosPerdidos, nuevosDisparosAcertados, nuevosDisparosFallados y nuevosTrofeos');
      console.error("Sobran parámetros, se espera nombreId, victoria, nuevosBarcosHundidos, nuevosBarcosPerdidos, nuevosDisparosAcertados, nuevosDisparosFallados y nuevosTrofeos");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).send('Falta el nombreId en la solicitud');
      console.error("Falta el nombreId en la solicitud");
      return;
    }
    // Verificar que las estadísticas son numéricas
    if (!esNumero(victoria) || !esNumero(nuevosBarcosHundidos) || !esNumero(nuevosBarcosPerdidos) || 
      !esNumero(nuevosDisparosAcertados) || !esNumero(nuevosDisparosFallados) || !esNumero(nuevosTrofeos)) {
        res.status(400).send('Las estadísticas deben ser numéricas');
        console.error("Las estadísticas deben ser numéricas");
        return;
    }
    // Buscar y actualizar el perfil en la base de datos
    const perfilModificado = await Perfil.findOneAndUpdate(
      { nombreId: nombreId }, // Filtro para encontrar el perfil a modificar
      {
        $inc: {
          partidasJugadas: 1,
          partidasGanadas: victoria ? 1 : 0,
          barcosHundidos: nuevosBarcosHundidos,
          barcosPerdidos: nuevosBarcosPerdidos,
          disparosAcertados: nuevosDisparosAcertados,
          disparosFallados: nuevosDisparosFallados,
          trofeos: victoria ? nuevosTrofeos : -nuevosTrofeos
        }
      },
      { new: true } // Para devolver el documento actualizado
    );
    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfilModificado) {
      res.json(perfilModificado);
      console.log("Perfil modificado con éxito", perfilModificado);
    } else {
      res.status(404).send('No se ha encontrado el perfil a actualizar');
      console.error("No se ha encontrado el perfil a actualizar");
    }

  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al actualizar el perfil", error);
  }
};

// Modificar puntos de experiencia de un perfil
exports.actualizarPuntosExperiencia = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, nuevosPuntosExperiencia, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId y nuevosPuntosExperiencia');
      console.error("Sobran parámetros, se espera nombreId y nuevosPuntosExperiencia");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).send('Falta el nombreId en la solicitud');
      console.error("Falta el nombreId en la solicitud");
      return;
    }
    // Verificar que la experiencia es numérica
    if (!esNumero(nuevosPuntosExperiencia)) {
        res.status(400).send('Los puntos de experiencia deben ser numéricos');
        console.error("Los puntos de experiencia deben ser numéricos");
        return;
    }
    // Buscar y actualizar el perfil en la base de datos
    const perfilModificado = await Perfil.findOneAndUpdate(
      { nombreId: nombreId }, // Filtro para encontrar el perfil a modificar
      {
        $inc: {
          puntosExperiencia: nuevosPuntosExperiencia
        }
      },
      { new: true } // Para devolver el documento actualizado
    );
    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfilModificado) {
      res.json(perfilModificado);
      console.log("Perfil modificado con éxito", perfilModificado);
    } else {
      res.status(404).send('No se ha encontrado el perfil a actualizar');
      console.error("No se ha encontrado el perfil a actualizar");
    }

  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al actualizar el perfil", error);
  }
};

// Funcion para comprobar que un parametro es un correo electronico
function verificarCorreo(correo) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(correo);
}

// Funcion para verificar que la contraseña cumple con los requisitos: 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial
function verificarContraseña(contraseña) {
  const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$/;
  return regex.test(contraseña);
}

// Funcion para comprobar que un dato es un numero
function esNumero(numero) {
  return !isNaN(numero);
}

// Obtener un perfil
exports.obtenerPerfil = async (req, res) => {
  try {
    // Extraer el nombreId del parámetro de la solicitud
    const { nombreId, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId');
      console.error("Sobran parámetros, se espera nombreId");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).send('Falta el nombreId en la solicitud');
      console.error("Falta el nombreId en la solicitud");
      return;
    }
    // Buscar el perfil en la base de datos
    const perfil = await Perfil.findOne({ nombreId: nombreId });
    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfil) {
      res.json(perfil);
      console.log("Perfil obtenido con éxito", perfil);
      return perfil;
    } else {
      res.status(404).send('No se ha encontrado el perfil a obtener');
      console.error("No se ha encontrado el perfil a obtener");
    }

  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al obtener el perfil", error);
  }
};

// Eliminar un perfil
exports.eliminarPerfil = async (req, res) => {
  try {
    // Extraer el nombreId del parámetro de la solicitud
    const { nombreId, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId');
      console.error("Sobran parámetros, se espera nombreId");
      return;
    }
    // Comprobar si el nombreId está presente en la solicitud
    if (!nombreId) {
      res.status(400).send('Falta el nombreId en la solicitud');
      console.error("Falta el nombreId en la solicitud");
      return;
    }
    // Buscar y eliminar el perfil de la base de datos
    const resultado = await Perfil.deleteOne({ nombreId: nombreId });
    // Verificar si se eliminó el perfil y enviar la respuesta al cliente
    if (resultado.deletedCount > 0) {
      res.json({ mensaje: 'Perfil eliminado correctamente' });
      console.log("Perfil eliminado correctamente");
    } else {
      res.status(404).send('No se ha encontrado el perfil a eliminar');
      console.error("No se ha encontrado el perfil a eliminar");
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al eliminar el perfil", error);
  }
};

// Autenticar usuario
exports.autenticarUsuario = async (req, res) => { // Requiere nombreId y contraseña
  try {
    // Extraer los parámetros del cuerpo de la solicitud
    const { nombreId, contraseña, ...extraParam } = req.body;
    // Verificar si hay algún parámetro extra
    if (Object.keys(extraParam).length > 0) {
      res.status(400).send('Sobran parámetros, se espera nombreId y contraseña');
      console.error("Sobran parámetros, se espera nombreId y contraseña");
      return;
    }
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId || !contraseña) {
      res.status(400).send('Falta el nombreId y la contraseña en la solicitud');
      console.error("Falta el nombreId y la contraseña en la solicitud");
      return;
    }
    // Buscar el perfil en la base de datos
    const perfil = await Perfil.findOne({ nombreId: nombreId });
    if (perfil) {
      // Verificar la contraseña
      const contraseñaValida = await bcrypt.compare(contraseña, perfil.contraseña);
      if (!contraseñaValida) {
        res.status(404).send('La contraseña no es válida');
        console.error("La contraseña no es válida");
        return;
      }
      res.json(perfil);
      console.log("Perfil autenticado con éxito", perfil);
      return perfil
    } else {
      res.status(404).send('No se ha encontrado el perfil a autenticar');
      console.error("No se ha encontrado el perfil a autenticar");
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al autenticar al usuario", error);
    return;
  }
};

// Funcion para crear un token de sesión
function crearToken(perfil) {
  // Generar bytes aleatorios para la clave privada
  const clavePrivadaBuffer = crypto.randomBytes(32);
  const clavePrivada = clavePrivadaBuffer.toString('hex');
  // Si el nombre de usuario y la contraseña son válidos, generar un token JWT
  const token = jwt.sign(perfil.toJSON(), clavePrivada);
  return token;
}

// Iniciar sesión
exports.iniciarSesion = async (req, res) => { // Requiere nombreId y contraseña
  try {
    // Buscar el perfil en la base de datos
    const perfil = await exports.autenticarUsuario(req, res);
    if (perfil) {
      const token = crearToken(perfil);
      // Enviar el token como respuesta al cliente
      res.json(token);
      console.log("Sesión iniciada con éxito", token);
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al iniciar sesión", error);
  }
};

// Registrar usuario
exports.registrarUsuario = async (req, res) => {  // Requiere nombreId, contraseña y correo
  try {
    // Crear el perfil
    const perfil = await exports.crearPerfil(req, res);
    if (perfil) {
      const token = crearToken(perfil);
      // Enviar el token como respuesta al cliente
      res.json(token);
      console.log("Usuario registrado con éxito", token);
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al registrar usuario", error);
  }
};

// // SEGURIDAD
// // RESPUESTA DE LA API:

// app.get('/api/perfiles/:id', async (req, res) => {
//   try {
//     const perfil = await Perfil.findById(req.body.id).select('-contraseña');
//     // El método .select('-contraseña') asegura que la contraseña NO se incluya en la respuesta, haciendo ese campo "privado".
//     if (!perfil) {
//       return res.status(404).send('Perfil no encontrado');
//     }
//     res.send(perfil);
//   } catch (error) {
//     res.status(500).send('Error al obtener el perfil');
//   }
// });

// // ENCRIPTACION
// const bcrypt = require('bcrypt');

// // Durante el registro o actualización de contraseña
// perfilSchema.pre('save', async function (next) {
//   if (!this.isModified('contraseña')) return next();
//   this.contraseña = await bcrypt.hash(this.contraseña, 12);
//   next();
// });