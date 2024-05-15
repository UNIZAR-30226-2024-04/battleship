import React, { useState } from 'react';
import countriesData from '../../Resources/countries.json';
import Flag from 'react-world-flags';
import Cookies from 'universal-cookie';
import info from '../../Resources/info.json';
import '../../Styles/home-style.css';


const urlEliminarUsuario = info['serverAddress'] + '/perfil/eliminarUsuario';
const ModificarDatosPersonalesURI = info["serverAddress"] + 'perfil/modificarDatosPersonales';

const ProfileMenu = () => {
    const cookies = new Cookies();

    const [selectedCountry, setSelectedCountry] = useState('');
    const [username, setUsername] = useState('');
    const [email, setEmail] = useState('');
    const [about, setAbout] = useState('');
    
    const tokenCookie = cookies.get('JWT');
    const nombreIdCookie = cookies.get('perfil')['nombreId'];
    
    const [currentPassword, setCurrentPassword] = useState('');
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');

    const handleChanges = async () => {
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
                body: JSON.stringify({nombreId: nombreIdCookie, contraseña: newPassword, correo: email}),
            });
            if (!response.ok) {
                throw new Error('Hubo un problema al cambiar los datos personales');
            }
            alert('Contraseña cambiada exitosamente');
            // Aquí puedes realizar cualquier otra acción después de cambiar la contraseña, como redireccionar a otra página o actualizar el estado de la aplicación
        } catch (error) {
            console.error('Error al cambiar los datos personales:', error);
            alert('Hubo un error al cambiar los datos personales');
        }
    };


    const handleChangeEmail = (event) => {
        setEmail(event.target.value);
    };


    const handleDeleteUser = async () => {
        const confirmDelete = window.confirm('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.');

        if (confirmDelete) {
            try {
                const response = await fetch(urlEliminarUsuario, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'authorization': tokenCookie
                    },
                    body: JSON.stringify({ nombreId: nombreIdCookie })
                });

                if (!response.ok) {
                    throw new Error('Hubo un problema al eliminar el usuario');
                }

                alert('Usuario eliminado correctamente');
                // Aquí puedes añadir cualquier lógica adicional como redirigir al usuario
            } catch (error) {
                console.error('Error al eliminar el usuario:', error);
                alert('Hubo un error al eliminar el usuario');
            }
        }
    };


    const profileCookie = cookies.get('perfil');

    return (
        <>
            <div className="settings-profile-header">
            </div>
            <form className="settings-profile-body settings-menu-body" name="userdata" onSubmit={handleChanges}>
                <div className="settings-profile-email-header">
                    <span>Cambiar email</span>
                </div>
                <div className="settings-profile-email-input">
                    <input
                        name="email"
                        autoComplete="on"
                        placeholder="Introduzca su correo electrónico..."
                        type="email"
                        size="30"
                        value={email}
                        onChange={handleChangeEmail}
                    />
                </div>
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
                <div className="center">
                    <button className="home-button" onClick={handleChanges}> 
                        <span> Aplicar cambios </span></button>
                </div>
                <div className="center">
                    <button className="delete-button" onClick={handleDeleteUser}> 
                        <span> Eliminar usuario </span></button>
                </div>
            </form>
        </>
    );
};

export default ProfileMenu;