const { Server } = require("socket.io");
let io = null;
const hostSocket = 'http://localhost:8080';

// Inicializa el socket con el servidor HTTP
function initializeSocket(server) {
    io = new Server(server, {
        cors: {
            origin: "*",  // Ajusta esto según tus necesidades de CORS
            methods: ["GET", "POST", "PUT", "DELETE"],
            credentials: true
        }
    });

    io.on('connection', socket => {
        console.log('Cliente conectado');

        socket.on('partidaEncontrada', (codigo) => {
            console.log('Partida encontrada recibido en backend:', codigo);
            socket.join(`/partida${codigo}`);
            // Aquí puedes emitir eventos a todos los sockets conectados con mismo namespace
            io.to(`/partida${codigo}`).emit('partidaEncontrada', codigo);
        });

        socket.on('esperandoRival', (codigo) => {
            console.log('Esperando rival recibido en backend:', codigo);
            socket.join(`/partida${codigo}`);
            socket.emit('esperandoRival', codigo);
        });

        socket.on('disconnect', () => {
            console.log('Cliente desconectado');
        });

        // Aquí puedes configurar más eventos de socket globales
    });
}

// Obtiene el objeto io
function getIO() {
    if (!io) {
        throw new Error("Socket.io no ha sido inicializado.");
    }
    return io;
}

module.exports = { initializeSocket, getIO };