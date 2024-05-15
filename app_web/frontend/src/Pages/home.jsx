import { Navbar } from "../Components/Navbar";
import '../Styles/home-style.css';
import GameDemoImg from '../Images/home-game-demo.png';
import { useNavigate } from 'react-router-dom';
import Cookies from "universal-cookie";
import socketIO from 'socket.io-client';
import { useSocket } from '../Contexts/SocketContext';
import info from '../Resources/info';
import { useState } from 'react'; // Importa useState para manejar el estado de la variable global

const crearSalaURI = info['serverAddress'] + 'partidaMulti/crearSala';
const buscarSalaURI = info['serverAddress'] + 'partidaMulti/buscarSala';

const cookies = new Cookies();
const io = socketIO(info['serverAddress']); // Puerto del backend en local



export function Home() {

    const { setSocket } = useSocket();
    const navigate = useNavigate();

    // Obtener el token y nombreId del usuario
    const tokenCookie = cookies.get('JWT');
    const nombreIdCookie = cookies.get('perfil')['nombreId'];
    var bioma2play = 'Mediterraneo';
    const [selectedButton, setSelectedButton] = useState(null); // Estado para almacenar el botón seleccionado

    const handleOnClickPartidaMulti = async () => {
        try {
            const response = await fetch(buscarSalaURI, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'authorization': tokenCookie
                },
                body: JSON.stringify({nombreId: nombreIdCookie, bioma: bioma2play}),
            });
    
            if (!response.ok) {
                console.error("Respuesta backend:", response);
                throw new Error(`HTTP error! status: ${response.status}`);
            }
    
            const responseData = await response.json();
            console.log('Respuesta del servidor:', responseData);

            if (responseData['codigo'] == -1) {
                // No existe sala, crear una
                CrearSala();
                cookies.remove('jugador', { path: '/' });
                cookies.set('jugador', 1, { path: '/' });
            } else if (responseData['codigo']) { // Nos devuelve el código de la sala    
                // Conectar al socket de la sala
                const salaSocket = io.connect(`/partida${responseData['codigo']}`);
                console.log('partidaEncontrada en sala:', responseData['codigo']);
                salaSocket.emit(info['entrarSala'], responseData['codigo']);
                // esperar unos milisegundos para que el servidor pueda procesar el evento
                cookies.remove('jugador', { path: '/' });
                cookies.set('jugador', 2, { path: '/' });
                navigate('/gameMulti');
            }
        }
        catch (error) {
            console.error('Error en el al buscar Sala', error);
        }
    };
    
    const CrearSala = async () => {
        try {
            const response = await fetch(crearSalaURI, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'authorization': tokenCookie
                },
                body: JSON.stringify({nombreId: nombreIdCookie, bioma: bioma2play}),
            });
    
            if (!response.ok) {
                console.error("Respuesta backend:", response);
                throw new Error(`HTTP error! status: ${response.status}`);
            }
    
            const responseData = await response.json();
            console.log('Respuesta del servidor:', responseData);
    
            // Conectar al socket de la sala
            const salaSocket = io.connect(`/partida${responseData['codigo']}`);
            salaSocket.emit(info['entrarSala'], responseData['codigo']);
            console.log('sala creada en:', responseData['codigo']);
            // Escuchar evento de partida encontrada
            salaSocket.on(info['partidaEncontrada'], (codigo) => {
                console.log('Partida encontrada en:', codigo);
                navigate('/gameMulti');
            });
        }
        catch (error) {
            console.error('Error en el al crear Sala', error);
        }
    };

    const handleButtonClick = (value) => {
        setSelectedButton(value === selectedButton ? null : value); // Cambia el estado del botón seleccionado
        bioma2play = value === 1 ? 'Mediterraneo' : value === 2 ? 'Cantabrico' : value === 3 ? 'Norte' : 'Bermudas';
    };
    
    return (
        <div className="home-page-container">
            <Navbar/>
            <div className="home-container">
                <div className="home-main-content-container">
                    <div className="home-main-img-container">
                        <img src={ GameDemoImg } />
                    </div>
                    <div className="home-main-content">
                        <h1 className="home-banner-container">
                            Juega a Hundir la Flota
                        </h1>
                        <input type="text" placeholder="Nombre de torneo" />
                        <div><br></br></div>
                        <button className="tor-button" onClick={() => {
                            // Mostrar el texto introducido en la consola
                            console.log('Texto introducido:', document.querySelector('input').value);

                        }}>
                            <span>Buscar torneo</span>
                        </button>
                        <div><br></br></div>
                        <button className={`tor-button ${selectedButton === 1 ? 'selected' : ''}`} onClick={() => handleButtonClick(1)}>
                            <span> Mediterráneo </span>
                        </button>
                        <button className={`tor-button ${selectedButton === 2 ? 'selected' : ''}`} onClick={() => handleButtonClick(2)}>
                            <span> Cantábrico </span>
                        </button>
                        <button className={`tor-button ${selectedButton === 3 ? 'selected' : ''}`} onClick={() => handleButtonClick(3)}>
                            <span> Norte </span>
                        </button>
                        <button className={`tor-button ${selectedButton === 4 ? 'selected' : ''}`} onClick={() => handleButtonClick(4)}>
                            <span> Bermudas </span>
                        </button>
                        <button className="home-button" onClick={
                            // Crear sala de juego y navegar a game tras recibir respuesta del socket
                            () => {
                                handleOnClickPartidaMulti();
                            }
                        }>
                            <span> Jugar Online </span>
                        </button>
                        
                        <button className="home-button" onClick={() => navigate('/game')}>
                            <span> Jugar Offline </span>
                        </button>
                    </div>
                </div>
                <div className="home-secondary-content-container">

                </div>
            </div>
        </div>
    );
}