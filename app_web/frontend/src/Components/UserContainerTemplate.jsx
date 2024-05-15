import React from 'react';
import './UserContainerTemplate.css';

const UserContainerTemplate = ({ imageSrc, name, clickFunction, buttons }) => {
    return (
        <div className="user-template-container" onClick={clickFunction ? () => clickFunction(name) : null}>
            <img src={imageSrc} alt="Avatar" className="user-template-image" />
            <div className="user-template-info">
                <span className="user-template-name">{name}</span>
            </div>
            <div className="user-template-buttons">
                {buttons.map((button, index) => (
                    <button
                        key={index}
                        className='user-template-button'
                        onClick={(e) => {
                            e.stopPropagation(); // Evitar que el clic en el botón dispare el clickFunction del contenedor
                            button.onClick(name);
                        }}
                    >
                        {button.text}
                    </button>
                ))}
            </div>
        </div>
    );
}

export default UserContainerTemplate;