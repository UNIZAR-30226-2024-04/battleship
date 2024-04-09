import { useState } from 'react'
import { Navbar } from "../Components/Navbar";
import settingsIcon from '../Images/settings_icon.png';
import '../Styles/settings-style.css';
import ProfileMenu from './settingsMenu/ProfileMenu';
import PasswordMenu from './settingsMenu/PasswordMenu';
import ChatMenu from './settingsMenu/ChatMenu';
import SoundMenu from './settingsMenu/SoundMenu';
import GraphicsMenu from './settingsMenu/GraphicsMenu';
import MatchMenu from './settingsMenu/MatchMenu';
import HelpMenu from './settingsMenu/HelpMenu';

/*
TODO:
    -Añadir form a los input
    -Quitar apartado contraseña

*/

export function Settings() {
    const [selectedMenu, setSelectedMenu] = useState('Profile');
    const [menuTitle, setMenuTitle] = useState('Profile');

    const handleMenuClick = (menu) => {
        setMenuTitle(menu);
        setSelectedMenu(menu);
    };

    const renderMenu = () => {
        switch (selectedMenu) {
            case 'Profile':
                return <ProfileMenu />;
            case 'Password':
                return <PasswordMenu />;
            case 'Chat':
                return <ChatMenu />;
            case 'Sound':
                return <SoundMenu />;
            case 'Graphics':
                return <GraphicsMenu />;
            case 'Match':
                return <MatchMenu />;
            case 'Help':
                return <HelpMenu />;
            default:
                return <ProfileMenu />;
        }
    };


    return (
        <div className="settings-page-container">
            <Navbar/>
            <div className="settings-container">
                <div className="settings-all-content">
                    <div className="settings-banner-container">
                        <img src={settingsIcon} />
                        <span>{menuTitle}</span>
                    </div>
                    <div className="settings-main-content">
                        <div className="settings-sidebar">
                            <button onClick={() => handleMenuClick('Profile')}>Perfil</button>
                            <button onClick={() => handleMenuClick('Password')}>Contraseña</button>
                            <button onClick={() => handleMenuClick('Chat')}>Chat</button>
                            <button onClick={() => handleMenuClick('Sound')}>Sonido</button>
                            <button onClick={() => handleMenuClick('Graphics')}>Gráficos</button>
                            <button onClick={() => handleMenuClick('Match')}>Partida</button>
                            <button onClick={() => handleMenuClick('Help')}>Ayuda</button>
                        </div>
                        <div className="setings-menus">
                            {renderMenu()}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
