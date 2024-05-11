import React from 'react';
import './UserContainerTemplate.css';

const UserContainerTemplate = ({imageSrc, name, clickFunction, buttonText, buttonFunc}) => {

    return (
        <div className="user-template-container"
             onClick={clickFunction ? () => clickFunction(name) : null}>
            <img src={imageSrc} alt="Avatar" className="user-template-image" />
            <div className="user-template-info">
                <span className="user-template-name">{name}</span>
            </div>
            <button className='user-template-button'
                    onClick={buttonFunc ? () => buttonFunc(name) : null}>
                    {buttonText}
            </button>
        </div>
    );
}

export default UserContainerTemplate;
