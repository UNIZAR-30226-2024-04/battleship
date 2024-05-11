import React, { useEffect, useState } from 'react';
import { Navbar } from "../Components/Navbar";
import { GridStack } from 'gridstack';
import { useNavigate } from 'react-router-dom';
import Cookies from "universal-cookie";
import '../Styles/fleet-style.css';
import '../Styles/game-style.css';
import 'gridstack/dist/gridstack.min.css';
import 'gridstack/dist/gridstack-extra.min.css';

import Tablero from '../Components/Tablero';

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

import crossImg from '../Images/ingame/cross.png';
import explosionImg from '../Images/ingame/explosion.png';
import sonarBarcoImg from '../Images/symbols/shipSymbol.png';
import sonarMinaImg from '../Images/symbols/mineSymbol.png';

import { useSocket } from '../Contexts/SocketContext';
import { Navigate } from 'react-router-dom';

// Establecer la url de obtenerPerfil, moverBarcoInicial del backend
const urlObtenerDatosPersonales = 'http://localhost:8080/perfil/obtenerDatosPersonales';
const urlMoverBarcoInicial = 'http://localhost:8080/perfil/moverBarcoInicial';
const urlModificarMazoHabilidades = 'http://localhost:8080/perfil/modificarMazo';
const urlCrearPartida = 'http://localhost:8080/partida/crearPartida';
const urlRealizarDisparo = 'http://localhost:8080/partida/realizarDisparo';
const urlMostrarTableros = 'http://localhost:8080/partida/mostrarTableros';
const urlAbandonarPartida = 'http://localhost:8080/partida/abandonarPartida';
const urlRealizarDisparoMisilRafaga = 'http://localhost:8080/partida/realizarDisparoMisilRafaga';
const urlRealizarDisparoTorpedoRecargado = 'http://localhost:8080/partida/realizarDisparoTorpedoRecargado';
const urlRealizarDisparoMisilTeledirigido = 'http://localhost:8080/partida/realizarDisparoMisilTeledirigido';
const urlColocarMina = 'http://localhost:8080/partida/colocarMina';
const urlUsarSonar = 'http://localhost:8080/partida/usarSonar';

const cookies = new Cookies();

// function Mutex() {
//     // Estado para controlar si el recurso está bloqueado o no
//     const [isLocked, setIsLocked] = useState(false);
  
//     // Función para bloquear el recurso
//     const lockResource = () => {
//       setIsLocked(true);
//     };
  
//     // Función para desbloquear el recurso
//     const unlockResource = () => {
//       setIsLocked(false);
//     };
// }


// Contiene el tamaño y nombre de los barcos a usar
const shipInfo = {
    'Aircraft': { size: 5, name: "Aircraft", img: aircraftImg, imgRotated: aircraftImgRotated},
    'Bship': { size: 4, name: "Bship", img: bshipImg, imgRotated: bshipImgRotated},
    'Sub': { size: 3, name: "Sub", img: submarineImg, imgRotated: submarineImgRotated},
    'Destroy': { size: 3, name: "Destroy", img: destroyImg, imgRotated: destroyImgRotated},
    'Patrol': { size: 2, name: "Patrol", img: patrolImg, imgRotated: patrolImgRotated},
};



function resetEndgameMsg() {
    const endgameContainer = document.querySelector("#endgame-container");
    endgameContainer.style.display = "none"
    const endgameMsg = document.querySelector("#endgame-container span");
    endgameMsg.innerHTML = "";
}


function esBarcoHorizontal(barco) {
    return barco.coordenadas[0].i === barco.coordenadas[1].i;
}

export function Game() {
    const navigate = useNavigate();
    const { socket } = useSocket();
    const [lastClickedCell, setLastClickedCell] = useState(null);
    let [skill, setSkill] = useState(null); // Estado para almacenar la habilidad seleccionada

    function triggerFinPartida(finPartida, soyYo) {
        if (finPartida) {
            const endgameContainer = document.querySelector("#endgame-container");
            endgameContainer.style.display = "block"
            const endgameMsg = document.querySelector("#endgame-container span");
            if (soyYo) {
                endgameMsg.innerHTML = "¡Victoria!";
            } else {
                endgameMsg.innerHTML = "¡Derrota!";
            }
            setTimeout(() => {
                navigate('/home');
            }, 3000);
        }
    }

    const handleMinaMiTablero = (fila, columna) => {
        setLastClickedCell({ fila, columna });
        if (skill === "Mina") {
            console.log('Colocando mina en tu tablero');
            colocarMina(fila, columna);
            setSkill(null);
        }
    };

    const handleClickedCell = (fila, columna) => {
        console.log(`Celda clickeada: Fila ${fila}, Columna ${columna}`);
        setLastClickedCell({ fila, columna });
        // Hacer la petición al backend utilizando las coordenadas de la celda
        // Aquí puedes hacer tu lógica para la petición al backend
        if (skill === null) {
            disparoNormal(fila, columna);
        } else if (skill === "Mina") {
            // Lógica para la habilidad Mina
            console.log('La Habilidad Mina se tiene que utilizar en tu tablero');
            // TO DO: Implementar habilidad mina
        } else if (skill === "Teledirigido") {
            // Lógica para la habilidad Teledirigido
            console.log('Habilidad Teledirigido');
            // TO DO: Implementar habilidad teledirigido
        } else if (skill === "Rafaga") {
            // Lógica para la habilidad Rafaga
            console.log('Habilidad Rafaga');
            disparoRafaga(fila, columna);
            // TO DO: Implementar habilidad rafaga
        } else if (skill === "Sonar") {
            // Lógica para la habilidad Sonar
            console.log('Habilidad Sonar');
            usarSonar(fila, columna);
            // TO DO: Implementar habilidad sonar
        } else if (skill === "Recargado") {
            // Lógica para la habilidad Torpedo
            console.log('Habilidad Recargado');
            disparoTorpedo(fila, columna, false);
            // TO DO: Implementar habilidad torpedo
        } else {
            console.log('Habilidad no reconocida');
        }
    };

    // Obtener el token y nombreId del usuario
    const tokenCookie = cookies.get('JWT');
    const nombreId1Cookie = cookies.get('perfil')['nombreId'];

    // Datos partida
    let [idPartida, setIdPartida] = useState(null);
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



    // Cargar info del perfil para recuperar la partida en curso
    async function inicializarPartidaOffline() {
        if (hayPartidaInicializada()) {
            console.log('Ya hay partida creada:');
        } else {
            fetch(urlObtenerDatosPersonales, {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json',
                'authorization': tokenCookie
                },
                body: JSON.stringify({ nombreId: nombreId1Cookie})
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('La solicitud ha fallado');
                }
                return response.json();
            })
            .then(data => {
                console.log('Datos personales:', data);
                if (data.codigoPartidaActual != -1) {
                    console.log('Partida en curso:', data.codigoPartidaActual);
                    setIdPartida(data.codigoPartidaActual);
                    setPartidaInicializada(true);
                } else {
                    console.log('No hay partida en curso');
                    // ----------------------------
                    setPartidaInicializada(true);
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
                            setPartidaInicializada(false);
                            throw new Error('La solicitud ha fallado');
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Partida creada:');
                        setIdPartida(data.codigo);
                        console.log(idPartida);
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        setPartidaInicializada(false);
                    });
                }
            })  
            .catch(error => {
                console.error('Error:', error);
                setPartidaInicializada(false);
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


    // Este efecto se ejecuta al entrar a la página
    useEffect(() => {
        // Buscamos sincronizar las llamadas
        const fetchData = async () => {
            // TODO: Mira si venimos de partida offline o online
            // inicializarPartidaOnline();
            await inicializarPartidaOffline();

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
        };
        fetchData();
    }, []);


    // Función que añade un elemento a la cuadrícula
    const addNewWidgetPos = (id, ship, x, y, esHorizontal, board, hundido=false) => {
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
            if (hundido) {
                node.content = `<img src="${shipInfo[ship].imgRotated}" alt="${shipInfo[ship].name}" class="imgHundida" />`;
            }
        }
        if (hundido && !esHorizontal) {
            console.log("Estoy hundido vertical");
            node.content = `<img src="${shipInfo[ship].imgRotated}" alt="${shipInfo[ship].name}" class="imgHundida" />`;
        } else if (hundido) {
            console.log("Estoy hundido horizontal");
            node.content = `<img src="${shipInfo[ship].img}" alt="${shipInfo[ship].name}" class="imgHundida" />`;
        }
        if (board) {    // El tablero está inicializado
            board.addWidget(node);   // Añadir widget a la cuadrícula
            
            setCount(prevCount => prevCount + 1); // Incrementar el contador
        }
    };


    /*-----------------------------------------------------------------
                            Mostrar Barcos Hundidos
    -----------------------------------------------------------------*/

    // Esta función se encarga de mostrar los barcos que nos ha hundido la IA
    const mostrarBarcosHundidos2 = (tablero) => {
        for (let i = 0; i < tablero['coordenadas'].length; i++) {
            const { tipoBarco, id } = obtenerTipoBarco(tablero['tipo']);
            // edita el widget antiguo
            hundirBarco(id);
        }
    }

    const mostrarBarcosHundidos = (tablero, board) => {
        for (let i = 0; i < tablero.length; i++) {
            const coordenadas = tablero[i].coordenadas;
            const { tipoBarco, id } = obtenerTipoBarco(tablero[i]['tipo']);
            addNewWidgetPos(i, tipoBarco, coordenadas[0].j-1, coordenadas[0].i-1, esBarcoHorizontal(tablero[i]), board, true);
        }
    }

    
    const mostrarWidgetsTablero = (tablero, board) => {
        addNewWidgetPos(1, "Patrol", tablero[0].coordenadas[0].j-1, tablero[0].coordenadas[0].i-1, esBarcoHorizontal(tablero[0]),
                        board, tablero[0].coordenadas[0].estado === "Hundido");
        addNewWidgetPos(2, "Destroy", tablero[1].coordenadas[0].j-1, tablero[1].coordenadas[0].i-1, esBarcoHorizontal(tablero[1]),
                        board, tablero[1].coordenadas[0].estado === "Hundido");
        addNewWidgetPos(3, "Sub", tablero[2].coordenadas[0].j-1, tablero[2].coordenadas[0].i-1, esBarcoHorizontal(tablero[2]),
                        board, tablero[2].coordenadas[0].estado === "Hundido");
        addNewWidgetPos(4, "Bship", tablero[3].coordenadas[0].j-1, tablero[3].coordenadas[0].i-1, esBarcoHorizontal(tablero[3]), 
                        board, tablero[3].coordenadas[0].estado === "Hundido");
        addNewWidgetPos(5, "Aircraft", tablero[4].coordenadas[0].j-1, tablero[4].coordenadas[0].i-1, esBarcoHorizontal(tablero[4]),
                         board, tablero[4].coordenadas[0].estado === "Hundido");
        setCount(6);
    }

    const borrarWidgetsTablero = (board) => {
        if (board) {
            board.removeAll();
        }
    }

    const hundirBarco = (id) => {
        const widget = document.querySelector(`.fleet-board1 [gs-id="${id}"] .grid-stack-item-content img`);
        widget.classList = "imgHundida";
    }

    // Función que devuelve el tipo del barco (para barcos que me han hundido) junto a un id (para barcos que he hundido)
    const obtenerTipoBarco = (tipoBarco) => {
        let id;
        switch (tipoBarco) {
            case "Patrullero":
                tipoBarco = shipInfo["Patrol"].name;
                id = 1;
                break;
            case "Destructor":
                tipoBarco = shipInfo["Destroy"].name;
                id = 2;
                break;
            case "Submarino":
                tipoBarco = shipInfo["Sub"].name;
                id = 3;
                break;
            case "Acorazado":
                tipoBarco = shipInfo["Bship"].name;
                id = 4;
                break;
            case "Portaviones":
                tipoBarco = shipInfo["Aircraft"].name;
                id = 5;
                break;
            default:
                console.log("Error: barco mal hecho -1 para backend");
        }
        return { tipoBarco, id };
    }


    /*-----------------------------------------------------------------
                        Funciones del contador de barcos
    -----------------------------------------------------------------*/
    
    // Función que quita la clase que "hunde" los barcos del contador
    const ocultarContadorBarcosHundidos = () => {
        const barcos = document.querySelectorAll('.game-rivalship-counter-content [class^="game-counter-"]');
        barcos.forEach(barco => {
            barco.classList.remove("imgHundida");
        });
    }

    // Función que añade la clase que "hunde" los barcos del contador
    const mostrarContadorBarcosHundidos = (tablero) => {
        let barco;
        for (let i = 0; i < tablero.length; i++) {
            let { tipoBarco, id } = obtenerTipoBarco(tablero[i]['tipo']);
            console.log(tipoBarco);
            tipoBarco = tipoBarco.toLowerCase();
            console.log(tipoBarco);
            barco = document.querySelector(
                `.game-rivalship-counter .game-rivalship-counter-content .game-counter-${tipoBarco}`);
            if (barco) {
                barco.classList.add("imgHundida");
            }
            console.log("eoeoeoe");
        }
    }


    /*-----------------------------------------------------------------
              Funciones para turnos de disparos basicos
    -----------------------------------------------------------------*/

    // DISPAROS IA
    function funcionTurnosIA(turnosIA) {
        for (let i = 0; i < turnosIA.length; i++) {
                
            //callerFunction();
            const disparoIA = turnosIA[i].disparoRealizado;
            const filaIA = disparoIA.i;
            const columnaIA = disparoIA.j;
            const estadoIA = disparoIA.estado;

            const locationCasillaIA = (filaIA-1)*10 + columnaIA - 1;
            const casillaIA = document.querySelector(`#miTablero .casilla[location="${locationCasillaIA}"]`);

            let imgXIA = document.createElement('img');
            imgXIA.style.width = '50%';
            imgXIA.style.height = '50%';
            imgXIA.style.marginLeft = '25%';
            imgXIA.style.marginTop = '25%';
            imgXIA.style.objectFit = 'cover';

            switch (estadoIA) {
                case "Tocado":
                    if (casillaIA.childElementCount === 0) {  // Solo 1 img
                        imgXIA.src = explosionImg;
                        casillaIA.appendChild(imgXIA);
                    }
                    break;
                case "Hundido":
                    if (casillaIA.childElementCount === 0 ) { // Solo 1 img
                        imgXIA.src = explosionImg;
                        casillaIA.appendChild(imgXIA);
                        //mostrar Barco Por Debajo
                        
                    }
                    break;
                case "Agua":
                    if (casillaIA.childElementCount === 0) {  // Solo 1 img
                        imgXIA.src = crossImg;
                        imgXIA.style.opacity = '0.7';
                        casillaIA.appendChild(imgXIA);
                    }

                    break;
                default:
                    console.log("Error: disparo mal hecho -1 para backend");
            }

            if(turnosIA[i].barcoCoordenadas) {
                mostrarBarcosHundidos2(turnosIA[i].barcoCoordenadas);
                triggerFinPartida(turnosIA[i].finPartida, false);       // comprobamos fin partida
            }
        }
    }

    // MOSTRAR RESULTADO DE DISPARO EN TABLERO
    function mostrarDisparo(fila, columna, estado) {

        const locationCasilla = (fila-1)*10 + columna - 1;
        const casilla = document.querySelector(`#rivalTablero .casilla[location="${locationCasilla}"]`);

        let imgX = document.createElement('img');
        imgX.style.width = '50%';
        imgX.style.height = '50%';
        imgX.style.marginLeft = '25%';
        imgX.style.marginTop = '25%';
        imgX.style.objectFit = 'cover';

        switch (estado) {
            case "Tocado":
                if (casilla.childElementCount === 0 || casilla.classList.contains("sonarBarco")) {  // Solo 1 img
                    imgX.src = explosionImg;
                    if(casilla.childElementCount > 0) {
                        casilla.classList.remove("sonarBarco");
                        casilla.removeChild(casilla.lastChild);
                    }
                    casilla.appendChild(imgX);
                }
                break;
            case "Hundido":
                if (casilla.childElementCount === 0 || casilla.classList.contains("sonarBarco")) { // Solo 1 img
                    imgX.src = explosionImg;
                    if(casilla.childElementCount > 0) {
                        casilla.removeChild(casilla.lastChild);
                        casilla.classList.remove("sonarBarco");
                    } 
                    casilla.appendChild(imgX);
                    //mostrarBarcoPorDebajo();
                }
                break;
            case "Agua":
                if (casilla.childElementCount === 0) {  // Solo 1 img
                    imgX.src = crossImg;
                    imgX.style.opacity = '0.7';
                    casilla.appendChild(imgX);
                }
                break;
            default:
                console.log("Error: disparo mal hecho -1 para backend");
        }
    }
    

    // DISPARO NORMAL
    function disparoNormal(fila, columna) {
        fetch(urlRealizarDisparo, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ codigo:idPartida, nombreId: nombreId1Cookie, i: fila, j: columna})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor al disparar:', response);
                throw new Error('Realizar Disparo ha fallado');
            }
            return response.json();
        })
        .then(data => {
            const disp = data['disparoRealizado'];
            mostrarDisparo(disp.i, disp.j, disp.estado, data['barcoCoordenadas'], data['finPartida']);            
            if(data['barcoCoordenadas']) {
                mostrarContadorBarcosHundidos([data['barcoCoordenadas']]);
                mostrarBarcosHundidos([data['barcoCoordenadas']], opponentBoard);
                triggerFinPartida(data['finPartida'], true);    // fin de partida si se da el caso
            }
            // Representar las jugadas de la IA
            funcionTurnosIA(data['turnosIA']);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    /*-----------------------------------------------------------------
              Funciones para turnos de habilidades
    -----------------------------------------------------------------*/

    let [misilesRafagaRestantes, setMisilesRafagaRestantes] = useState(3); // Estado para almacenar los misiles de la habilidad Rafaga

    useEffect(() => {
        console.log('Misiles de Rafaga decrementados a:', misilesRafagaRestantes);
        if (misilesRafagaRestantes == 0) {
            console.log('Misiles de Rafaga agotados');
            setSkill(null);
            setMisilesRafagaRestantes(3);
        }
    }, [misilesRafagaRestantes]);

    // DISPARO MISIL RAFAGA
    function disparoRafaga(fila, columna) {
        fetch(urlRealizarDisparoMisilRafaga, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ codigo:idPartida, nombreId: nombreId1Cookie, i: fila, j: columna, misilesRafagaRestantes: misilesRafagaRestantes})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor al disparar:', response);
                throw new Error('Realizar Disparo ha fallado');
            }
            return response.json();
        })
        .then(data => {
            const disp = data['disparoRealizado'];
            if (disp.estado === "Agua") {
                setMisilesRafagaRestantes(prevMisiles => prevMisiles - 1);
            }
            mostrarDisparo(disp.i, disp.j, disp.estado, data['barcoCoordenadas'], data['finPartida']);
            if(data['barcoCoordenadas']) {
                mostrarContadorBarcosHundidos([data['barcoCoordenadas']]);
                mostrarBarcosHundidos([data['barcoCoordenadas']], opponentBoard);
                triggerFinPartida(data['finPartida'], true);    // fin de partida si se da el caso
            }
            // Representar las jugadas de la IA
            funcionTurnosIA(data['turnosIA']);
        })
    }

    // DISPARO TORPEDO RECARGADO
    function disparoTorpedo(fila, columna, turnoRecargado) {
        fetch(urlRealizarDisparoTorpedoRecargado, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ codigo:idPartida, nombreId: nombreId1Cookie, i: fila, j: columna, turnoRecarga: turnoRecargado})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor al disparar:', response);
                throw new Error('Realizar Disparo ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor al disparar:', data);
            if(!turnoRecargado){
                // Torpedo disparado, iteramos sobre los 9 disparos recibidos
                const disparos = data['disparosRealizados'];
                for (let i = 0; i < disparos.length; i++) {
                    const disp = disparos[i];
                    mostrarDisparo(disp.i, disp.j, disp.estado, data['barcoCoordenadas'], data['finPartida']);
                }
                if(data['barcoCoordenadas']) {
                    mostrarContadorBarcosHundidos(data['barcoCoordenadas']);
                    mostrarBarcosHundidos(data['barcoCoordenadas'], opponentBoard);
                    triggerFinPartida(data['finPartida'], true);    // fin de partida si se da el caso
                }
                setSkill(null);
            }
            // Representar las jugadas de la IA
            funcionTurnosIA(data['turnosIA']);
        })
    }
    
    // DISPARO MISIL TELEDIRIGIDO
    function disparoMisilTeledirigido() {
        fetch(urlRealizarDisparoMisilTeledirigido, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ codigo:idPartida, nombreId: nombreId1Cookie})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor al disparar:', response);
                throw new Error('Realizar Disparo ha fallado');
            }
            return response.json();
        })
        .then(data => {
            const disp = data['disparoRealizado'];
            mostrarDisparo(disp.i, disp.j, disp.estado, data['barcoCoordenadas'], data['finPartida']);
            if(data['barcoCoordenadas']) {
                mostrarContadorBarcosHundidos([data['barcoCoordenadas']]);
                mostrarBarcosHundidos([data['barcoCoordenadas']], opponentBoard);
                triggerFinPartida(data['finPartida'], true);    // fin de partida si se da el caso
            }
            // Representar las jugadas de la IA
            funcionTurnosIA(data['turnosIA']);
            setSkill(null);
        })
    }

    // USAR SONAR
    function usarSonar(fila, columna) {
        fetch(urlUsarSonar, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ codigo:idPartida, nombreId: nombreId1Cookie, i: fila, j: columna})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor al disparar:', response);
                throw new Error('Realizar Disparo ha fallado');
            }
            return response.json();
        })
        .then(data => {
            const matriz = data['sonar']
            // Mirar en la matriz si hay 'Barco', 'Mina' o 'Agua' y mostrar imagenes en tablero
            fila = fila-1;
            columna = columna-1;
            for (let i = 0; i < matriz.length; i++) {
                for (let j = 0; j < matriz[i].length; j++) {
                    const locationCasilla = (fila-1+i)*10 + columna + j - 1;
                    const casilla = document.querySelector(`#rivalTablero .casilla[location="${locationCasilla}"]`);
            
                    let imgX = document.createElement('img');
                    imgX.style.width = '50%';
                    imgX.style.height = '50%';
                    imgX.style.marginLeft = '25%';
                    imgX.style.marginTop = '25%';
                    imgX.style.objectFit = 'cover';

                    switch (matriz[i][j]) {
                        case "Barco":
                            casilla.classList.add("sonarBarco");
                            imgX.src = sonarBarcoImg;
                            imgX.style.opacity = '0.3';
                            break;
                        case "Mina":
                            imgX.src = sonarMinaImg;
                            imgX.style.opacity = '0.3';
                            break;
                        case "Agua":
                            imgX.style.opacity = '0.7';
                            imgX.src = crossImg; //crossImg;
                            break;
                        default:
                            console.log("Error: sonar mal hecho -1 para backend");
                    }
                    casilla.appendChild(imgX);
                }
            }
                       
            // Representar las jugadas de la IA
            funcionTurnosIA(data['turnosIA']);
            setSkill(null);
        })
    }


    // COLOCAR MINA
    function colocarMina(fila, columna) {
        fetch(urlColocarMina, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'authorization': tokenCookie
            },
            body: JSON.stringify({ codigo:idPartida, nombreId: nombreId1Cookie, i: fila, j: columna})
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor al disparar:', response);
                throw new Error('Realizar Disparo ha fallado');
            }
            return response.json();
        })
        .then(data => {
            if (data.minaColocada) {
                // Mostrar la mina en nuestro tablero
                const locationCasilla = (fila-1)*10 + columna - 1;
                const casilla = document.querySelector(`#miTablero .casilla[location="${locationCasilla}"]`);
                let imgX = document.createElement('img');
                imgX.style.width = '50%';
                imgX.style.height = '50%';
                imgX.style.marginLeft = '25%';
                imgX.style.marginTop = '25%';
                imgX.style.objectFit = 'cover';
                imgX.src = sonarMinaImg;
                casilla.appendChild(imgX);
    
                // Representar las jugadas de la IA
                funcionTurnosIA(data['turnosIA']);
                setSkill(null);
            }
            else {
                console.log("Mina no se puede colocar allí");
            }
        })
    }

    // ------------------------------- //
    //   Fin Funciones de habilidades  //
    // ------------------------------- //



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
                    tablero1 = data.tableroBarcos;
                    disparos1 = data.misDisparos;
                    tablero2 = data.barcosHundidos;
                    disparos2 = data.disparosEnemigos;

                    borrarWidgetsTablero(myBoard);
                    mostrarWidgetsTablero(tablero1, myBoard);

                    // TO-DO: Mostrar tablero del oponente 
                    // (No los barcos directamente, sino las celdas donde se ha disparado y los hundidos)

                    //borrarWidgetsTablero(opponentBoard);
                    //mostrarWidgetsTablero(tablero2, opponentBoard);
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            } catch (error) {
                console.error('Error:', error);
            }
        }
        
    }, [myBoard, opponentBoard]);


    // Este efecto se ejecuta cuando myBoard cambia
    // CARGA EL ESTADO ANTERIOR DE LA PARTIDA
    useEffect(() => {
        if(!idPartida) {
            console.log('No hay idPartida');
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
                    throw new Error('La solicitud endpoint "mostrarTableros" ha fallado');
                    }
                    return response.json();
                })
                .then(data => {
                    tablero1 = data.tableroBarcos;
                    disparos1 = data.misDisparos;
                    tablero2 = data.barcosHundidos;
                    disparos2 = data.disparosEnemigos;

                    // iterar en la lista disparos1
                    for (let i = 0; i < disparos1.length; i++) {
                        const fila = disparos1[i].i;
                        const columna = disparos1[i].j;
                        const estado = disparos1[i].estado;

                        const locationCasilla = (fila-1)*10 + columna - 1;
                        const casilla = document.querySelector(`#rivalTablero .casilla[location="${locationCasilla}"]`);

                        let imgX = document.createElement('img');
                        imgX.style.width = '50%';
                        imgX.style.height = '50%';
                        imgX.style.marginLeft = '25%';
                        imgX.style.marginTop = '25%';
                        imgX.style.objectFit = 'cover';

                        switch (estado) {
                            case "Tocado":
                                if (casilla.childElementCount === 0) {  // Solo 1 img
                                    imgX.src = explosionImg;
                                    casilla.appendChild(imgX);
                                }
                                break;
                            case "Hundido":
                                if (casilla.childElementCount === 0) { // Solo 1 img
                                    imgX.src = explosionImg;
                                    casilla.appendChild(imgX);
                                    //mostrarBarcoPorDebajo();
                                }
                                break;
                            case "Agua":
                                if (casilla.childElementCount === 0) {  // Solo 1 img
                                    imgX.src = crossImg;
                                    imgX.style.opacity = '0.7';
                                    casilla.appendChild(imgX);
                                }
                                // relanzar el return de Game

                                break;
                            default:
                                console.log("Error: disparo mal hecho -1 para backend");
                        }
                    }
                    

                    ocultarContadorBarcosHundidos();    // Reseteamos contador
                    mostrarContadorBarcosHundidos(tablero2);

                    // iteramos por los barcos ya hundidos
                    mostrarBarcosHundidos(tablero2, opponentBoard);

                    borrarWidgetsTablero(myBoard);
                    mostrarWidgetsTablero(tablero1, myBoard);

                    // Mostramos los disparos de la IA
                    // iterar en la lista disparos2
                    console.log('Disparos de la IA:', disparos2);
                    for (let i = 0; i < disparos2.length; i++) {
                        const fila = disparos2[i].i;
                        const columna = disparos2[i].j;
                        const estado = disparos2[i].estado;

                        const locationCasilla = (fila-1)*10 + columna - 1;
                        const casilla = document.querySelector(`#miTablero .casilla[location="${locationCasilla}"]`);

                        let imgX = document.createElement('img');
                        imgX.style.width = '50%';
                        imgX.style.height = '50%';
                        imgX.style.marginLeft = '25%';
                        imgX.style.marginTop = '25%';
                        imgX.style.objectFit = 'cover';

                        switch (estado) {
                            case "Tocado":
                                if (casilla.childElementCount === 0) {  // Solo 1 img
                                    imgX.src = explosionImg;
                                    casilla.appendChild(imgX);
                                }
                                break;
                            case "Hundido":
                                if (casilla.childElementCount === 0) { // Solo 1 img
                                    imgX.src = explosionImg;
                                    casilla.appendChild(imgX);
                                    //mostrarBarcoPorDebajo();
                                }
                                break;
                            case "Agua":
                                if (casilla.childElementCount === 0) {  // Solo 1 img
                                    imgX.src = crossImg;
                                    imgX.style.opacity = '0.7';
                                    casilla.appendChild(imgX);
                                }
                                // relanzar el return de Game

                                break;
                            default:
                                console.log("Error: disparo mal hecho -1 para backend");
                        }
                    }

                    //borrarWidgetsTablero(opponentBoard);
                    //mostrarWidgetsTablero(tablero2, opponentBoard);
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            } catch (error) {
                console.error('Error:', error);
            }
        }

        resetEndgameMsg();  // resetar el mensaje de final
    }, [idPartida]);


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

    const rendirse = () => {
        fetch(urlAbandonarPartida, {
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
            console.log('Respuesta del servidor al rendirse:', data);
            // navigate('/home');
            triggerFinPartida(true, false);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }


    return (
        <>
            <div className="fleet-page-container">
                <Navbar/>
                <div className="fleet-container">
                    <h1 className="fleet-banner-container">
                        ¡A batallar!
                    </h1>
                    <div className='game-rivalship-counter'>
                        <div className='end-button-container'>
                            <button className="home-button" onClick={() => {rendirse()}} >
                                <span> Abandonar </span>
                            </button>
                        </div>
                        <div className='tab'></div>
                        <div className='game-rivalship-counter-content'>
                            <img className="game-counter-aircraft" src={shipInfo['Aircraft'].imgRotated} />
                            <img className="game-counter-bship" src={shipInfo['Bship'].imgRotated} />
                            <img className="game-counter-sub" src={shipInfo['Sub'].imgRotated} />
                            <img className="game-counter-destroy" src={shipInfo['Destroy'].imgRotated} />
                            <img className="game-counter-patrol" src={shipInfo['Patrol'].imgRotated} />
                        </div>
                    </div>
                    <div className="fleet-main-content-container">
                        <div className="grid-stack fleet-board1">
                            <Tablero id="miTablero" onCellClick={handleMinaMiTablero} clickable={true}/>
                        </div>
                        <div className="fleet-board-separator"></div>
                        <div className="grid-stack fleet-board2" /*onClick={handleItemClick}*/>
                            <Tablero id="rivalTablero" onCellClick={handleClickedCell} clickable={true}/>
                        </div>
                        <div id="endgame-container">
                            <span></span>
                        </div>
                        <div className="ship-buttons-container">
                            <div className={`skill-button ${isSkillEnqueued("Mina") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => setSkill("Mina") } src={mineImg} alt="Mine" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${isSkillEnqueued("Teledirigido") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => {
                                    setSkill("Teledirigido"); 
                                    disparoMisilTeledirigido();
                                }} src={missileImg} alt="Missile" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${isSkillEnqueued("Rafaga") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => setSkill("Rafaga") } src={burstImg} alt="Burst" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${isSkillEnqueued("Sonar") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => setSkill("Sonar") } src={sonarImg} alt="Sonar" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${isSkillEnqueued("Recargado") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => {
                                    setSkill("Recargado");
                                    disparoTorpedo(0, 0, true);
                                }} src={torpedoImg} alt="Torpedo" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
