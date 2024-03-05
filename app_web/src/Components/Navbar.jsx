import React/*, { useEffect }*/ from 'react';
import { Link, useNavigate } from 'react-router-dom';


export function Navbar() {
    return <div className="navBar">
            <Link to="/">
                <button>Jugar</button>
            </Link>
            <Link to="/Fleet">
                <button>Flota</button>
            </Link>
            <Link to="/Settings">
                <button>Ajustes</button>
            </Link>
            <Link to="/Profile">
                <button>Perfil</button>
            </Link>
            <Link to="/Social">
                <button>Social</button>
            </Link>
        </div>
}

    /*
    const navigate = useNavigate();

    const handleNavigation = (destiny) => {
        navigate("/" + destiny);
        console.log(destiny)
    };

    // Usamos 
    useEffect(() => {
        handleNavigation("home");
    }, [navigate]);
    
    const handleNavigationClick = (destiny) => {
        navigate("/" + destiny);
    }
    
    return (
        <div className="navBar">
        <button onClick={handleNavigation("home")}>Jugar</button>
        <button onClick={handleNavigation("fleet")}>Flota</button>
        <button onClick={handleNavigation("settings")}>Ajustes</button>
        <button onClick={handleNavigation("profile")}>Perfil</button>
        <button onClick={handleNavigation("social")}>Social</button>
        </div>    
    );
    */

/*
            <Link to="/">
                <button>Jugar</button>
            </Link>
            <Link to="/Fleet">
                <button>Flota</button>
            </Link>
            <Link to="/Settings">
                <button>Ajustes</button>
            </Link>
            <Link to="/Profile">
                <button>Perfil</button>
            </Link>
            <Link to="/Social">
                <button>Social</button>
            </Link>
*/