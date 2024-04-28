const { Server } = require("socket.io");
let io = null;
const hostSocket = 'http://localhost:8080';

// Define los eventos de socket que se pueden emitir y escuchar
// Los enviamos junto con el codigo de la partida
const eventosSocket = {
    partidaEncontrada: 'partidaEncontrada', // Se emite cuando se encuentra una sala para jugar partida
                                            // Se escucha cuando se encuentra una sala para jugar partida

    continuaTurno: 'continuaTurno',         // Se emite cuando un jugador acierta el disparo
                                            // Se escucha despues de emitir turnoRecibido

    turnoRecibido: 'turnoRecibido',         // Se emite cuando se recibe el continua Turno o finTurnos
                                            // Se escucha despues de emitir finTurnos

    finTurnos: 'finTurnos',                 // Se emite cuando termina el jugador falla disparo (o hunde todos los barcos)
                                            // Se escucha cuando se recibe turnoRecibido

    abandono: 'abandono',                   // Se emite cuando un jugador abandona la partida
                                            // Se escucha al iniciar la partida en un hilo aparte

    chat: 'chat',                           // Se emite cuando un jugador envía un mensaje
                                            // Se escucha continuamente para mostrar los mensajes en el chat
};


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

        socket.on(eventosSocket.partidaEncontrada, (codigo) => {
            console.log('Partida encontrada recibido en backend:', codigo);
            socket.join(`/partida${codigo}`);
            // Aquí puedes emitir eventos a todos los sockets conectados con mismo namespace
            io.to(`/partida${codigo}`).emit(partidaEncontrada, codigo);
        });

        socket.on(eventosSocket.disparoRecibido, (codigo) => {
            console.log('Disparo recibido en backend:', codigo);
            io.to(`/partida${codigo['codigo']}`).emit(disparoRecibido, codigo);
        });

        socket.on(eventosSocket.turnoJugador, (codigo) => {
            console.log('Turno jugador recibido en backend:', codigo);
            io.to(`/partida${codigo}`).emit(turnoJugador, codigo);
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

module.exports = { initializeSocket, getIO, eventosSocket };