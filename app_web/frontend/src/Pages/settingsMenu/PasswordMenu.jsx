import React from 'react';

const PasswordMenu = () => {
    return (
        <>
            <form className="settings-passwd-body settings-menu-body" name="changepasswd" method="post" action="/backend/password">
                <div className="settings-password-currentpasswd-header">
                    <span>Contraseña actual</span>
                </div>
                <div className="settings-password-currentpasswd-input">
                    <input
                        name="currentpasswd"
                        autoComplete="off"
                        placeholder="Introduzca su contraseña actual..."
                        type="password"
                        size="30"
                    >        
                    </input>
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
                    ></input>
                </div>
                <div className="settings-password-confirmpasswd-header">
                    <span>Confirmar nueva contraseña</span>
                </div>
                <div className="settings-password-confirmpasswd-input">
                    <input
                        name="confirmpasswd"
                        autoComplete="off"
                        placeholder="Introduzca su nueva contraseña..."
                        type="password"
                        size="30"
                    ></input>
                </div>
                <div className="settings-password-apply">
                    <input type="submit" value="Cambiar contraseña"></input>
                </div>
            </form>
        </>
    )
}

export default PasswordMenu;