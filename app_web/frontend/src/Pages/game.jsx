import { useEffect, useState } from 'react';
import { Navbar } from "../Components/Navbar";
import { GridStack } from 'gridstack';
import Cookies from "universal-cookie";
import '../Styles/fleet-style.css';
import '../Styles/game-style.css';
import 'gridstack/dist/gridstack.min.css';
import 'gridstack/dist/gridstack-extra.min.css';

import Tablero from '../Resources/Tablero';

import aircraftImg from '../Images/fleet/portaaviones.png';
import destroyImg from '../Images/fleet/destructor.png';
import patrolImg from '../Images/fleet/patrullero.png';
import submarineImg from '../Images/fleet/submarino.png';
import bshipImg from '../Images/fleet/acorazado.png';

import patrolImgRotated from '../Images/fleet/patrullero_rotado.png';
import submarineImgRotated from '../Images/fleet/submarino_rotado.png';
import bshipImgRotated from '../Images/fleet/acorazado_rotado.png';
import aircraftImgRotated from '../Images/fleet/portaaviones_rotado.png';
import destroyImgRotated from '../Images/fleet/destructor_rotado.png';

import mineImg from '../Images/skills/mina.png';
import missileImg from '../Images/skills/misil.png';
import burstImg from '../Images/skills/rafaga.png';
import sonarImg from '../Images/skills/sonar.png';
import torpedoImg from '../Images/skills/torpedo.png';

// Establecer la url de obtenerPerfil, moverBarcoInicial del backend
const urlObtenerDatosPersonales = 'http://localhost:8080/perfil/obtenerDatosPersonales';
const urlMoverBarcoInicial = 'http://localhost:8080/perfil/moverBarcoInicial';
const urlModificarMazoHabilidades = 'http://localhost:8080/perfil/modificarMazo';
const urlCrearPartida = 'http://localhost:8080/partida/crearPartida';
const urlRealizarDisparo = 'http://localhost:8080/partida/realizarDisparo';
const urlMostrarTableros = 'http://localhost:8080/partida/mostrarTableros';

const cookies = new Cookies();


function esBarcoHorizontal(barco) {
    return barco.coordenadas[0].i === barco.coordenadas[1].i;
}

export function Game() {    

    // Obtener el token y nombreId del usuario
    const tokenCookie = cookies.get('JWT');
    const nombreId1Cookie = cookies.get('nombreId');
    

    // Contiene el tamaño y nombre de los barcos a usar
    const shipInfo = {
        'Aircraft': { size: 5, name: "Aircraft", img: aircraftImg, imgRotated: aircraftImgRotated},
        'Bship': { size: 4, name: "Bship", img: bshipImg, imgRotated: bshipImgRotated},
        'Sub': { size: 3, name: "Sub", img: submarineImg, imgRotated: submarineImgRotated},
        'Destroy': { size: 3, name: "Destroy", img: destroyImg, imgRotated: destroyImgRotated},
        'Patrol': { size: 2, name: "Patrol", img: patrolImg, imgRotated: patrolImgRotated},
    };

    // Datos partida
    let idPartida;
    let tablero1;
    let tablero2;
    let disparos1;
    let disparos2;

    // cola fifo para las skills de tamaño 3
    let [skillQueue, setSkillQueue] = useState(["null"]); // Estado para la cola de habilidades

    // Función para agregar una skill a la cola
    const enqueueSkill = (skillName) => {
        if (!skillQueue.includes(skillName)) {
            setSkillQueue(prevQueue => [...prevQueue, skillName]);
            if (skillQueue.length >= 3) {
                setSkillQueue(prevQueue => prevQueue.slice(1)); // Eliminar el primer elemento si la cola excede el límite
            }
        }
    };

    // Función para verificar si una skill está encolada
    const isSkillEnqueued = (skillName) => {
        return skillQueue.includes(skillName);
    };

    // Función para quitar una skill de la cola
    const dequeueSkill = (skillName) => {
        if (skillQueue.includes(skillName)) {
            setSkillQueue(prevQueue => prevQueue.filter(skill => skill !== skillName));
        }
    };

    let [partidaInicializada, setPartidaInicializada] = useState(false); // Estado para saber si la partida ha sido inicializada

    const inicializarPartidaOffline = () => {
        if (hayPartidaInicializada()) {
            console.log('Ya hay partida creada:');
        } else {
            console.log('Creando partida...');
            // Creamos partida en bbdd
            fetch(urlCrearPartida, {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json',
                'authorization': tokenCookie
                },
                body: JSON.stringify({ nombreId1: nombreId1Cookie, bioma: 'Mediterraneo', amistosa: true}) // TO DO: biomas!!!
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('La solicitud ha fallado');
                }
                return response.json();
            })
            .then(data => {
                console.log('Partida creada:');
                idPartida = data.codigo;
                console.log(idPartida);
                setPartidaInicializada(true);
            })
            .catch(error => {
                console.error('Error:', error);
            });
            
        }
    };

    const hayPartidaInicializada = () => {
        return partidaInicializada;
    };

    const boardDimension = 10;

    const [myBoard, setMyBoard] = useState(null); // Estado para almacenar la instancia de GridStack
    const [opponentBoard, setOpponentBoard] = useState(null); // Estado para almacenar la instancia de GridStack
    const [count, setCount] = useState(0); // Estado para contar widgets


    // Este efecto se ejecuta solo una vez después del montaje inicial del componente
    useEffect(() => {

        // TODO: Mira si venimos de partida offline o online
        // inicializarPartidaOnline();
        inicializarPartidaOffline();

        // Inicializamos el tablero propio con las siguientes propiedades
        const myBoard = GridStack.init({
            float: true,
            column: boardDimension,     // coordenadas indexadas a 0..9
            row: boardDimension,        // coordenadas indexadas a 0..9
            removable: false,            // eliminar widgets si se sacan del tablero
            acceptWidgets: true,        // acepta widgets de otros tableros
            disableResize: true,        // quita icono de resize en cada widget
            resizable: {},               // no se puede redimensionar
            animate: false,              // animación al añadir o mover widgets
            //cellHeight: "80px", // Establecer la altura de cada celda en 50px
            // No permitir arrastrar ni mover widgets
            draggable: {
                enabled: false
            },
            disableDrag: true,
        }, '.grid-stack.fleet-board1');
        setMyBoard(myBoard); // Almacenar la instancia de GridStack en el estado

        // Inicializamos el tablero del oponente con las siguientes propiedades
        const opponentBoard = GridStack.init({
            float: true,
            column: boardDimension,     // coordenadas indexadas a 0..9
            row: boardDimension,        // coordenadas indexadas a 0..9
            removable: false,            // eliminar widgets si se sacan del tablero
            acceptWidgets: true,        // acepta widgets de otros tableros
            disableResize: true,        // quita icono de resize en cada widget
            resizable: {},               // no se puede redimensionar
            animate: false,              // animación al añadir o mover widgets
            //cellHeight: "80px", // Establecer la altura de cada celda en 50px
            draggable: {
                enabled: false
            },
            disableDrag: true,
            
        }, '.grid-stack.fleet-board2');
        setOpponentBoard(opponentBoard); // Almacenar la instancia de GridStack en el estado
    }, []);

    const mostrarWidgetsTablero = (tablero, board) => {
        addNewWidgetPos(1, "Patrol", tablero[0].coordenadas[0].j-1, tablero[0].coordenadas[0].i-1, esBarcoHorizontal(tablero[0]), board);
        addNewWidgetPos(2, "Destroy", tablero[1].coordenadas[0].j-1, tablero[1].coordenadas[0].i-1, esBarcoHorizontal(tablero[1]), board);
        addNewWidgetPos(3, "Sub", tablero[2].coordenadas[0].j-1, tablero[2].coordenadas[0].i-1, esBarcoHorizontal(tablero[2]), board);
        addNewWidgetPos(4, "Bship", tablero[3].coordenadas[0].j-1, tablero[3].coordenadas[0].i-1, esBarcoHorizontal(tablero[3]), board);
        addNewWidgetPos(5, "Aircraft", tablero[4].coordenadas[0].j-1, tablero[4].coordenadas[0].i-1, esBarcoHorizontal(tablero[4]), board);
        setCount(6);
    }

    const borrarWidgetsTablero = (board) => {
        if (board) {
            board.removeAll();
        }
    }


    // Este efecto se ejecuta cuando myBoard cambia
    useEffect(() => {
        if(!hayPartidaInicializada()) {
            console.log('Intenta cargar tableros, hay que esperar a que se cree la partida...');
        } else {
            // Obtener el tablero inicial del perfil en la base de datos
            try {
                console.log('Obteniendo tablero inicial...');
                console.log('idPartida:', idPartida);
                console.log('nombreId:', nombreId1Cookie);
                fetch(urlMostrarTableros, {
                    method: 'POST',
                    headers: {
                    'Content-Type': 'application/json',
                    'authorization': tokenCookie
                    },
                    body: JSON.stringify({ codigo: idPartida, nombreId: nombreId1Cookie})
                })
                .then(response => {
                    if (!response.ok) {
                    throw new Error('La solicitud ha fallado');
                    }
                    return response.json();
                })
                .then(data => {
                    tablero1 = data.tableroBarcos1;
                    disparos1 = data.disparosRealizados1;
                    tablero2 = data.tableroBarcos2;
                    disparos2 = data.disparosRealizados2;
                    // const tableroInicial = [
                    //     [{ i: 1, j: 1 }, { i: 1, j: 2 }],
                    //     [{ i: 7, j: 1 }, { i: 8, j: 1 }, { i: 9, j: 1 }],
                    //     [{ i: 3, j: 10 }, { i: 4, j: 10 }, { i: 5, j: 10 }],
                    //     [{ i: 3, j: 6 }, { i: 4, j: 6 }, { i: 5, j: 6 }, { i: 6, j: 6 }],
                    //     [{ i: 10, j: 6 }, { i: 10, j: 7 }, { i: 10, j: 8 }, { i: 10, j: 9 }, { i: 10, j: 10 }]
                    //   ];
                    borrarWidgetsTablero(myBoard);
                    mostrarWidgetsTablero(tablero1, myBoard);
                    borrarWidgetsTablero(opponentBoard);
                    mostrarWidgetsTablero(tablero2, opponentBoard);
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            } catch (error) {
                console.error('Error:', error);
            }
        }
        
    }, [myBoard, opponentBoard]);


    // Función que añade un elemento a la cuadrícula
    const addNewWidgetPos = (id, ship, x, y, esHorizontal, board) => {
        //const shipName = shipInfo[ship].name;
        const node = {
            id: id,      // id para identificar el widget
            locked: true,           // inmutable por otros widgets
            content: `<img src="${shipInfo[ship].img}" alt="${shipInfo[ship].name}";" />`,
            x: x,
            y: y,
            w: shipInfo[ship].size,
            h: 1,
            info: "noRotated"
        };
        if (!esHorizontal) {
            node.content = `<img src="${shipInfo[ship].imgRotated}" alt="${shipInfo[ship].name}";" />`;
            node.w = 1;
            node.h = shipInfo[ship].size;
        }
        if (board) {    // El tablero está inicializado
            board.addWidget(node);   // Añadir widget a la cuadrícula
            
            setCount(prevCount => prevCount + 1); // Incrementar el contador
        }
    };


    // Función para manejar el clic izquierdo (disparos)
    const handleItemClick = (event) => {
        // TO-DO: Implementar disparos
        // saber en qué celda del tablero rival se ha clickado
        const cell = event.target;
        const cellId = cell.id;
        console.log('Celda:', cellId);
        if (cellId) {
            const response = fetch(urlRealizarDisparo, {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json',
                'authorization': tokenCookie
                },
                body: JSON.stringify({ idPartida: idPartida, nombreId: nombreId1Cookie, i: cellId[1], j: cellId[3]})
                
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const responseData = response.json(); // Suponiendo que el backend devuelve JSON
            console.log('Respuesta del servidor al disparar:', responseData);
            
        }

    };

    useEffect(() => {
        if (!(skillQueue.length > 0 && skillQueue[0] === "null")) {
            // Modificar el mazo en la base de datos
            fetch(urlModificarMazoHabilidades, {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json',
                'authorization': tokenCookie
                },
                body: JSON.stringify({ nombreId: nombreId1Cookie,  mazoHabilidades: skillQueue})
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('La solicitud ha fallado');
                }
                return response.json();
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }
    }, [skillQueue]);


    return (
        <>
            <div className="fleet-page-container">
                <Navbar/>
                <div className="fleet-container">
                    <h1 className="fleet-banner-container">
                        ¡A batallar!
                    </h1>
                    <div className="fleet-main-content-container">
                        <div className="grid-stack fleet-board1">
                            <Tablero id="tablero" className='tablero-overlay' />
                        </div>
                        <div className="fleet-board-separator"></div>
                        <div className="grid-stack fleet-board2" onClick={handleItemClick}></div>
                    </div>
                </div>
            </div>
        </>
    );
}
