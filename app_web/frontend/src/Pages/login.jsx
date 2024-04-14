import { Navbar } from "../Components/Navbar";
import '../Styles/login-style.css';
import Cookies from 'universal-cookie';

const iniciarSesionURI = 'http://localhost:8080/perfil/iniciarSesion';



export function Login() {
    const cookies = new Cookies();

    async function handleSubmit(e) {
        const request = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                nombreId: e.target[0].value,
                contraseña: e.target[1].value,
            })
        };
        const response = await fetch(iniciarSesionURI, request);
        const data = await response.json();
        cookies.set('JWT', data['token'], {path: '/'});
        console.log(cookies.get('JWT'));
    };

    return (
        <div className="login-page-container">
            <Navbar/>
            <div className="login-container">
                <div className="login-all-content">
                    <div className="login-banner-container">
                        <span>Iniciar sesión</span>
                    </div>
                    <form className="login-body" onSubmit={handleSubmit}>
                        <div className="login-username-header login-header">
                            <span>Usuario</span>
                        </div>
                        <div className="login-user-input">
                            <input
                                name="nombreId"
                                autoComplete="off"
                                placeholder="Introduzca su usuario..."
                                type="text"
                                size="30"
                            >        
                            </input>
                        </div>
                        <div className="login-password-header login-header">
                            <span>Contraseña</span>
                        </div>
                        <div className="login-password-input">
                            <input
                                name="contraseña"
                                autoComplete="off"
                                placeholder="Introduzca su contraseña..."
                                type="password"
                                size="30"
                            >
                            </input>
                        </div>
                        <div className="login-apply">
                            <input type="submit" value="Iniciar sesión"></input>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    );
}