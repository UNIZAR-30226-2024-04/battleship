// src/contexts/SocketContext.js
import React, { createContext, useContext, useState, useEffect } from 'react';
import io from 'socket.io-client';

const SocketContext = createContext();

export const SocketProvider = ({ children }) => {
    const [socket, setSocket] = useState(null);

    // Conectar y desconectar el socket de forma efectiva
    useEffect(() => {
        // Desconectar el socket cuando el componente se desmonta
        return () => {
            if (socket) {
                socket.disconnect();
            }
        };
    }, [socket]);

    return (
        <SocketContext.Provider value={{ socket, setSocket }}>
            {children}
        </SocketContext.Provider>
    );
};

// Hook personalizado para usar el contexto fácilmente
export const useSocket = () => useContext(SocketContext);