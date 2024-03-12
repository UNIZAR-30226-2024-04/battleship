const Perfil = require('../models/perfilModel');
const bcrypt = require('bcrypt'); // Para hash de constraseña
const jwt = require('jsonwebtoken'); // Para generar tokens JWT
const crypto = require('crypto'); // Para generar claves secretas

// Crear un perfil
exports.crearPerfil = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, contraseña, correo } = req.body;
    
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId || !contraseña || !correo) {
      res.status(400).json({ error: 'Falta el nombre del perfil, la contraseña y/o el correo' });
      console.error("Falta el nombre del perfil, la contraseña y/o el correo");
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
      res.status(400).send('El correo no es válido');
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

    // Crear un tablero aleatorio con un barco de 5 casillas de largo 
    const tableroInicial = [[[1, 1, false ], [1, 2, false], false ] 
                            [[7, 1, false ], [8, 1, false],[9, 1, false], false ]   
                            [[3, 10, false ], [4, 10, false],[5, 10, false], false ]
                            [[4, 4, false ], [5, 5, false],[6, 6, false], [7, 7, false], false ]
                            [[10, 6, false ], [10, 7, false],[10, 8, false], [10, 9, false], [10, 10, false], false ]
           ];
      
    
    // Creación del perfil en la base de datos
    const nuevoPerfil = new Perfil({
      nombreId,
      hashContraseña,
      correo,
      tableroInicial
    });

    // Guardar el perfil en la base de datos
    const perfilGuardado = await nuevoPerfil.save();
    // Enviar la respuesta al cliente
    res.json(perfilGuardado);
    console.log("Perfil creado con éxito", doc);
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
    const { nombreId, nuevaContraseña, nuevoCorreo } = req.body;
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).json({ error: 'Falta el nombre del perfil en la solicitud' });
      console.error("Falta el nombre del perfil en la solicitud");
      return;
    }
    // Comprobar que la contraseña cumple con los requisitos
    if (nuevaContraseña && !verificarContraseña(nuevaContraseña)) {
      res.status(400).send('La contraseña debe tener al menos 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial');
      console.error("La contraseña debe tener al menos 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial");
      return;
    }
    // Comprobar que el correo es válido
    if (nuevoCorreo && !verificarCorreo(nuevoCorreo)) {
      res.status(400).send('El correo no es válido');
      console.error("El correo no es válido");
      return;
    }
    // Generar hash de la contraseña si se proporciona
    let hashContraseña; // valor undefined (si no se le da valor, no se tendrá en cuenta en el $set)
    if (nuevaContraseña) {
      hashContraseña = await bcrypt.hash(nuevaContraseña, 10); // 10 es el número de saltos de hashing
    }
    // Buscar y actualizar el perfil en la base de datos
    const perfilModificado = await Perfil.findOneAndUpdate(
      { nombreId: nombreId }, // Filtro para encontrar el perfil a modificar
      {
        $set: {
          contraseña: hashContraseña,
          correo: nuevoCorreo
        }
      },
      { new: true } // Para devolver el documento actualizado
    );

    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfilModificado) {
      res.json(perfilModificado);
      console.log("Perfil modificado con éxito", perfilModificado);
    } else {
      res.status(404).send('Perfil no modificado');
      console.error("Perfil no modificado");
    }

  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al modificar el perfil", error);
  }
};

// Modificar mazo y tablero de un perfil
exports.modificarPerfilMazoOTablero = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, tableroInicial, mazoHabilidadesElegidas } = req.body;
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).json({ error: 'Falta el nombre del perfil en la solicitud' });
      console.error("Falta el nombre del perfil en la solicitud");
      return;
    }
    // Buscar y actualizar el perfil en la base de datos
    const perfilModificado = await Perfil.findOneAndUpdate(
      { nombreId: nombreId }, // Filtro para encontrar el perfil a modificar
      {
        $set: {
          tableroInicial: tableroInicial,
          mazoHabilidadesElegidas: mazoHabilidadesElegidas,
        }
      },
      { new: true } // Para devolver el documento actualizado
    );

    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfilModificado) {
      res.json(perfilModificado);
      console.log("Perfil modificado con éxito", perfilModificado);
    } else {
      res.status(404).send('Perfil no modificado');
      console.error("Perfil no modificado");
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al modificar el perfil", error);
  }
};

// Modificar estadisticas de un perfil
exports.actualizarEstadisticas = async (req, res) => {
  try {
    // Extracción de parámetros del cuerpo de la solicitud
    const { nombreId, resultado, nuevosBarcosHundidos, nuevosBarcosAliadosHundidos, nuevosDisparosAcertados, nuevosDisparosFallidos } = req.body;

    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).json({ error: 'Falta el nombre del perfil en la solicitud' });
      console.error("Falta el nombre del perfil en la solicitud");
      return;
    }
    // Buscar y actualizar el perfil en la base de datos
    const perfilModificado = await Perfil.findOneAndUpdate(
      { nombreId: nombreId }, // Filtro para encontrar el perfil a modificar
      {
        $set: {
          partidasJugadas : partidasJugadas + 1,
          partidasGanadas : resultado ? partidasGanadas + 1 : partidasGanadas,
          barcosEnemigosHundidos : barcosEnemigosHundidos + nuevosBarcosHundidos,
          barcosAliadosPerdidos : barcosAliadosPerdidos + nuevosBarcosAliadosHundidos,
          disparosAcertados : disparosAcertados + nuevosDisparosAcertados,
          disparosFallidos : disparosFallidos + nuevosDisparosFallidos
        }
      },
      { new: true } // Para devolver el documento actualizado
    );
    // Verificar si el perfil existe y enviar la respuesta al cliente
    if (perfilModificado) {
      res.json(perfilModificado);
      console.log("Perfil modificado con éxito", perfilModificado);
    } else {
      res.status(404).send('Perfil no actualizado');
      console.error("Perfil no actualizado");
    }

  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al modificar el perfil", error);
  }
};


// Funcion para comprobar que un parametro es un correo electronico
function verificarCorreo(correo) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(correo);
}

// Funcion para verificar que la contraseña cumple con los requisitos: 8 caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial
function verificarContraseña(contraseña) {
  const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}$/;
  return regex.test(contraseña);
}

// Funcion para comprobar que un dato es un numero
function esNumero(numero) {
  return !isNaN(numero);
}

// Funcion para comprobar que nombreID tiene longtud mayor que 5
function verificarNombreId(nombreId) {
  return nombreId.length > 5;
}

// Obtener un perfil
exports.obtenerPerfil = async (req, res) => {
  try {
    // Extraer el nombreId del parámetro de la solicitud
    const { nombreId } = req.body;
    // Verificar si alguno de los parámetros está ausente
    if (!nombreId) {
      res.status(400).json({ error: 'Falta el nombre del perfil en la solicitud' });
      console.error("Falta el nombre del perfil en la solicitud");
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
      res.status(404).send('Perfil no encontrado');
      console.error("Perfil no encontrado");
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
    const { nombreId } = req.body;
    // Comprobar si el nombreId está presente en la solicitud
    if (!nombreId) {
      res.status(400).json({ error: 'Falta el nombre del perfil en la solicitud' });
      console.error("Falta el nombre del perfil en la solicitud");
      return;
    }
    // Buscar y eliminar el perfil de la base de datos
    const resultado = await Perfil.deleteOne({ nombreId: nombreId });
    // Verificar si se eliminó el perfil y enviar la respuesta al cliente
    if (resultado.deletedCount > 0) {
      res.json({ mensaje: 'Perfil eliminado correctamente' });
      console.log("Perfil eliminado correctamente");
    } else {
      res.status(404).send('Perfil no eliminado');
      console.error("Perfil no eliminado");
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
    const { contraseña } = req.body;
    // Buscar el perfil en la base de datos
    const perfil = await obtenerPerfil(req, res);
    if (perfil) {
      // Verificar la contraseña
      const contraseñaValida = await bcrypt.compare(contraseña, perfil.contraseña);
      if (!contraseñaValida) {
        res.status(404).json({ error: 'La contraseña no es válida' });
        console.error("La contraseña no es válida");
        return;
      }
      res.json(perfil);
      console.log("Perfil autenticado con éxito", perfil);
      return perfil;
    }
  } catch (error) {
    res.status(500).send('Hubo un error');
    console.error("Error al autenticar al usuario", error);
    return;
  }
};

// Iniciar sesión
exports.iniciarSesion = async (req, res) => { // Requiere nombreId y contraseña
  try {
    // Buscar el perfil en la base de datos
    const perfil = await autenticarUsuario(req, res);
    if (perfil) {
      // Generar bytes aleatorios para la clave privada
      const clavePrivadaBuffer = crypto.randomBytes(32);
      const clavePrivada = clavePrivadaBuffer.toString('hex');
      // Si el nombre de usuario y la contraseña son válidos, generar un token JWT
      const token = jwt.sign(perfil.toJSON(), clavePrivada);
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
    const perfil = await crearPerfil(req, res);
    if (perfil) {
      await iniciarSesion(req, res);
      console.log("Usuario registrado con éxito");
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