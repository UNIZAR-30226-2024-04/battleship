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

    const handleOnClickBuscarPartida = async () => {
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
    
            // Conectar al socket de la sala
            const salaSocket = io.connect(`/partida${responseData['codigo']}`);
            setSocket(salaSocket);
            salaSocket.emit('connect', responseData['codigo']);
            salaSocket.emit('partidaEncontrada', responseData['codigo']);
            navigate('/game');
        }
        catch (error) {
            console.error('Error en el al buscar Sala', error);
        }
    };
    
    const handleOnClickCrearSala = async () => {
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
            setSocket(salaSocket);
            salaSocket.emit('connect', responseData['codigo']);
            salaSocket.on('partidaEncontrada', () => {
                navigate('/game');
                console.log('Partida encontrada en salaSocket');
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
                                handleOnClickCrearSala();
                            }
                        }>
                            <span> Jugar Online </span>
                        </button>
                        <button className="home-button" onClick={
                            // Buscar sala de juego y navegar a game
                            () => {
                                handleOnClickBuscarPartida();
                            }                                
                        }>
                            <span> Unirse partida </span>
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