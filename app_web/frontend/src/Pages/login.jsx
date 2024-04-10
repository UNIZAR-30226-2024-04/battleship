import { Navbar } from "../Components/Navbar";
import '../Styles/login-style.css';

export function Login() {
    return (
        <div className="login-page-container">
            <Navbar/>
            <div className="login-container">
                <div className="login-all-content">
                    <div className="login-banner-container">
                        <span>Iniciar sesión</span>
                    </div>
                    <form className="login-body" name="login" method="post" action="/backend/endpoint">
                        <div className="login-username-header login-header">
                            <span>Email o usuario</span>
                        </div>
                        <div className="login-user-input">
                            <input
                                name="user"
                                autoComplete="off"
                                placeholder="Introduzca su email o usuario..."
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
                                name="password"
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