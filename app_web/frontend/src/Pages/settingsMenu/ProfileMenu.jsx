import React, { useState } from 'react';
import countriesData from '../../Resources/countries.json';
import Flag from 'react-world-flags'

const ProfileMenu = () => {
    const [selectedCountry, setSelectedCountry] = useState('');

    const handleChange = (event) => {
        setSelectedCountry(event.target.value);
    };

    return (
        <>
            <div className="settings-profile-header">
                <div className="settings-profile-img">
                    <Flag code={ selectedCountry } height="auto" fallback={ <span>Nada</span> }/>
                </div>
                <div className="settings-profile-name">
                    <span>Butanero Putero</span>
                </div>
            </div>
            <form className="settings-profile-body settings-menu-body" name="userdata" method="post" action="/backend/">
                <div className="settings-profile-user-header">
                    <span>Nombre de usuario</span>
                </div>
                <div className="settings-profile-user-input">
                    <input
                        name="username"
                        autoComplete="off"
                        placeholder="Introduzca su nombre de usuario..."
                        type="text"
                        size="30"
                    >        
                    </input>
                </div>
                <div className="settings-profile-email-header">
                    <span>Correo electrónico</span>
                </div>
                <div className="settings-profile-email-input">
                    <input
                        name="email"
                        autoComplete="on"
                        placeholder="Introduzca su correo electrónico..."
                        type="email"
                        size="30"
                    ></input>
                </div>
                <div className="settings-profile-country-header">
                    <span>País</span>
                </div>
                <div className="settings-profile-country-input">
                    <select onChange={handleChange}>
                        <option value=''>Seleccionar</option>
                        {countriesData.map(country => (
                        <option key={country.iso2} value={country.iso2}>
                            {country.nameES}
                        </option>
                        ))}
                    </select>
                    <input type="hidden" name="country" value={selectedCountry} />
                </div>
                <div className="settings-profile-about-header">
                    <span>Acerca de mí</span>
                </div>
                <div className="settings-profile-about-input">
                    <textarea
                        name="about"
                        placeholder="Introduzca su descripción..."
                        cols="28"
                        rows="4"
                    ></textarea>
                </div>
                <div className="settings-profile-apply">
                    <input type="submit" value="Aplicar cambios"></input>
                </div>
            </form>
        </>
    )
}

export default ProfileMenu;