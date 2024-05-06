import { Navbar } from "../Components/Navbar";
import '../Styles/home-style.css';
import GameDemoImg from '../Images/home-game-demo.png';
import { useNavigate } from 'react-router-dom';
import Cookies from "universal-cookie";
import socketIO from 'socket.io-client';
import { useSocket } from '../Contexts/SocketContext';
import info from '../Resources/info';

const crearSalaURI = info['serverAddress'] +'/partidaMulti/crearSala';
const buscarSalaURI = info['serverAddress']+'/partidaMulti/buscarSala';

const cookies = new Cookies();
const io = socketIO(info['serverAddress']); // Puerto del backend en local



export function Home() {

    const { setSocket } = useSocket();
    const navigate = useNavigate();

    // Obtener el token y nombreId del usuario
    const tokenCookie = cookies.get('JWT');
    const nombreIdCookie = cookies.get('perfil')['nombreId'];

    const handleOnClickPartidaMulti = async () => {
        try {
            const response = await fetch(buscarSalaURI, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'authorization': tokenCookie
                },
                body: JSON.stringify({nombreId: nombreIdCookie}),
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
                body: JSON.stringify({nombreId: nombreIdCookie}),
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