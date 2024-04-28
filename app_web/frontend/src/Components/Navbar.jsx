import React, { useState } from 'react';
import { Sidebar, Menu, MenuItem } from 'react-pro-sidebar'
import { useNavigate } from 'react-router-dom';
import battleshipImage from '../Images/bs_Logo.png';


export function Navbar() {
    const navigate = useNavigate();
    const [hovered, setHovered] = useState(false);

    const handleMouseEnter = () => {
        setHovered(true);
    };

    const handleMouseLeave = () => {
        setHovered(false);
    };

    // Estilos CSS para el texto cuando el cursor está encima
    const textStyleHovered = {
        color: '#FFFFFF', // Cambia el color del texto cuando el cursor está encima
        fontWeight: 'bold',
        cursor: 'pointer',
    };

    // Estilos CSS para el texto cuando el cursor no está encima
    const textStyle = {
        color: '#FFFFFF', // Color de texto predeterminado
        cursor: 'pointer',
    };

    return (
        // "stretch": altura de NavBar será igual al contenido de la derecha
        //<div style={{ display: "flex", alignItems: "stretch"}}>
        <div style={{ display: "flex", minHeight: "100vh"}}>
            <Sidebar 
                // Cambiar el color de fondo
                backgroundColor='#1D3461'
                // Modificar el ancho del sidebar
                width="auto"
                // Modificar el alto del sidebar
            >
                <img 
                    src={battleshipImage} 
                    alt="logo" 
                    width="100px" 
                    height="100px" 
                    onClick={() => navigate('/')}
                    onMouseEnter={handleMouseEnter}
                    onMouseLeave={handleMouseLeave}
                    style={{ filter: hovered ? 'brightness(120%)' : 'brightness(100%)' }}
                ></img>
                <center
                    onClick={() => navigate('/')}
                    onMouseEnter={handleMouseEnter}
                    onMouseLeave={handleMouseLeave}
                    style={hovered ? textStyleHovered : textStyle} // Aplica los estilos correspondientes según el estado del cursor
                > Battleship </center>
                <br></br>
                <Menu
                menuItemStyles={{
                    button: ({ level, active, disabled }) => {
                    // only apply styles on first level elements of the tree
                    if (level === 0)
                        return {
                            color: disabled ? undefined : '#ffffff',
                            backgroundColor: active ? undefined : '#1D3461',
                            '&:hover': {
                                backgroundColor: '#3C6EB1',
                            },
                        };
                    },
                }}>
                    <MenuItem onClick={() => navigate('/home')}>Home</MenuItem>
                    <MenuItem onClick={() => navigate('/fleet')}>Flota</MenuItem>
                    <MenuItem onClick={() => navigate('/settings')}>Ajustes</MenuItem>
                    <MenuItem onClick={() => navigate('/profile')}>Perfil</MenuItem>
                    <MenuItem onClick={() => navigate('/social')}>Social</MenuItem>
                    <MenuItem onClick={() => navigate('/register')}>Registo</MenuItem>
                    <MenuItem onClick={() => navigate('/')}>Login</MenuItem>
                </Menu>
            </Sidebar>
        </div>
    );
}