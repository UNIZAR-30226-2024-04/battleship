import { useEffect, useState } from 'react';
import { Navbar } from "../Components/Navbar";
import { GridStack } from 'gridstack';
import Cookies from "universal-cookie";
import '../Styles/fleet-style.css';
import 'gridstack/dist/gridstack.min.css';
import 'gridstack/dist/gridstack-extra.min.css';

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

// Establecer la url de obtenerDatosPersonales, moverBarcoInicial del backend
const urlObtenerDatosPersonales = 'http://localhost:8080/perfil/obtenerDatosPersonales';
const urlMoverBarcoInicial = 'http://localhost:8080/perfil/moverBarcoInicial';
const urlModificarMazoHabilidades = 'http://localhost:8080/perfil/modificarMazo';

const cookies = new Cookies();

function esBarcoHorizontal(barco) {
    return barco.coordenadas[0].i === barco.coordenadas[1].i;
}

export function Fleet() {    
    // Obtener el token de la cookie

    // Recuperar el valor de las cookies
    const tokenCookie = cookies.get('JWT');
    const nombreIdCookie = cookies.get('perfil')['nombreId'];

    
    // Contiene el tamaño y nombre de los barcos a usar
    const shipInfo = {
        'Aircraft': { size: 5, name: "Aircraft", img: aircraftImg, imgRotated: aircraftImgRotated},
        'Bship': { size: 4, name: "Bship", img: bshipImg, imgRotated: bshipImgRotated},
        'Sub': { size: 3, name: "Sub", img: submarineImg, imgRotated: submarineImgRotated},
        'Destroy': { size: 3, name: "Destroy", img: destroyImg, imgRotated: destroyImgRotated},
        'Patrol': { size: 2, name: "Patrol", img: patrolImg, imgRotated: patrolImgRotated},
    };

    let tableroInicial = [];

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

    const boardDimension = 10;

    const [board, setBoard] = useState(null); // Estado para almacenar la instancia de GridStack
    const [count, setCount] = useState(0); // Estado para contar widgets

    // Este efecto se ejecuta solo una vez después del montaje inicial del componente
    useEffect(() => {
        // Inicializamos el tablero con las siguientes propiedades
        const board = GridStack.init({
            float: true,
            column: boardDimension,     // coordenadas indexadas a 0..9
            row: boardDimension,        // coordenadas indexadas a 0..9
            removable: false,            // eliminar widgets si se sacan del tablero
            acceptWidgets: true,        // acepta widgets de otros tableros
            disableResize: true,        // quita icono de resize en cada widget
            resizable: {},               // no se puede redimensionar
            animate: false,              // animación al añadir o mover widgets
            //cellHeight: "80px", // Establecer la altura de cada celda en 50px
            
        });
        setBoard(board); // Almacenar la instancia de GridStack en el estado
        if (board) {
            // Agregar un listener para el evento 'change'
            board.on('change', (event, nodes) => {
                // nodes es un array de objetos que contienen la información actualizada de los widgets
                // Aquí puedes acceder a node.x, node.y, node.w y node.h para cada widget
                nodes.forEach(node => {
                    // cansole.log('Widget ID:', node.id);
                    // cansole.log('New X position:', node.x);
                    // cansole.log('New Y position:', node.y);
                    // cansole.log('New width:', node.w);
                    // cansole.log('New height:', node.h);
                    // cansole.log('New orientation:', node.info);

                    // Restablecer la info del widget a noRotated
                    if (node.info === "rotated") {
                        node.info = "noRotated"; 
                        // Notar que esto hace que se capture de nuevo en el evento
                        // 'change' pero el resto de los atributos no cambian
                    } else {
                        node.info = "noRotated";
                        // Aquí editar el tablero en la base de datos
                        fetch(urlMoverBarcoInicial, {
                            method: 'POST',
                            headers: {
                            'Content-Type': 'application/json',
                            'authorization': tokenCookie
                            },
                            body: JSON.stringify({ nombreId: nombreIdCookie,  barcoId: node.id-1, iProaNueva: node.y+1, jProaNueva: node.x+1})
                        })
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('La solicitud ha fallado');
                            }
                            return response.json();
                        })
                        .then(data => {
                            if (data) {
                                if (!(data.colisiona) && !(data.fueraTablero)) {
                                    borrarWidgetsTablero();
                                    mostrarWidgetsTablero(data.tableroDevuelto);
                                }
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                        });
                    }
                })
            });
        }
    }, []);

    const mostrarWidgetsTablero = (tablero) => {
        addNewWidgetPos(1, "Patrol", tablero[0].coordenadas[0].j-1, tablero[0].coordenadas[0].i-1, esBarcoHorizontal(tablero[0]));
        addNewWidgetPos(2, "Destroy", tablero[1].coordenadas[0].j-1, tablero[1].coordenadas[0].i-1, esBarcoHorizontal(tablero[1]));
        addNewWidgetPos(3, "Sub", tablero[2].coordenadas[0].j-1, tablero[2].coordenadas[0].i-1, esBarcoHorizontal(tablero[2]));
        addNewWidgetPos(4, "Bship", tablero[3].coordenadas[0].j-1, tablero[3].coordenadas[0].i-1, esBarcoHorizontal(tablero[3]));
        addNewWidgetPos(5, "Aircraft", tablero[4].coordenadas[0].j-1, tablero[4].coordenadas[0].i-1, esBarcoHorizontal(tablero[4]));
        setCount(6);
    }

    const borrarWidgetsTablero = () => {
        if (board) {
            board.removeAll();
        }
    }


    // Este efecto se ejecuta cuando board cambia
    useEffect(() => {
        // Obtener el tablero inicial del perfil en la base de datos
        try {
            fetch(urlObtenerDatosPersonales, {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json',
                'authorization': tokenCookie
                },
                body: JSON.stringify({ nombreId: nombreIdCookie })
            })
            .then(response => {
                if (!response.ok) {
                throw new Error('La solicitud ha fallado');
                }
                return response.json();
            })
            .then(data => {
                console.log(data);
                tableroInicial = data.tableroInicial;
                // const tableroInicial = [
                //     [{ i: 1, j: 1 }, { i: 1, j: 2 }],
                //     [{ i: 7, j: 1 }, { i: 8, j: 1 }, { i: 9, j: 1 }],
                //     [{ i: 3, j: 10 }, { i: 4, j: 10 }, { i: 5, j: 10 }],
                //     [{ i: 3, j: 6 }, { i: 4, j: 6 }, { i: 5, j: 6 }, { i: 6, j: 6 }],
                //     [{ i: 10, j: 6 }, { i: 10, j: 7 }, { i: 10, j: 8 }, { i: 10, j: 9 }, { i: 10, j: 10 }]
                //   ];
                borrarWidgetsTablero();
                mostrarWidgetsTablero(tableroInicial);
                if (data.mazoHabilidades) {
                    if (isSkillEnqueued("null")) {
                        setSkillQueue([]);
                    }
                    for (let i = 0; i < data.mazoHabilidades.length; i++) {
                        enqueueSkill(data.mazoHabilidades[i]);
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        } catch (error) {
            console.error('Error:', error);
        }
        
    }, [board]);
    


    // Función que añade un elemento a la cuadrícula
    const addNewWidgetPos = (id, ship, x, y, esHorizontal) => {
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


    // Función para manejar el clic izquierdo en los widgets del tablero
    const handleItemClick = (event) => {
        let clickedNode = event.target.gridstackNode;

        // Si el nodo del clic no se encuentra directamente en el elemento "grid-stack-item",
        // intentamos encontrar el nodo ascendente más cercano que sea un "grid-stack-item".
        if (!clickedNode) {
            const gridStackItem = event.target.closest('.grid-stack-item');
            if (gridStackItem) {
                clickedNode = gridStackItem.gridstackNode;
            }
        }
    
        if (clickedNode) {
            const wantedAtribute = "[gs-id=\"" + clickedNode.id + "\"]";
            const widgetTarget = document.querySelector(wantedAtribute);

            // Usar el backend para ver si la rotacion es posible
            // y en tal caso, guardar en bbdd y rotar el widget
            fetch(urlMoverBarcoInicial, {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json',
                'authorization': tokenCookie
                },
                body: JSON.stringify({ nombreId: nombreIdCookie,  barcoId: clickedNode.id-1, rotar: 1})
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('La solicitud ha fallado');
                }
                return response.json();
            })
            .then(data => {
                if (!(data.colisiona) && !(data.fueraTablero)) {
                    // Rotamos figura widget
                    const rotatedWidget = {
                        id: clickedNode.id,      // id para identificar el widget
                        locked: true,           // inmutable por otros widgets
                        h: clickedNode.w,
                        w: clickedNode.h,
                        info: "rotated",
                    }

                    // Obtener el tipo de barco del widgetTarget
                    let shipType = widgetTarget.querySelector('img').alt;
                    
                    if (rotatedWidget.h > rotatedWidget.w) {
                        // Poner la imagen rotada
                        rotatedWidget.content = `<img src="${shipInfo[shipType].imgRotated}" alt="${shipInfo[shipType].name}";" />`;
                    } else {
                        // Poner la imagen normal
                        rotatedWidget.content = `<img src="${shipInfo[shipType].img}" alt="${shipInfo[shipType].name}";" />`;
                    }
                    if (widgetTarget) {   // Si no ha dado error
                        board.update(widgetTarget, rotatedWidget);
                        // actualizar tableroInical desde la base de datos
                        // getTablero(tableroInicial);
                        
                    }
                }
            })
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
                body: JSON.stringify({ nombreId: nombreIdCookie,  mazoHabilidades: skillQueue})
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
    }, [skillQueue, nombreIdCookie, tokenCookie]);


    return (
        <>
            <div className="fleet-page-container">
                <Navbar/>
                <div className="fleet-container">
                    <h1 className="fleet-banner-container">
                        Mi flota
                    </h1>
                    <div className="fleet-main-content-container">
                        <div className="grid-stack fleet-board" onClick={handleItemClick}></div>
                        <div className="ship-buttons-container">
                            <div className={`skill-button ${isSkillEnqueued("Mina") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => isSkillEnqueued("Mina") ? dequeueSkill("Mina") : enqueueSkill("Mina")} src={mineImg} alt="Mine" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${isSkillEnqueued("Teledirigido") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => isSkillEnqueued("Teledirigido") ? dequeueSkill("Teledirigido") : enqueueSkill("Teledirigido")} src={missileImg} alt="Missile" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${isSkillEnqueued("Rafaga") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => isSkillEnqueued("Rafaga") ? dequeueSkill("Rafaga") : enqueueSkill("Rafaga")} src={burstImg} alt="Burst" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${isSkillEnqueued("Sonar") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => isSkillEnqueued("Sonar") ? dequeueSkill("Sonar") : enqueueSkill("Sonar")} src={sonarImg} alt="Sonar" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${isSkillEnqueued("Recargado") ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => isSkillEnqueued("Recargado") ? dequeueSkill("Recargado") : enqueueSkill("Recargado")} src={torpedoImg} alt="Torpedo" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
