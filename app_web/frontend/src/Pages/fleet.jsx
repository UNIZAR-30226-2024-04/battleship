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
            removable: true,            // eliminar widgets si se sacan del tablero
            acceptWidgets: true,        // acepta widgets de otros tableros
            disableResize: true,        // quita icono de resize en cada widget
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
                addNewWidgetPos("Patrol", tableroInicial[0][0].j-1, tableroInicial[0][0].i-1, esBarcoHorizontal(tableroInicial[0]));
                addNewWidgetPos("Destroy", tableroInicial[1][0].j-1, tableroInicial[1][0].i-1, esBarcoHorizontal(tableroInicial[1]));
                addNewWidgetPos("Sub", tableroInicial[2][0].j-1, tableroInicial[2][0].i-1, esBarcoHorizontal(tableroInicial[2]));
                addNewWidgetPos("Bship", tableroInicial[3][0].j-1, tableroInicial[3][0].i-1, esBarcoHorizontal(tableroInicial[3]));
                addNewWidgetPos("Aircraft", tableroInicial[4][0].j-1, tableroInicial[4][0].i-1, esBarcoHorizontal(tableroInicial[4]));
                

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
            content: `<img src="${shipInfo[ship].img}" alt="${shipInfo[ship].name}" style="width: 100%; height: 100%; overflow: hidden;" />`, // Mostrar imagen del barco con tamaño personalizado
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
    const addNewWidgetPos = (ship, x, y, esHorizontal) => {
        //const shipName = shipInfo[ship].name;
        const node = {
            id: String(count),      // id para identificar el widget
            locked: true,           // inmutable por otros widgets
            //content: `<div onClick={handleItemClick}>${shipName}</div>`,
            //content: '<img src={aircraftImg} />',
            // content: shipInfo[ship].name,
            content: `<img src="${shipInfo[ship].img}" alt="${shipInfo[ship].name}" style="width: 100%; height: 100%; overflow: hidden;" />`, // Mostrar imagen del barco con tamaño personalizado
            //sizeToContent: true,
            x: x,
            y: y,
            w: shipInfo[ship].size,
            h: 1,
        };
        if (!esHorizontal) {
            node.content = `<img src="${shipInfo[ship].imgRotated}" alt="${shipInfo[ship].name}" style="width: 100%; height: 100%;" />`;
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
                rotatedWidget.content = `<img src="${shipInfo[shipType].imgRotated}" alt="${shipInfo[shipType].name}" style="width: 100%; height: 100%; overflow: hidden;" />`;
            } else {
                // Poner la imagen normal
                rotatedWidget.content = `<img src="${shipInfo[shipType].img}" alt="${shipInfo[shipType].name}" style="width: 100%; height: 100%; overflow: hidden;" />`;
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
                            <div className="ship-buttons">
                                <button onClick={() => addNewWidget("Aircraft")}>Añadir portaviones</button>
                            </div>
                            <div className="ship-buttons">
                                <button onClick={() => addNewWidget("Bship")}>Añadir acorazado</button>
                            </div>
                            <div className="ship-buttons">
                                <button onClick={() => addNewWidget("Sub")}>Añadir submarino</button>
                            </div>
                            <div className="ship-buttons">
                                <button onClick={() => addNewWidget("Destroy")}>Añadir destructor</button>
                            </div>
                            <div className="ship-buttons">
                                <button onClick={() => addNewWidget("Patrol")}>Añadir patrullera</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
