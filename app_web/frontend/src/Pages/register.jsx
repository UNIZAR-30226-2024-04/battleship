import { Navbar } from "../Components/Navbar";
import '../Styles/register-style.css';

export function Register() {
    return (
        <div className="register-page-container">
            <Navbar/>
            <div className="register-container">
                <div className="register-all-content">
                    <div className="register-banner-container">
                        <span>Battleship</span>
                    </div>
                    <form className="register-body" name="register" method="post" action="/backend/endpoint">
                        <div className="register-username-header">
                            <span>Nombre de usuario</span>
                        </div>
                        <div className="register-username-input">
                            <input
                                name="username"
                                autoComplete="off"
                                placeholder="Introduzca su nombre de usuario..."
                                type="text"
                                size="30"
                            >        
                            </input>
                        </div>
                        <div className="register-email-header">
                            <span>Correo electrónico</span>
                        </div>
                        <div className="register-email-input">
                            <input
                                name="email"
                                autoComplete="on"
                                placeholder="Introduzca su correo electrónico..."
                                type="email"
                                size="30"
                            ></input>
                        </div>
                        <div className="register-password-header">
                            <span>Contraseña</span>
                        </div>
                        <div className="register-password-input">
                            <input
                                name="password"
                                autoComplete="off"
                                placeholder="Introduzca su contraseña..."
                                type="text"
                                size="30"
                            >
                            </input>
                        </div>
                        <div className="register-password-confirm-header">
                            <span>Confirmar contraseña</span>
                        </div>
                        <div className="register-password-confirm-input">
                            <input
                                name="password-confirm"
                                autoComplete="off"
                                placeholder="Introduzca su contraseña..."
                                type="text"
                                size="30"
                            >        
                            </input>
                        </div>
                        <div className="settings-profile-body-apply">
                            <input type="submit" value="Registrarse"></input>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    );
}