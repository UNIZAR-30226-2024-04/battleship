import { useEffect, useState } from 'react';
import { Navbar } from "../Components/Navbar";
import { GridStack } from 'gridstack';
import '../Styles/fleet-style.css';
import 'gridstack/dist/gridstack.min.css';
import 'gridstack/dist/gridstack-extra.min.css';
import aircraftImg from '../Images/aircraft.png';
import destroyImg from '../Images/destroyer.png';
import patrolImg from '../Images/patrol.png';


export function Fleet() {    
    // Contiene el tamaño y nombre de los barcos a usar
    const shipInfo = {
        'Aircraft': { size: 5, name: "Portaviones", img: aircraftImg},
        'Bship': { size: 4, name: "Acorazado"},
        'Sub': { size: 3, name: "Submarino"},
        'Destroy': { size: 3, name: "Destructor", img: destroyImg},
        'Patrol': { size: 2, name: "Patrullero", img: patrolImg},
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
            cellHeight: "80px", // Establecer la altura de cada celda en 50px
        });
        setBoard(board); // Almacenar la instancia de GridStack en el estado
    }, []);


    // Función que añade un elemento a la cuadrícula
    const addNewWidget = (ship) => {
        //const shipName = shipInfo[ship].name;
        const node = {
            id: String(count),      // id para identificar el widget
            locked: true,           // inmutable por otros widgets
            //content: `<div onClick={handleItemClick}>${shipName}</div>`,
            //content: '<img src={aircraftImg} />',
            // content: shipInfo[ship].name,
            content: `<img src="${shipInfo[ship].img}" alt="${shipInfo[ship].name}" />`, // Mostrar imagen del barco
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
        <div className="fleet-page-container">
            <Navbar/>
            <div className="fleet-container">
                <h1 className="fleet-banner-container">
                    Mi flota
                </h1>
                <div className="fleet-main-content-container">
                    <div className="grid-stack fleet-board" onClick={handleItemClick}></div>
                </div>
            </div>
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
    );
}
