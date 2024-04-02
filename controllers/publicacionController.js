const Publicacion = require('../models/publicacionModel');
const Perfil = require('../models/perfilModel');
const publicacionesPredeterminadas = require('../data/publicaciones')
const reaccionesDisponibles = require('../data/reacciones');


exports.getPublicacionesUsuario  = async (req, res) => { 
  try {
    // Buscar publicaciones del usuario dado
    const publicaciones = await Publicacion.find({usuario: req.params.usuario});
    res.json(publicaciones);
    return publicaciones;
  } catch (error) {
    res.status(500).send
    ({message: error.message});
  }
};

exports.crearPublicacion = async (req, res) => {
  try {
    const perfil = await Perfil.findOne({nombreId: req.body.usuario});
    // Si el usuario no existe, devolvemos un error
    if (!perfil) {
      return res.status(404).send({message: "Usuario no encontrado"});
    }
    const publicacion = new Publicacion({
      publicacionId: req.body.publicacionId,
      usuario: req.body.usuario,
      texto: req.body.texto,
      reacciones: []
    });
    const savedPublicacion = await publicacion.save();
    res.json(savedPublicacion);
  }
  catch (error) {
    res.status(500).send({message: error.message});
  }
};

exports.reaccionarPublicacion = async (req, res) => {
  try {
    const publicacion = await Publicacion.findOne({publicacionId: req.params.publicacionId});
    // Si la publicación no existe, devolvemos un error
    if (!publicacion) {
      return res.status(404).send({message: "Publicación no encontrada"});
    }
    const perfil = await Perfil.findOne({nombreId: req.body.usuario});
    // Si el usuario no existe, devolvemos un error
    if (!perfil) {
      return res.status(404).send({message: "Usuario no encontrado"});
    }
    const reaccion = req.body.reaccion;
    // Si la reacción no es válida, devolvemos un error
    if (!reaccionesDisponibles.includes(reaccion)) {
      return res.status(400).send({message: "Reacción no válida"});
    }
    const reaccionIndex = publicacion.reacciones.findIndex(r => r.usuario === req.body.usuario);
    // Si no existe reaccion por parte del usuario, la añadimos
    if (reaccionIndex === -1) {
      publicacion.reacciones.push({usuario: req.body.usuario, reaccion: reaccion});
    } else {
      publicacion.reacciones[reaccionIndex].reaccion = reaccion;
    }
    // Guardamos la publicación con la nueva reacción
    const savedPublicacion = await publicacion.save();
    res.json(savedPublicacion);
    return savedPublicacion;
  }
  catch (error) {
    res.status(500).send({message: error.message});
  }
};

exports.eliminarPublicacion = async (req, res) => {
  try { 
    const publicacion = await Publicacion.findOne({publicacionId: req.params.publicacionId});
    // Si la publicación no existe, devolvemos un error
    if (!publicacion) {
      return res.status(404).send({message: "Publicación no encontrada"});
    }
    await publicacion.remove();
    res.send({message: "Publicación eliminada"});
  }
  catch (error) {
    res.status(500).send({message: error.message});
  }
};
