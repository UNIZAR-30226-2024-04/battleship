import React, { useState, useEffect } from 'react';
import countriesData from '../../Resources/countries.json';
import Flag from 'react-world-flags';
import Cookies from 'universal-cookie';

const urlRoot = 'http://localhost:8080/perfil';
const urlObtenerAmigos = urlRoot + '/obtenerAmigos';
const urlEliminarAmigo = urlRoot + '/eliminarAmigo';


const AmigosMenu = () => {
    const cookies = new Cookies();
    const tokenCookie = cookies.get('JWT');
    const perfilCookie = cookies.get('perfil');


    // Función que obtiene los amigos del usuario loggeado y los muestra en el menú
    const getAmigos = () => {
        fetch(urlObtenerAmigos, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'] })
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor obtenerAmigos:', response);
                throw new Error('Obtener amigos ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor obtenerAmigos:', data);
            mostrarAmigos(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    
    }

    // Función que muestra en el submenú de "Amigos" los amigos del usuario loggeado
    const mostrarAmigos = () => {
        const feed = document.querySelector('.profile-activity-content');
    }

    // Función que borra un amigo de la lista de amigos del usuario loggeado
    const borrarAmigos = () => {
        fetch(urlEliminarAmigo, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'], nombreIdAmigo: "pendiente"})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor eliminarAmigo:', response);
                throw new Error('Eliminar amigo ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor eliminarAmigo:', data);
            mostrarAmigos(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    // Se ejecuta después de que el componente AmigosMenu() se renderice
    useEffect(() => {
        getAmigos();
    }, []);

    return (
        <>
            <div className="profile-sidebar-friends-container">
                <div className="profile-sidebar-friend-info">
                    <div className="profile-sidebar-friend-img">
                    </div>
                    <div className="profile-sidebar-friend-name">
                        <span>Snatilla</span>
                    </div>
                    <div className="profile-sidebar-friend-flag">
                        <Flag code={ "FR" } height="15em" fallback={ <span>Nada</span> }/>
                    </div>
                    <button onClick={() => borrarAmigos}>Borrar</button>
                </div>
                <div className="profile-sidebar-friend-info">
                    <div className="profile-sidebar-friend-img">
                    </div>
                    <div className="profile-sidebar-friend-name">
                        <span>Dlad</span>
                    </div>
                    <div className="profile-sidebar-friend-flag">
                        <Flag code={ "USA" } height="15em" fallback={ <span>Nada</span> }/>
                    </div>
                    <button onClick={() => borrarAmigos}>Borrar</button>
                </div>
                <div className="profile-sidebar-friend-info">
                    <div className="profile-sidebar-friend-img">
                    </div>
                    <div className="profile-sidebar-friend-name">
                        <span>MT</span>
                    </div>
                    <div className="profile-sidebar-friend-flag">
                        <Flag code={ "CAN" } height="15em" fallback={ <span>Nada</span> }/>
                    </div>
                    <button onClick={() => borrarAmigos}>Borrar</button>
                </div>
            </div>
        </>
    )
}

export default AmigosMenu;