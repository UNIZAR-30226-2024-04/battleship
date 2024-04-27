const app = require('./app')
const socketIo = require('socket.io');
const mongoose = require('mongoose'); // Asegúrate de requerir mongoose
const PORT = 8080;


// Inicia el servidor express
const server = app.listen(PORT, () => {
    console.log(`Servidor web en el puerto ${PORT}.`);
});

// Adjunta socket.io al servidor HTTP
const io = socketIo(server, {
    cors: {
      origin: "*", // Configura CORS según tus necesidades
      methods: ['GET', 'POST', 'PUT', 'DELETE'], // Métodos permitidos
      credentials: true // Permite cookies de origen cruzado
    }
  });

app.io = io; // Adjunta socket.io a la aplicación express

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