const app = require('./app')

const { Server } = require('socket.io');
const mongoose = require('mongoose'); // Asegúrate de requerir mongoose
const PORT = 8080;


// Inicia el servidor express
const server = app.listen(PORT, () => {
    console.log(`Servidor web en el puerto ${PORT}.`);
});

// Adjunta socket.io al servidor HTTP
const io = new Server(server, {
    cors: {
      origin: "*", // Configura CORS según tus necesidades
      methods: ['GET', 'POST', 'PUT', 'DELETE'], // Métodos permitidos
      credentials: true // Permite cookies de origen cruzado
    }
  });

io.on('connection', (socket) => {
    console.log('Usuario conectado en socket server');
    socket.on('disconnect', () => {
    console.log('Usuario desconectado de la partida');
    });
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

module.exports = {server, io}; // Exporta server e io para poder usarlos en otros archivos