import React, { useState, useEffect } from 'react';
import Cookies from 'universal-cookie';

const urlRoot = 'http://localhost:8080/perfil/';
const urlObtenerSolicitudes = urlRoot + 'obtenerSolicitudesAmistad';
const urlEnviarSolicitud = urlRoot + 'enviarSolicitudAmistad';
const urlEliminarSolicitud = urlRoot + 'eliminarSolicitudAmistad';
const urlAgnadirAmigo = urlRoot + 'agnadirAmigo';


const SolicitudesMenu = () => {
    const [nombreAmigo, setNombreAmigo] = useState('');

    const cookies = new Cookies();
    const tokenCookie = cookies.get('JWT');
    const perfilCookie = cookies.get('perfil');

    // Función que muestra en el submenú de "Amigos" los amigos del usuario loggeado
    const mostrarAmigos = () => {
        const feed = document.querySelector('.profile-activity-content');
    }

    // Función que obtiene los amigos del usuario loggeado y los muestra en el menú
    const getSolicitudes = () => {
        fetch(urlObtenerSolicitudes, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'] })
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor obtenerSolicitudes:', response);
                throw new Error('Obtener solicitudes ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor obtenerSolicitudes:', data);
            mostrarAmigos(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    // Función que se ejecuta tras aceptar las solicitudes de amistad
    const agnadirAmigo = () => {
        fetch(urlAgnadirAmigo, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'], nombreIdAmigo: "pendiente"})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor agnadirAmigo:', response);
                throw new Error('Agnadir amigo ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor agnadirAmigo:', data);
            mostrarAmigos(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    // Función que se ejecuta tras aceptar las solicitudes de amistad
    const eliminarSolicitudAmistad = () => {
        fetch(urlEliminarSolicitud, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'], nombreIdAmigo: "pendiente"})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor eliminarSolicitudAmistad:', response);
                throw new Error('Eliminar solicitud de amistad ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor eliminarSolicitudAmistad:', data);
            mostrarAmigos(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }
    
    // Función que actualiza el nombre del amigo al que vamos a enviar solicitud de amistad
    const handleInputChange = (event) => {
        setNombreAmigo(event.target.value);
    };

    // Función que envía una solicitud de amistad a "nombreAmigo"
    const handleEnviarSolicitud = () => {
        fetch(urlEnviarSolicitud, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'], nombreIdAmigo: nombreAmigo})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor obtenerSolicitudes:', response);
                throw new Error('Obtener solicitudes ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor obtenerSolicitudes:', data);
            mostrarAmigos(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    // Se ejecuta después de que el componente SolicitudesMenu() se renderice
    useEffect(() => {
        getSolicitudes();
    }, []);

    return (
        <>
            <span>Nombre amigo:</span>
            <input
                className='campoNombreAmigo'
                type="text"
                value={nombreAmigo}
                onChange={handleInputChange}
            />
            <button onClick={() => handleEnviarSolicitud()}>Enviar solicitud</button>
            <div className='relleno'></div>
            <span>Solicitudes recibidas:</span>
            <div className='relleno'></div>
            <span>Mis Amigos:</span>
            <div className="settings-profile-header">
                <div className="settings-profile-img">
                    <span>img</span>
                </div>
                <div className="settings-profile-name">
                    <span>amigo</span>
                </div>
            </div>
        </>
    )
}

export default SolicitudesMenu;