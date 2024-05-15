
const PartidaMultiController = require('./partidaMultiController');


// Función interna que comprueba si un jugador puede unirse a un torneo
async function puedeUnirseTorneo(torneo, nombreId) {
    // Comprobar si el usuario puede jugar en el torneo
    const torneoEncontrado = await Torneo.findOne({codigo: torneo});
    if (!torneoEncontrado) {
        console.log('No se encontró el torneo');
        return false;
    }
    // Comprobar que el usuario no ha ganado el torneo
    if (torneoEncontrado.ganadores.find(ganador => ganador.nombreId === nombreId)) {
        console.log('El usuario ya ha ganado el torneo');
        return false;
    }
    // Comprobar que el usuario no ha perdido el torneo
    const participante = torneoEncontrado.participantes.find(participante => participante.nombreId === nombreId);
    if (participante && participante.derrotas >= torneoEncontrado.numeroMaxDerrotas) {
        console.log('El usuario ha perdido el torneo');
        return false;
    }
    return true;
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
        const { nombreId, bioma = 'Mediterraneo', torneo = false, ...extraParam } = req.body;
        // Comprobar si el usuario puede jugar en el torneo
        if(await puedeUnirseTorneo(torneo, nombreId)){
            PartidaMultiController.crearSala({ body : {nombreId, bioma, torneo}}, res);
        }
        else {
            res.status(500).send('El usuario no puede unirse al torneo');
            console.log('El usuario no puede unirse al torneo');
            return;
        }        
    } 
    catch (error) {
      res.status(500).send('Hubo un error creando la sala'+ error.message);
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
            PartidaMultiController.buscarSala({ body : {nombreId, torneo}}, res);
        }
        else {
            res.status(500).send('El usuario no puede unirse al torneo');
            console.log('El usuario no puede unirse al torneo');
            return;
        }
    }
    catch (error) {
      console.error('Hubo un error buscando la sala de torneo', error);
    }
  };


  // El resto de funciones no deberían variar respecto a las de partidaMultiController.js
