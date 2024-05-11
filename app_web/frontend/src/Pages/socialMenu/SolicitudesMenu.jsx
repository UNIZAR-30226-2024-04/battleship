import React, { useState, useEffect } from 'react';
import Cookies from 'universal-cookie';
import UserContainerTemplate from '../../Components/UserContainerTemplate';

const urlRoot = 'http://localhost:8080/perfil/';
const urlObtenerSolicitudes = urlRoot + 'obtenerSolicitudesAmistad';
const urlEnviarSolicitud = urlRoot + 'enviarSolicitudAmistad';
const urlEliminarSolicitud = urlRoot + 'eliminarSolicitudAmistad';
const urlAgnadirAmigo = urlRoot + 'agnadirAmigo';


const SolicitudesMenu = () => {
    // Estado para almacenar el nombre del usuario al que enviar la solicitud
    const [friendName, setFriendName] = useState('');
    const [receivedRequests, setReceivedRequests] = useState([]);
    const [sentRequests, setSentRequests] = useState([]);

    const cookies = new Cookies();
    const tokenCookie = cookies.get('JWT');
    const perfilCookie = cookies.get('perfil');

    // Función que obtiene las peticiones recibidas por el user loggeado y actualiza el estado de estas
    const getRequests = () => {
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
            setReceivedRequests(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    // Función que actualiza el nombre del amigo al que vamos a enviar solicitud de amistad
    const handleInputChange = (event) => {
        setFriendName(event.target.value);
    };


    // Función para agregar una solicitud a la lista de solicitudes enviadas
    const appendRequestToList = (name) => {
        console.log("Añadiendo peticion");
        const newList = [...sentRequests];
        newList.push({ name: name });
        setSentRequests(newList);
    };

    // Función que envía una solicitud de amistad a "friendName"
    const handleSendRequest = (e) => {
        e.preventDefault();
        fetch(urlEnviarSolicitud, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'], nombreIdAmigo: friendName})
        })
        .then(response => {
            console.log('hola');
            if (!response.ok) {
                console.log('Respuesta del servidor enviarSolicitud:', response);
                throw new Error('Enviar solicitud ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor enviarSolicitud:', data);
            appendRequestToList(friendName);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    const removeRequestComponent = (nombreEmisor) => {
        console.log("Borrando la petición de la lista");
        setReceivedRequests(prevRequests => {
            return prevRequests.filter(request => request.key !== nombreEmisor);
          });
    }

    // Función que se ejecuta tras aceptar las solicitudes de amistad
    const acceptRequest = (nombreEmisor) => {
        fetch(urlAgnadirAmigo, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ nombreId: perfilCookie['nombreId'], nombreIdAmigo: nombreEmisor})
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
            removeRequestComponent(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    const removeSentRequest = (data) => {
        console.log("Remove sent request");
    }

    // Función que elimina una solicitud de amistad
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
            removeSentRequest(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    // Se ejecuta después de que el componente SolicitudesMenu() se renderice
    useEffect(() => {
        getRequests();
    }, []);


    return (
        <>
            <form className="social-requests-sending-container social-section-spacing"
                  name="addFriend" method="post" onSubmit={handleSendRequest}
            >
                <span>Añadir amigo:</span>
                <input
                    type="text"
                    size="30"
                    autoComplete='off'
                    name="friendName"
                    placeholder="Introduzca el nombre del usuario..."
                    value={friendName}
                    onChange={handleInputChange}
                    required
                />
                <input type="submit" value="Enviar solicitud de amistad"></input>
            </form>
            <div className='social-requests-received-container social-section-spacing'>
                <span>Solicitudes recibidas:</span>
                <div className='social-requests-received-list'>
                    {receivedRequests.map(nombreEmisor => (
                        <UserContainerTemplate key={nombreEmisor}
                                         imageSrc={null}    
                                         name={nombreEmisor}
                                         clickFunction={null}
                                         buttonText={"Aceptar solicitud"}
                                         buttonFunc={acceptRequest}/>
                    ))}
                </div>
            </div>
            <div className='social-requests-sended-container social-section-spacing'>
                <span>Solicitudes enviadas:</span>
                <div className="social-requests-sent-list">
                    {sentRequests.map(user => (
                        <UserContainerTemplate key={user.name}
                                         imageSrc={null}    
                                         name={user.name}
                                         clickFunction={null}
                                         buttonText={null}
                                         buttonFunc={null}/>
                    ))}
                </div>
            </div>
        </>
    )
}

export default SolicitudesMenu;