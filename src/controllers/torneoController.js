const PartidaMultiController = require('./partidaMultiController');
const Torneo = require('../models/torneoModel');   // Importar el modelo de torneo

// Función interna que comprueba si un jugador puede unirse a un torneo
async function puedeUnirseTorneo(torneo, nombreId) {
    // Comprobar si el usuario puede jugar en el torneo
    var torneoEncontrado = await Torneo.findOne({codigo: torneo});
    if (!torneoEncontrado) {
        return false;
    }
    // Comprobar que el usuario no ha ganado el torneo
    torneoEncontrado = await Torneo.findOne(
        {codigo: torneo}, 
        {ganadores: {$elemMatch: {nombreId: nombreId}}});
    if (torneoEncontrado.ganadores.length > 0) {
        return false;
    }
    // Comprobar que el usuario está en la lista de participantes y que sus derrotas no superan el límite
    torneoEncontrado = await Torneo.findOne(
        {codigo: torneo}, 
        {participantes: {$elemMatch: {nombreId: nombreId}, derrotas: {$gte: torneoEncontrado.numeroMaxDerrotas}}
    });
    if (torneoEncontrado.participantes.length > 0) {
        return false;
    }
    return true;
}

/**
 * @function comprobarTorneo
 * @description Comprueba si un jugador puede unirse a un torneo
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} req.body.nombreId - El nombreId del jugador
 * @param {String} req.body.torneo - El código del torneo que quiere unirse
 * @param {Object} res - El objeto de respuesta HTTP con el resultado de la comprobación
 * @param {Boolean} res.existe - Indica si el torneo existe
 * @param {Boolean} res.puedeUnirse - Indica si el jugador puede unirse al torneo
 * @param {Boolean} res.haGanado - Indica si el jugador ha ganado el torneo
 */
exports.comprobarTorneo = async (req, res) => {
    try {
        const { nombreId, torneo, ...extraParam } = req.body;
        const torneoEncontrado = await Torneo.findOne({codigo: torneo});
        if (!torneoEncontrado) {
            res.json({existe: false, puedeUnirse: false, haGanado: false});
            console.log('No se encontró el torneo');
            return;
        }
        const puedeUnirse = await puedeUnirseTorneo(torneo, nombreId);
        if (!puedeUnirse) {
            var torneoGanado = await Torneo.findOne(
                {codigo: torneo}, 
                {ganadores: {$elemMatch: {nombreId: nombreId}}});
            if (torneoGanado.ganadores.length > 0) {
                res.json({existe: true, puedeUnirse: false, haGanado: true});
                console.log('El usuario ya ha ganado el torneo');
            } else {
                res.json({existe: true, puedeUnirse: false, haGanado: false});
                console.log('El usuario ya ha perdido el torneo');
            }
        } else {
            res.json({existe: true, puedeUnirse: true, haGanado: false});
            console.log('El usuario puede unirse al torneo');
            return;
        }
    }
    catch (error) {
        console.error('Hubo un error comprobando el torneo', error);
        res.status(500).send('Hubo un error comprobando el torneo');
    }
}


/**
 * @function crearSalaTorneo
 * @description Crea una sala de espera multijugador con un jugadores y un bioma, la guarda en la base de datos y devuelve la partida creada
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} req.body.nombreId - El nombreId del jugador 1
 * @param {BiomasDisponibles} [req.body.bioma] - El bioma de la partida, por defecto 'Mediterraneo'
 * @param {String} req.body.torneo - El código del torneo que quiere unirse
 * @param {Object} res - El objeto despuesta HTTP con el codigo de la partida creada TODO: CAMBIAR ESTO EN BACKEND
 * @param {Number} res.codigo - El código de la partida
 */
exports.crearSalaTorneo = async (req, res) => {
    try {
        const { nombreId, bioma = 'Mediterraneo', torneo, ...extraParam } = req.body;
        // Comprobar si el usuario puede jugar en el torneo
        if(await puedeUnirseTorneo(torneo, nombreId)){
            await PartidaMultiController.crearSala({ body : {nombreId, bioma, torneo}}, res);
        }
        else {
            res.status(400).send('El usuario no puede unirse al torneo');
            console.error('El usuario no puede unirse al torneo');
            return;
        }        
    } 
    catch (error) {
      res.status(500).send('Hubo un error creando la sala '+ error.message);
      console.error('Hubo un error creando la sala', error);
    }
  };



/**
 * @function buscarSalaTorneo
 * @description Permite a un jugador unirse a una sala multijugador ya creada y empezar la partida
 * @param {Object} req - El objeto de solicitud HTTP
 * @param {String} req.body.nombreId - El nombreId del jugador
 * @param {String} req.body.torneo - El código del torneo que quiere unirse
 * @param {Object} res - El objeto de respuesta HTTP con el codigo de la partida creada
 * @param {Number} res.codigo - El código de la partida  (-1 si no se encuentra sala)
 */
exports.buscarSalaTorneo = async (req, res) => {
    try {
        const { nombreId, torneo, ...extraParam } = req.body;
      
        // Comprobar si el usuario puede jugar en el torneo
        if(await puedeUnirseTorneo(torneo, nombreId)){
            // Compruebo si estoy en los participantes del torneo
            const torneoEncontrado = await Torneo.findOne(
                {codigo: torneo}, 
                {participantes: {$elemMatch: {nombreId: nombreId}}});
            // Si no estoy en la lista de participantes me añado
            if (torneoEncontrado.participantes.length === 0) {
                await Torneo.updateOne(
                    {codigo: torneo},
                    {$push: {participantes: {nombreId: nombreId, victorias: 0, derrotas: 0}}}
                );
            }
            await PartidaMultiController.buscarSala({ body : {nombreId, torneo}}, res);
        }
        else {
            res.status(400).send('El usuario no puede unirse al torneo');
            console.log('El usuario no puede unirse al torneo');
            return;
        }
    }
    catch (error) {
      console.error('Hubo un error buscando la sala de torneo', error);
    }
  };


  // El resto de funciones no deberían variar respecto a las de partidaMultiController.js
