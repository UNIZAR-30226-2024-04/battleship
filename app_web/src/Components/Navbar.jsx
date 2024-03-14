
import React from 'react';
import { Sidebar, Menu, MenuItem } from 'react-pro-sidebar'
import { useNavigate } from 'react-router-dom';
import battleshipImage from '../Images/bs_Logo.png';


export function Navbar() {
    const navigate = useNavigate();
    return (
        <div style={{ display: "flex", height: "100vh" }}>
            <Sidebar 
            // Cambiar el color de fondo
            style={{backgroundColor: '#1D3461'}}
            // Modificar el ancho del sidebar
            width="auto"
            // Modificar el alto del sidebar
            
            >
                <img src={battleshipImage} alt="logo" width="100px" height="100px" onClick={() => navigate('/')}></img>
                <center onClick={() => navigate('/')}>Battleship</center>
                <br></br>
                <Menu
                menuItemStyles={{
                    button: ({ level, active, disabled }) => {
                    // only apply styles on first level elements of the tree
                    if (level === 0)
                        return {
                            color: disabled ? undefined : '#ffffff',
                        };
                    },
                }}>
                    <MenuItem onClick={() => navigate('/')}>Home</MenuItem>
                    <MenuItem onClick={() => navigate('/fleet')}>Flota</MenuItem>
                    <MenuItem onClick={() => navigate('/settings')}>Ajustes</MenuItem>
                    <MenuItem onClick={() => navigate('/profile')}>Perfil</MenuItem>
                    <MenuItem onClick={() => navigate('/social')}>Social</MenuItem>
                </Menu>
            </Sidebar>
        </div>
    );
}