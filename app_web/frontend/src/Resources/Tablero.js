import React from 'react';
import './Tablero.css';

const Tablero = ({onCellClick}) => {
    const casillas = Array.from({ length: 100 }, (_, index) => index); // Array de 100 elementos

    const handleClick = (fila, columna) => {
        onCellClick(fila, columna)
    };

    return (
        <div id="tablero">
            {casillas.map((index) => (
                <div
                    key={index}
                    className="casilla"
                    onClick={() => {
                        const fila = Math.floor(index / 10) + 1; // Calcula la fila
                        const columna = (index % 10) + 1; // Calcula la columna
                        handleClick(fila, columna);
                    }}
                />
            ))}
        </div>
    );
};

export default Tablero;
