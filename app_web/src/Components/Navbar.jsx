import "./Navbar.css";
import React from 'react';
import { Sidebar, Menu, MenuItem } from 'react-pro-sidebar'
import { useNavigate } from 'react-router-dom';


export function Navbar() {
    const navigate = useNavigate();
    return (
        <Sidebar>
            <Menu>
                <MenuItem onClick={() => navigate('/')}>Home</MenuItem>
                <MenuItem onClick={() => navigate('/fleet')}>Flota</MenuItem>
                <MenuItem onClick={() => navigate('/settings')}>Ajustes</MenuItem>
                <MenuItem onClick={() => navigate('/profile')}>Perfil</MenuItem>
                <MenuItem onClick={() => navigate('/social')}>Social</MenuItem>
            </Menu>
        </Sidebar>
    );
}

/*
    const navigate = useNavigate();
    return (
        <div className="navBar">
            <button onClick={() => navigate('/')}>Jugar</button>
            <button onClick={() => navigate('/fleet')}> Flota</button>
            <button onClick={() => navigate('/settings')}>Ajustes</button>
            <button onClick={() => navigate('/profile')}>Perfil</button>
            <button onClick={() => navigate('/social')}>Social</button>
        </div>
    );
*/


/*
<div className="navBar">
    <NavLink to="/">Jugar</NavLink>
    <NavLink to="/fleet">Flota</NavLink>
    <NavLink to="/settings">Ajustes</NavLink>
    <NavLink to="/profile">Perfil</NavLink>
    <NavLink to="/social">Social</NavLink>
</div>
*/