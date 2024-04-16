import { Navbar } from "../Components/Navbar";
import '../Styles/login-style.css';
import Cookies from 'universal-cookie';

const iniciarSesionURI = 'http://localhost:8080/perfil/iniciarSesion';

export function Login() {
    const handleSubmit = async (e) => {
        e.preventDefault(); // Previene el comportamiento por defecto del formulario

        const cookies = new Cookies();
        // Recopilando los datos del formulario
        const formData = new FormData(e.target);
        const data = {
            nombreId: formData.get('nombreId'),
            contraseña: formData.get('contraseña'),
            // Asegúrate de añadir el input de confirmación de contraseña en el formulario y aquí
        };

        // Creación de la solicitud fetch
        try {
            const response = await fetch(iniciarSesionURI, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const responseData = await response.json(); // Suponiendo que el backend devuelve JSON
            console.log('Respuesta del servidor:', responseData);
            cookies.remove('JWT');
            cookies.remove('nombreId');
            cookies.set('JWT', responseData['token'], {path: '/'});
            console.log('token:');
            console.log(responseData['token']);
            cookies.set('nombreId', responseData['perfilDevuelto']['nombreId'], {path: '/'});
            console.log('nombreId:');
            console.log(responseData['perfilDevuelto']['nombreId']);
            // Aquí puedes manejar la respuesta, como actualizar el estado del componente o redirigir al usuario
        } catch (error) {
            console.error('Error en la solicitud:', error);
        }
    };

//export function Login() {
    // const cookies = new Cookies();

    // async function handleSubmit(e) {
    //     const request = {
    //         method: 'POST',
    //         headers: { 'Content-Type': 'application/json' },
    //         body: JSON.stringify({
    //             nombreId: e.target[0].value,
    //             contraseña: e.target[1].value,
    //         })
    //     };

    //     //const response = await fetch(iniciarSesionURI, request);
    //     //const data = await response.json();
    //     try {
    //         console.log('try');
    //         const response = await fetch(iniciarSesionURI, request);
    //         if (!response.ok) {
    //             throw new Error('La respuesta de la red no fue ok');
    //         }
    //         const data = await response.json(); // Suponiendo que el servidor responde con JSON
    //         console.log('Respuesta del servidor:', data);
    //         // Aquí puedes continuar con el manejo de la respuesta
    //         cookies.remove('JWT');
    //         cookies.remove('nombreId');
    //         console.log('token:');
    //         console.log(data['token']);
    //         console.log('nombreId:');
    //         console.log(data['perfilDevuelto']['nombreId']);
    //         cookies.set('JWT', data['token'], {path: '/'});
    //         cookies.set('nombreId', data['perfilDevuelto']['nombreId'], {path: '/'});
    //     } catch (error) {
    //         console.error('Error durante la solicitud:', error);
    //     }
        // try {
        //     fetch(iniciarSesionURI, request)
        //     .then(response => {
        //         if (!response.ok) {
        //             throw new Error('La solicitud ha fallado');
        //         }
        //         return response.json();
        //     })
        //     .then(data => {
        //         cookies.remove('JWT');
        //         cookies.remove('nombreId');
        //         console.log('data:');
        //         console.log(data);
        //         console.log('token:');
        //         console.log(data['token']);
        //         console.log('nombreId:');
        //         console.log(data['perfilDevuelto']['nombreId']);
        //         cookies.set('JWT', data['token'], {path: '/'});
        //         cookies.set('nombreId', data['perfilDevuelto']['nombreId'], {path: '/'});
        //     })
        //     .catch(error => {
        //         console.error('Error:', error);
        //     });
        // } catch (error) {
        //     console.error('Error:', error);
        // }
    //}
    
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

/*
try {
            fetch(iniciarSesionURI, request)
            .then(response => {
                if (!response.ok) {
                    throw new Error('La solicitud ha fallado');
                }
                return response.json();
            })
            .then(data => {
                cookies.set('JWT', data['token'], {path: '/'});
                console.log(cookies.get('JWT'));
            })
            .catch(error => {
                console.error('Error:', error);
            });
        } catch (error) {
            console.error('Error:', error);
        }
*/