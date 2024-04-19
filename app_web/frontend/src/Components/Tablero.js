import React, { useEffect } from 'react';
import './Tablero.css';
import crossImg from '../Images/ingame/cross.png';
import '../Styles/game-style.css';

let crossList = [];

const Tablero = ({onCellClick}) => {
    const casillas = Array.from({ length: 100 }, (_, index) => index); // Array de 100 elementos

    const handleClick = (fila, columna) => {
        onCellClick(fila, columna)
    };
    
    const renderImage = (index) => {
        // Lógica para determinar si se debe mostrar una imagen en la casilla
        // Puedes usar el índice para acceder a los datos necesarios

        // Ejemplo de lógica:
        // Si el índice es par, mostrar una imagen
        // Si el índice es impar, no mostrar una imagen
        if (crossList.includes(index)) {
            return <img src={crossImg} alt="red cross" className="cross" />;
        }
        return null;
    };

    // ...

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
                >
                    {renderImage(index)}
                </div>
            ))}
        </div>
    );
};

export default Tablero;
export { crossList };