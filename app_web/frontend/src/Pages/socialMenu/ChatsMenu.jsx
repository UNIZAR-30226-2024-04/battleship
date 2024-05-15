import React, { useEffect, useState } from 'react';
import ChatContainer from "../../Components/ChatContainer.js";
import Cookies from 'universal-cookie';
import UserContainerTemplate from '../../Components/UserContainerTemplate';

const urlRoot = 'http://localhost:8080/perfil';
const urlObtenerAmigos = urlRoot + '/obtenerAmigos';
const urlEliminarAmigo = urlRoot + '/eliminarAmigo';


const ChatsMenu = () => {
    const [friendsList, setFriendsList] = useState([]);
    const [activeChat, setActiveChat] = useState(null);

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

    // Función que entra al chat con un amigo
    const entrarChat = (friendName) => {
      setActiveChat({
        dirChat: `/chat${perfilCookie['nombreId']}${friendName}`,
        idMiNombre: perfilCookie['nombreId'],
        idSuNombre: friendName
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
                                         buttonText={"Chat"}
                                         buttonFunc={() => entrarChat(nombreAmigo)}/>
                    ))}
                </div>
                {activeChat && (
                <div style={{backgroundColor: "#ece5dd", maxHeight:"100%", padding:10}}>
                    <ChatContainer
                        dirChat={activeChat.dirChat}
                        idMiNombre={activeChat.idMiNombre}
                        idSuNombre={activeChat.idSuNombre}
                    />
                </div>
              )}
            </div>
        </>
    )
}

export default ChatsMenu;