import React from 'react';
import { useState } from 'react';
import Cookies from 'universal-cookie';
import info from '../../Resources/info';
import '../../Styles/home-style.css';


const ModificarDatosPersonalesURI = info["serverAddress"] + 'perfil/modificarDatosPersonales';


const PasswordMenu = () => {
    const cookies = new Cookies();

    // Obtener el token y nombreId del usuario
    const tokenCookie = cookies.get('JWT');
    const nombreIdCookie = cookies.get('perfil')['nombreId'];

    const [currentPassword, setCurrentPassword] = useState('');
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');

    const handleChangePassword = async () => {
        try {
            if (newPassword !== confirmPassword) {
                alert('Las contraseñas no coinciden');
                return;
            }

            const response = await fetch(ModificarDatosPersonalesURI, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'authorization': tokenCookie
                },
                body: JSON.stringify({nombreId: nombreIdCookie, contraseña: newPassword}),
            });
            if (!response.ok) {
                throw new Error('Hubo un problema al cambiar la contraseña');
            }
            alert('Contraseña cambiada exitosamente');
            // Aquí puedes realizar cualquier otra acción después de cambiar la contraseña, como redireccionar a otra página o actualizar el estado de la aplicación
        } catch (error) {
            console.error('Error al cambiar la contraseña:', error);
            alert('Hubo un error al cambiar la contraseña');
        }
    };

    return (
        <>
            <div className="settings-passwd-body settings-menu-body">
                {/* <div className="settings-password-currentpasswd-header">
                    <span>Contraseña actual</span>
                </div>
                <div className="settings-password-currentpasswd-input">
                    <input
                        name="currentpasswd"
                        autoComplete="off"
                        placeholder="Introduzca su contraseña actual..."
                        type="password"
                        size="30"
                        value={currentPassword}
                        onChange={(e) => setCurrentPassword(e.target.value)}
                    />
                </div> */}
                <div className="settings-password-newpasswd-header">
                    <span>Nueva contraseña</span>
                </div>
                <div className="settings-password-newpasswd-input">
                    <input
                        name="newpasswd"
                        autoComplete="off"
                        placeholder="Introduzca su nueva contraseña..."
                        type="password"
                        size="30"
                        value={newPassword}
                        onChange={(e) => setNewPassword(e.target.value)}
                    />
                </div>
                <div className="settings-password-confirmpasswd-header">
                    <span>Confirmar nueva contraseña</span>
                </div>
                <div className="settings-password-confirmpasswd-input">
                    <input
                        name="confirmpasswd"
                        autoComplete="off"
                        placeholder="Confirme su nueva contraseña..."
                        type="password"
                        size="30"
                        value={confirmPassword}
                        onChange={(e) => setConfirmPassword(e.target.value)}
                    />
                </div>
                <div>
                    <button className="home-button" onClick={handleChangePassword}> 
                        <span> Cambiar contraseña </span></button>
                </div>
            </div>
        </>
    );
};


export default PasswordMenu;