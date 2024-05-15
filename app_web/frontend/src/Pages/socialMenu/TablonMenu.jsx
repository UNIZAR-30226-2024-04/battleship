import React, { useState, useEffect } from 'react';
import Cookies from 'universal-cookie';
import UserContainerTemplate from '../../Components/UserContainerTemplate';

import info from '../../Resources/info';
const urlServer = info['serverAddress'];
//const urlObtenerPublicaciones = urlServer + '/publicacion/obtenerPublicaciones';
const urlObtenerPublicaciones = 'http://localhost:8080/publicacion/obtenerPublicaciones';

const TablonMenu = () => {
    const [publicaciones, setPublicaciones] = useState([]);
    const cookies = new Cookies();
    const tokenCookie = cookies.get('JWT');
    const perfilCookie = cookies.get('perfil');

    useEffect(() => {
        const obtenerPublicaciones = async () => {
            fetch(urlObtenerPublicaciones, {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json',
                'Authorization': tokenCookie
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
                console.log('Respuesta del servidor obtenerPublicaciones:', data);
                setPublicaciones(data.publicaciones || []); // TO DO, reacciones?
            })
            .catch(error => {
                console.error('Error al obtener las publicaciones:', error);
            });
        };

        obtenerPublicaciones();
    }, []); // El array vacío asegura que este efecto solo se ejecute una vez después del primer montaje

    return (
        <>
            <div className="social-tablon-container">
                <div className="profile-activity-header">
                    <span>ACTIVIDAD RECIENTE</span>
                </div>
                <div className="profile-activity-content">
                    {publicaciones.map((publicacion) => (
                        <div key={publicacion.publicacionId} className="profile-activity-info">
                            <span>{publicacion.texto}</span>
                            <span>Publicado por {publicacion.usuario}</span>
                            {/* Aquí puedes incluir lógica para mostrar reacciones, si necesario */}
                        </div>
                    ))}
                </div>
            </div>
        </>
    );
}

export default TablonMenu;