import { Navbar } from "../Components/Navbar";
import '../Styles/register-style.css';


/* Confirmar contraseña
<input
    name="password-confirm"
    autoComplete="off"
    placeholder="Introduzca su contraseña..."
    type="password"
    size="30"
>        
</input>
*/


export function Register() {

    const handleSubmit = (e) => {
        
    }

    return (
        <div className="register-page-container">
            <Navbar/>
            <div className="register-container">
                <div className="register-all-content">
                    <div className="register-banner-container">
                        <span>Registrarse</span>
                    </div>
                    <form className="register-body" name="register" method="post"
                          action="http://localhost:8080/perfil/registrarUsuario"
                          onSubmit={handleSubmit}>
                        <div className="register-username-header register-header">
                            <span>Nombre de usuario</span>
                        </div>
                        <div className="register-username-input">
                            <input
                                name="nombreId"
                                autoComplete="off"
                                placeholder="Introduzca su nombre de usuario..."
                                type="text"
                                size="30"
                            >        
                            </input>
                        </div>
                        <div className="register-email-header register-header">
                            <span>Correo electrónico</span>
                        </div>
                        <div className="register-email-input">
                            <input
                                name="correo"
                                autoComplete="on"
                                placeholder="Introduzca su correo electrónico..."
                                type="email"
                                size="30"
                            ></input>
                        </div>
                        <div className="register-password-header register-header">
                            <span>Contraseña</span>
                        </div>
                        <div className="register-password-input">
                            <input
                                name="contraseña"
                                autoComplete="off"
                                placeholder="Introduzca su contraseña..."
                                type="password"
                                size="30"
                            >
                            </input>
                        </div>
                        <div className="register-password-confirm-header register-header">
                            <span>Confirmar contraseña</span>
                        </div>
                        <div className="register-password-confirm-input">
                            
                        </div>
                        <div className="register-apply">
                            <input type="submit" value="Registrarse"></input>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    );
}