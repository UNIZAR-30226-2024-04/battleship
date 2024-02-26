const app = require('./app')
const mongoose = require('mongoose'); // Asegúrate de requerir mongoose
const PORT = process.env.PORT || 8080;

// Inicia el servidor express
const server = app.listen(PORT, () => {
    console.log(`Servidor web en el puerto ${PORT}.`);
});

server.closeAll = () => {
    mongoose.disconnect() // Cierra conexión a MongoDB
    .then(() => {
        console.log('Conexión a MongoDB cerrada');
        server.close(() => { // Cierra servidor web
            console.log('Servidor web cerrado');
        });
    })
    .catch((err) => {
        console.error('Error al cerrar la conexión a MongoDB', err);
    });
}

module.exports = server;
