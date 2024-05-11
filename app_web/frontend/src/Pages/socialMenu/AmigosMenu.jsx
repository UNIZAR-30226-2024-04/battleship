import React, { useState, useEffect } from 'react';
import UserContainerTemplate from '../../Components/UserContainerTemplate';
import countriesData from '../../Resources/countries.json';
import Flag from 'react-world-flags';
import Cookies from 'universal-cookie';

const urlRoot = 'http://localhost:8080/perfil';
const urlObtenerAmigos = urlRoot + '/obtenerAmigos';
const urlEliminarAmigo = urlRoot + '/eliminarAmigo';


const AmigosMenu = () => {
    const [friendsList, setFriendsList] = useState([]);

    const cookies = new Cookies();
    const tokenCookie = cookies.get('JWT');
    const perfilCookie = cookies.get('perfil');


    // Función que obtiene los amigos del usuario loggeado y los muestra en el menú
    const getFriends = () => {
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
            setFriendsList(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    
    }

    // Función que elimina a "friendName" de la lista de amigos que se muestra
    const removeFriendFromList = (removeFriend) => {
        const newList = friendsList.filter(friend => friend !== removeFriend);
        setFriendsList(newList);
    };

    // Función que borra un amigo de la lista de amigos del usuario loggeado
    const removeFriend = (friendName) => {
        fetch(urlEliminarAmigo, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'], nombreIdAmigo: friendName})
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
            removeFriendFromList(friendName);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    // Se ejecuta después de que el componente AmigosMenu() se renderice
    useEffect(() => {
        getFriends();
    }, []);

    return (
        <>
            <div className='social-friends-container social-section-spacing'>
                <div className='social-friends-list'>                   
                    {friendsList.map(nombreAmigo => (
                        <UserContainerTemplate key={nombreAmigo}
                                         imageSrc={null}    
                                         name={nombreAmigo}
                                         clickFunction={null}
                                         buttonText={"Eliminar Amigo"}
                                         buttonFunc={removeFriend}/>
                    ))}
                </div>
            </div>
        </>
    )
}

export default AmigosMenu;