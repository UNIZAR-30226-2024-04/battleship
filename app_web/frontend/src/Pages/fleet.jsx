import { useEffect, useState } from 'react';
import { Navbar } from "../Components/Navbar";
import { GridStack } from 'gridstack';
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

// Establecer la url de obtenerPerfil, moverBarcoInicial del backend
const urlObtenerPerfil = 'http://localhost:8080/perfil/obtenerUsuario';
const urlMoverBarcoInicial = 'http://localhost:8080/perfil/moverBarcoInicial';


function esBarcoHorizontal(barco) {
    return barco[0].i === barco[1].i;
}


export function Fleet() {    
    // Contiene el tamaño y nombre de los barcos a usar
    const shipInfo = {
        'Aircraft': { size: 5, name: "Aircraft", img: aircraftImg, imgRotated: aircraftImgRotated},
        'Bship': { size: 4, name: "Bship", img: bshipImg, imgRotated: bshipImgRotated},
        'Sub': { size: 3, name: "Sub", img: submarineImg, imgRotated: submarineImgRotated},
        'Destroy': { size: 3, name: "Destroy", img: destroyImg, imgRotated: destroyImgRotated},
        'Patrol': { size: 2, name: "Patrol", img: patrolImg, imgRotated: patrolImgRotated},
    };

    const skillInfo = {
        'Mine': { id: 1, name: "Mine", img: mineImg},
        'Missile': { id: 2, name: "Missile", img: missileImg},
        'Burst': { id: 3, name: "Burst", img: burstImg},
        'Sonar': { id: 4, name: "Sonar", img: sonarImg},
        'Torpedo': { id: 5, name: "Torpedo", img: torpedoImg},
    };

    // cola fifo para las skills de tamaño 3
    const [skillQueue, setSkillQueue] = useState([]); // Estado para la cola de habilidades

    // Función para agregar una skill a la cola
    const enqueueSkill = (skillId) => {
        if (!skillQueue.includes(skillId)) {
            setSkillQueue(prevQueue => [...prevQueue, skillId]);
            if (skillQueue.length >= 3) {
                setSkillQueue(prevQueue => prevQueue.slice(1)); // Eliminar el primer elemento si la cola excede el límite
            }
        }
        console.log("Skill queue: ", skillQueue);
    };

    const esSkillEnCola = (skillId) => {
        return skillQueue.includes(skillId);
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
    }, []);

    // Este efecto se ejecuta cuando el board está inicializado
    useEffect(() => {
        // Obtener el tablero inicial del perfil en la base de datos
        try {
            fetch(urlObtenerPerfil, {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json'
                },
                body: JSON.stringify({ nombreId: 'usuario1' })
            })
            .then(response => {
                if (!response.ok) {
                throw new Error('La solicitud ha fallado');
                }
                return response.json();
            })
            .then(data => {
                let tableroInicial = data.tableroInicial;
                // const tableroInicial = [
                //     [{ i: 1, j: 1 }, { i: 1, j: 2 }],
                //     [{ i: 7, j: 1 }, { i: 8, j: 1 }, { i: 9, j: 1 }],
                //     [{ i: 3, j: 10 }, { i: 4, j: 10 }, { i: 5, j: 10 }],
                //     [{ i: 3, j: 6 }, { i: 4, j: 6 }, { i: 5, j: 6 }, { i: 6, j: 6 }],
                //     [{ i: 10, j: 6 }, { i: 10, j: 7 }, { i: 10, j: 8 }, { i: 10, j: 9 }, { i: 10, j: 10 }]
                //   ];

                addNewWidgetPos(1, "Patrol", tableroInicial[0][0].j-1, tableroInicial[0][0].i-1, esBarcoHorizontal(tableroInicial[0]));
                addNewWidgetPos(2, "Destroy", tableroInicial[1][0].j-1, tableroInicial[1][0].i-1, esBarcoHorizontal(tableroInicial[1]));
                addNewWidgetPos(3, "Sub", tableroInicial[2][0].j-1, tableroInicial[2][0].i-1, esBarcoHorizontal(tableroInicial[2]));
                addNewWidgetPos(4, "Bship", tableroInicial[3][0].j-1, tableroInicial[3][0].i-1, esBarcoHorizontal(tableroInicial[3]));
                addNewWidgetPos(5, "Aircraft", tableroInicial[4][0].j-1, tableroInicial[4][0].i-1, esBarcoHorizontal(tableroInicial[4]));
                setCount(6);
                

                // fetch(urlMoverBarcoInicial, {
                //     method: 'POST',
                //     headers: {
                //     'Content-Type': 'application/json'
                //     },
                //     body: JSON.stringify({ nombreId: 'usuario1',  barcoId: 0, iProaNueva: , jProaNueva: , rotar: })
                // })
                // .then(response => {
                //     if (!response.ok) {
                //     throw new Error('La solicitud ha fallado');
                //     }
                //     return response.json();
                // })
                // .then(data => {
                //     let tableroInicial = data.tableroInicial;
                //      if (tableroInicial) {}

                // })



            })
            .catch(error => {
                console.error('Error:', error);
            });
        } catch (error) {
            console.error('Error:', error);
        }
    }, [board]);



    // Función que añade un elemento a la cuadrícula
    const addNewWidget = (ship) => {
        //const shipName = shipInfo[ship].name;
        const node = {
            id: String(count),      // id para identificar el widget
            locked: true,           // inmutable por otros widgets
            noResize: true,
            //content: `<div onClick={handleItemClick}>${shipName}</div>`,
            //content: '<img src={aircraftImg} />',
            // content: shipInfo[ship].name,
            content: `<img src="${shipInfo[ship].img}" alt="${shipInfo[ship].name}";" />`,
            //sizeToContent: true,
            x: Math.round((boardDimension - 1) * Math.random()),
            y: Math.round((boardDimension - 1) * Math.random()),
            w: shipInfo[ship].size,
            h: 1,
        };
        if (board) {    // El tablero está inicializado
            board.addWidget(node);   // Añadir widget a la cuadrícula
            setCount(prevCount => prevCount + 1); // Incrementar el contador
            
            // Debug
            //console.log(document.getElementsByClassName('gs-id-0'));
            //console.log(node)
            //console.log(board['engine']['nodes'])
        }
    };

    // Función que añade un elemento a la cuadrícula
    const addNewWidgetPos = (id, ship, x, y, esHorizontal) => {
        //const shipName = shipInfo[ship].name;
        const node = {
            id: id,      // id para identificar el widget
            locked: true,           // inmutable por otros widgets
            //content: `<div onClick={handleItemClick}>${shipName}</div>`,
            //content: '<img src={aircraftImg} />',
            // content: shipInfo[ship].name,
            content: `<img src="${shipInfo[ship].img}" alt="${shipInfo[ship].name}";" />`,
            //sizeToContent: true,
            x: x,
            y: y,
            w: shipInfo[ship].size,
            h: 1,
        };
        if (!esHorizontal) {
            node.content = `<img src="${shipInfo[ship].imgRotated}" alt="${shipInfo[ship].name}";" />`;
            node.w = 1;
            node.h = shipInfo[ship].size;
        }
        if (board) {    // El tablero está inicializado
            board.addWidget(node);   // Añadir widget a la cuadrícula
            setCount(prevCount => prevCount + 1); // Incrementar el contador
            
            // Debug
            //console.log(document.getElementsByClassName('gs-id-0'));
            //console.log(node)
            //console.log(board['engine']['nodes'])
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
                console.log(clickedNode);
            }
        }
    
        if (clickedNode) {
            // Rotamos figura widget
            const rotatedWidget = {
                h: clickedNode.w,
                w: clickedNode.h,
            }

            const wantedAtribute = "[gs-id=\"" + clickedNode.id + "\"]";
            const widgetTarget = document.querySelector(wantedAtribute);

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
                board.update(widgetTarget, rotatedWidget)
            }
            
            /*
            // Rotamos contenido
            let contenido = elemento[index].querySelector('.grid-stack-item-content');
            contenido.style.transform = 'rotate(90deg)';
            */
        }
    };


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
                            <div className={`skill-button ${esSkillEnCola(1) ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => enqueueSkill(1)} src={mineImg} alt="Mine" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${esSkillEnCola(2) ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => enqueueSkill(2)} src={missileImg} alt="Missile" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${esSkillEnCola(3) ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => enqueueSkill(3)} src={burstImg} alt="Burst" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${esSkillEnCola(4) ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => enqueueSkill(4)} src={sonarImg} alt="Sonar" />
                            </div>
                            <br></br>
                            <div className={`skill-button ${esSkillEnCola(5) ? 'skill-button-selected' : ''}`}>
                                <img onClick={() => enqueueSkill(5)} src={torpedoImg} alt="Torpedo" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
