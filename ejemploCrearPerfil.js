const mongoose = require('mongoose');

// Conexión a la base de datos
mongoose.connect('mongodb://localhost/BattleshipDB', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Conectado a MongoDB...'))
  .catch(err => console.error('No se pudo conectar a MongoDB...', err));

const Perfil = require('./models/perfilModel'); // Asegúrate de usar la ruta correcta al archivo de modelo

const nuevoPerfil = new Perfil({
  nombreId: "Usuario123",
  contraseña: "ContraseñaSegura",
  correo: "correo@ejemplo.com",
  // Puedes añadir los demás campos según necesites
});

nuevoPerfil.save()
  .then(doc => {
    console.log("Perfil creado con éxito", doc);
  })
  .catch(err => {
    console.error("Error al crear el perfil", err);
  });


