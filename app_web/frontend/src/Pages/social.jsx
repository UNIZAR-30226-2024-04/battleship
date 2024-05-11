import React, { useState, useEffect } from 'react'
import { Navbar } from "../Components/Navbar";
import socialIcon from '../Images/social_icon.png';
import '../Styles/social-style.css';

import TablonMenu from './socialMenu/TablonMenu';
import SolicitudesMenu from './socialMenu/SolicitudesMenu';
import ChatsMenu from './socialMenu/ChatsMenu';
import AmigosMenu from './socialMenu/AmigosMenu';


export function Social() {  
    const [selectedMenu, setSelectedMenu] = useState('Tablon');


    const handleMenuClick = (menu) => {
        setSelectedMenu(menu);
    };

    // Función para determinar DINÁMICAMENTE si el botón ha sido seleccionado
    const handleSelectedButton = (menu) => {
        return selectedMenu === menu ?
                'social-sidebar-button social-selected-botton-effect' : 'social-sidebar-button';
    };

    // Renderiza el menú correspondiente, por default es "Tablón"
    const renderMenu = () => {
        switch (selectedMenu) {
            case 'Tablon':
                return <TablonMenu />;
            case 'Solicitudes':
                return <SolicitudesMenu />;
            case 'Chats':
                return <ChatsMenu />;
            case 'Amigos':
                return <AmigosMenu />;
            default:
                return <TablonMenu />;
        }
    };

    return (
        <div className="social-page-container">
            <Navbar/>
            <div className="social-container">
                <div className="social-all-content">
                    <div className="social-banner-container">
                        <img src={socialIcon} />
                        <span>Social</span>
                    </div>
                    <div className="social-main-content">
                        <div className="social-sidebar">
                            <button className={handleSelectedButton('Tablon')}
                                    onClick={() => handleMenuClick('Tablon')}>Tablon</button>
                            <button className={handleSelectedButton('Amigos')}
                                    onClick={() => handleMenuClick('Amigos')}>Amigos</button>
                            <button className={handleSelectedButton('Solicitudes')}
                                    onClick={() => handleMenuClick('Solicitudes')}>Solicitudes</button>
                            <button className={handleSelectedButton('Chats')}
                                    onClick={() => handleMenuClick('Chats')}>Chats</button>
                        </div>
                        <div className="social-menus">
                            {renderMenu()}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}