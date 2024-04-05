import React from 'react';

const ChatMenu = () => {
    return (
        <>
            <div className="settings-profile-header">
                <div className="settings-profile-img"> FOTO </div>
                <div className="settings-profile-name">
                    <span>Butanero Putero</span>
                </div>
            </div>
            <form className="settings-profile-body" name="userdata" method="post" action="/backend/">
                <div className="settings-profile-body-user-header">
                    <span>Nombre de usuario</span>
                </div>
                <div className="settings-profile-body-user-input">
                    <input
                        name="username"
                        autoComplete="off"
                        placeholder="Introduzca su nombre de usuario..."
                        type="text"
                        size="30"
                    >        
                    </input>
                </div>
                <div className="settings-profile-body-user-header">
                    <span>Correo electrónico</span>
                </div>
                <div className="settings-profile-body-user-input">
                    <input
                        name="email"
                        autoComplete="on"
                        placeholder="Introduzca su correo electrónico..."
                        type="email"
                        size="30"
                    ></input>
                </div>
                <div className="settings-profile-body-country-header">
                    <span>País</span>
                </div>
                <div className="settings-profile-body-country-input">
                    <select>
                        <option value="spain">España</option>
                        <option value="fool">Cataluña</option>
                        <option value="benched">Andorra</option>
                    </select>
                </div>
                <div className="settings-profile-body-about-header">
                    <span>Acerca de mí</span>
                </div>
                <div className="settings-profile-body-about-input">
                    <textarea
                        name="about"
                        placeholder="Introduzca su descripción..."
                        cols="28"
                        rows="4"
                    ></textarea>
                </div>
                <div className="settings-profile-body-apply">
                    <input type="submit" value="Realizar cambios"></input>
                </div>
            </form>
        </>
    )
}

export default ChatMenu;