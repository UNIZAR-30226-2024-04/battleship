import React, { useState } from 'react';
import countriesData from '../../Resources/countries.json';
import Flag from 'react-world-flags';
import Cookies from 'universal-cookie';

const TablonMenu = () => {
    const [selectedCountry, setSelectedCountry] = useState('');

    const handleChange = (event) => {
        setSelectedCountry(event.target.value);
    };

    const cookies = new Cookies();
    const profileCookie = cookies.get('perfil');

    return (
        <>
            <div className="profile-sidebar-friends-container">
                <div className="profile-sidebar-friend-info">
                    <div className="profile-sidebar-friend-img">
                    </div>
                    <div className="profile-sidebar-friend-name">
                        <span>Snatilla</span>
                    </div>
                    <div className="profile-sidebar-friend-flag">
                        <Flag code={ "FR" } height="15em" fallback={ <span>Nada</span> }/>
                    </div>
                </div>
                <div className="profile-sidebar-friend-info">
                    <div className="profile-sidebar-friend-img">
                    </div>
                    <div className="profile-sidebar-friend-name">
                        <span>Dlad</span>
                    </div>
                    <div className="profile-sidebar-friend-flag">
                        <Flag code={ "USA" } height="15em" fallback={ <span>Nada</span> }/>
                    </div>
                </div>
                <div className="profile-sidebar-friend-info">
                    <div className="profile-sidebar-friend-img">
                    </div>
                    <div className="profile-sidebar-friend-name">
                        <span>MT</span>
                    </div>
                    <div className="profile-sidebar-friend-flag">
                        <Flag code={ "CAN" } height="15em" fallback={ <span>Nada</span> }/>
                    </div>
                </div>
            </div>
        </>
    )
}

export default TablonMenu;