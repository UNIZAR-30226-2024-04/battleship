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

const io = socketIO(info['serverAddress']); // Puerto del backend en local



export function Home() {

    const cookies = new Cookies();
    const { setSocket } = useSocket();
    const navigate = useNavigate();

    // Obtener el token y nombreId del usuario
    const tokenCookie = cookies.get('JWT');
    const nombreIdCookie = cookies.get('perfil')['nombreId'];
    
    let [bioma2play, setBioma2play] = useState('Mediterraneo'); // Estado para almacenar el bioma seleccionado
    const [selectedButton, setSelectedButton] = useState(1); // Estado para almacenar el botón seleccionado
    const [hoveredMessage, setHoveredMessage] = useState('');

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

    const handleButtonClick = (buttonNumber) => {
        setSelectedButton(buttonNumber);
        const bioma2playAux = buttonNumber === 1 ? 'Mediterraneo' : buttonNumber === 2 ? 'Cantabrico' : buttonNumber === 3 ? 'Norte' : 'Bermudas';
        setBioma2play(bioma2playAux);
        cookies.set('bioma', bioma2play, {path: '/'});
        console.log('bioma2play:', bioma2play);
    };

    const handleMouseEnter = (message) => {
        setHoveredMessage(message);
    };
    
    const handleMouseLeave = () => {
        setHoveredMessage(null);
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
                       
                        <div>
      <div className="button-bioma-container">
        <label
          className={`tor-button-bioma ${selectedButton === 1 ? 'selected' : ''} ${hoveredMessage === 1 ? 'hovered' : ''}`}
          onMouseEnter={() => handleMouseEnter(1)}
          onMouseLeave={handleMouseLeave}
        >
          <input type="radio" name="options" checked={selectedButton === 1} onChange={() => handleButtonClick(1)} />
          <span> Mediterráneo </span>
        </label>
        <label
          className={`tor-button-bioma ${selectedButton === 2 ? 'selected' : ''} ${hoveredMessage === 2 ? 'hovered' : ''}`}
          onMouseEnter={() => handleMouseEnter(2)}
          onMouseLeave={handleMouseLeave}
        >
          <input type="radio" name="options" checked={selectedButton === 2} onChange={() => handleButtonClick(2)} />
          <span> Cantábrico </span>
        </label>
        <label
          className={`tor-button-bioma ${selectedButton === 3 ? 'selected' : ''} ${hoveredMessage === 3 ? 'hovered' : ''}`}
          onMouseEnter={() => handleMouseEnter(3)}
          onMouseLeave={handleMouseLeave}
        >
          <input type="radio" name="options" checked={selectedButton === 3} onChange={() => handleButtonClick(3)} />
          <span> Norte </span>
        </label>
        <label
          className={`tor-button-bioma ${selectedButton === 4 ? 'selected' : ''} ${hoveredMessage === 4 ? 'hovered' : ''}`}
          onMouseEnter={() => handleMouseEnter(4)}
          onMouseLeave={handleMouseLeave}
        >
          <input type="radio" name="options" checked={selectedButton === 4} onChange={() => handleButtonClick(4)} />
          <span> Bermudas </span>
        </label>
      </div>
      <div className="hovered-message">{hoveredMessage ? `¡El bioma ${hoveredMessage === 1 ? 'Mediterráneo se caracteriza por pocos cambios de clima!' :
                                         hoveredMessage === 2 ? 'Cantábrico cambiará el clima de tus partidas frecuentemente!' :
                                         hoveredMessage === 3 ? 'Norte supondrá un reto con cambios de clima casi constantes!' :
                                          'Bermudas te impedirá usar cualquiera de tus habilidades!'}` : ''}</div>
    </div>
    <div><br></br></div>

    

                        <button className="home-button" onClick={
                            // Crear sala de juego y navegar a game tras recibir respuesta del socket
                            () => {
                                handleOnClickPartidaMulti();
                            }
                        }>
                            <span> Jugar Online</span>
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