import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import UserContainerTemplate from '../../Components/UserContainerTemplate';
import Cookies from 'universal-cookie';
import info from '../../Resources/info';

const urlObtenerAmigos = info["serverAddress"] + 'perfil/obtenerAmigos';
const urlEliminarAmigo = info["serverAddress"] + 'perfil/eliminarAmigo';

const AmigosMenu = () => {
    const [friendsList, setFriendsList] = useState([]);
    const navigate = useNavigate();
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
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'], nombreIdAmigo: friendName })
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

    // Función que navega al perfil del amigo
    const viewProfile = (friendName) => {
        // Nuevas cookies para almacenar el nombreId del amigo
        cookies.set('perfilAmigo', { nombreId: friendName }, { path: '/' });
        navigate(`/profile/${friendName}`);
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
                        <UserContainerTemplate 
                            key={nombreAmigo}
                            imageSrc={null}    
                            name={nombreAmigo}
                            buttons={[
                                { text: "Eliminar Amigo", onClick: () => removeFriend(nombreAmigo) },
                                { text: "Ver Perfil", onClick: () => viewProfile(nombreAmigo) }
                            ]}
                        />
                    ))}
                </div>
            </div>
        </>
    );
}

export default AmigosMenu;