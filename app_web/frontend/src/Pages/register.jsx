import { Navbar } from "../Components/Navbar";
import '../Styles/register-style.css';

const registrarUsuarioURI = "http://localhost:8080/perfil/registrarUsuario";

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

    const handleSubmit = async (e) => {
        e.preventDefault(); // Previene el comportamiento por defecto del formulario
        
        const divError = document.querySelector(".register-body .register-error-msg span")
        divError.innerText = "";
        divError.style.color = "red";
                
        const formData = new FormData(e.target);

        if (formData.get('contraseña') !== formData.get('confirmContraseña')) {
            console.error('Las contraseñas no coinciden');
            divError.innerText="Las contraseñas no coinciden";
            return;
        }

        const data = {
            nombreId: formData.get('nombreId'),
            contraseña: formData.get('contraseña'),
            correo: formData.get('correo'),
        };

        try {
            const response = await fetch(registrarUsuarioURI, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) {
                console.error("Respuesta backend:", response);
                const errorMessage = await response.text();     // Mostramos mensaje enviado por backend
                divError.innerText = errorMessage;
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            divError.innerText = "Usuario registrado con éxito";
            divError.style.color = "green";

            const responseData = await response.json();
            console.log('Respuesta del servidor:', responseData);

        } catch (error) {
            console.error('Error en el registro:', error);
        }
    };

    return (
        <div className="register-page-container">
            <Navbar/>
            <div className="register-container">
                <div className="register-all-content">
                    <div className="register-banner-container">
                        <span>Registrarse</span>
                    </div>
                    <form className="register-body" name="register" method="post" onSubmit={handleSubmit}>
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
                                required
                            ></input>
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
                                required
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
                                pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}"
                                title="La contraseña debe tener al menos 8 caracteres,
                                        1 mayúscula, 1 minúscula, 1 número y 1 carácter
                                        especial"
                                required
                            ></input>
                        </div>
                        <div className="register-password-confirm-header register-header">
                            <span>Confirmar contraseña</span>
                        </div>
                        <div className="register-password-confirm-input">
                            <input
                                name="confirmContraseña"
                                autoComplete="off"
                                placeholder="Introduzca su contraseña de nuevo..."
                                type="password"
                                size="30"
                                required
                            ></input>
                        </div>
                        <div className="register-apply">
                            <input type="submit" value="Registrarse"></input>
                        </div>
                        <div className="register-error-msg">
                            <span></span>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    );
}