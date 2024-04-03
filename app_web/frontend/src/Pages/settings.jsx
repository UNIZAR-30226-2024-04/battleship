import { Navbar } from "../Components/Navbar";
import settingsIcon from '../Images/settings_icon.png';
import '../Styles/settings-style.css';

/*
TODO:
    -Añadir form a los input
    -Quitar apartado contraseña

*/
export function Settings() {
    return (
        <div className="settings-page-container">
            <Navbar/>
            <div className="settings-container">
                <div className="settings-all-content">
                    <div className="settings-banner-container">
                        <img src={settingsIcon} />
                        <span>This is the settings page</span>
                    </div>
                    <div className="settings-main-content">
                        <div className="settings-sidebar">
                            <button>Perfil</button>
                            <button>Contraseña</button>
                            <button>Chat</button>
                            <button>Sonido</button>
                            <button>Gráficos</button>
                            <button>Partida</button>
                            <button>Ayuda</button>
                        </div>
                        <div className="setings-menus">
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
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
