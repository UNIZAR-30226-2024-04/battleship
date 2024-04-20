import React, { useEffect } from 'react';
import './Tablero.css';
import '../Styles/game-style.css';

const Tablero = ({id, onCellClick, clickable}) => {
    const casillas = Array.from({ length: 100 }, (_, index) => index); // Array de 100 elementos

    const handleClick = (fila, columna) => {
        onCellClick(fila, columna)
    };

    let retVal;
    if (clickable) {        // Tablero del rival
        retVal = <div id={id} className="tablero">
                    {casillas.map((index) => (
                        <div
                            key={index}
                            location={index}
                            className="casilla casillaColorear"
                            onClick={() => {
                                const fila = Math.floor(index / 10) + 1; // Calcula la fila
                                const columna = (index % 10) + 1; // Calcula la columna
                                handleClick(fila, columna);
                            }}
                        />
                    ))}
                </div>
    } else {        // Mi tablero
        retVal = <div id={id} className="tablero">
                    {casillas.map((index) => (
                        <div
                            key={index}
                            location={index}
                            className="casilla"
                        />
                    ))}
                </div>
    }
    return retVal;

};

export default Tablero;