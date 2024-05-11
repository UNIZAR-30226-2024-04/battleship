import { useNavigate } from "react-router-dom";
import { Navbar } from "../Components/Navbar";
import '../Styles/login-style.css';
import Cookies from 'universal-cookie';

const iniciarSesionURI = 'http://localhost:8080/perfil/iniciarSesion';


export function Login() {

    let navigate = useNavigate();
    const handleSubmit = async (e) => {
        e.preventDefault(); // Previene el comportamiento por defecto del formulario

        const divError = document.querySelector(".login-body .login-error-msg span")
        divError.innerText = "";
        divError.style.color = "red";

        const cookies = new Cookies();
        const formData = new FormData(e.target);
        const data = {
            nombreId: formData.get('nombreId'),
            contraseña: formData.get('contraseña'),
        };

        try {
            const response = await fetch(iniciarSesionURI, {
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
            
            divError.innerText = "Sesión iniciada con éxito";
            divError.style.color = "green";

            const responseData = await response.json();
            console.log('Respuesta del servidor:', responseData);

            cookies.remove('JWT');
            cookies.remove('perfil');

            cookies.set('JWT', responseData['token'], {path: '/'});
            cookies.set('perfil', responseData['perfilDevuelto'], {path: '/'});

            navigate("/home");
        } catch (error) {
            console.error('Error en el login:', error);
        }
    };

    /*
                    <ToastContainer
                    position="top-right"
                    autoClose={5000}
                    hideProgressBar={false}
                    newestOnTop={false}
                    closeOnClick
                    rtl={false}
                    pauseOnFocusLoss
                    draggable
                    pauseOnHover
                />
    */
    return (
        <div className="login-page-container">
            <Navbar/>
            <div className="login-container">
                <div className="login-all-content">
                    <div className="login-banner-container">
                        <span>Iniciar sesión</span>
                    </div>
                    <form className="login-body" name="login" method="post" onSubmit={handleSubmit}>
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
                                required
                            ></input>
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
                                required
                            ></input>
                        </div>
                        <div className="login-apply">
                            <input type="submit" value="Iniciar sesión"></input>
                        </div>
                        <div className="login-error-msg">
                            <span></span>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    );
}
