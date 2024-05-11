import React, { useState } from 'react';


const TablonMenu = () => {
    const [selectedCountry, setSelectedCountry] = useState('');

    const handleChange = (event) => {
        setSelectedCountry(event.target.value);
    };

    const updateTablon = () => {
        const feed = document.querySelector('.profile-activity-content');
        // peticion a "obtenerPublicaciones"
    }

    return (
        <>
            <div className="social-tablon-container">
                <div className="profile-activity-header">
                    <span>ACTIVIDAD RECIENTE</span>
                </div>
                <div className="profile-activity-content">
                    <div className="profile-activity-info">
                        <span>Has vencido a Snatilla ganando 120 puntos.</span>
                        <span>21:00  16 May 2024</span>
                    </div>
                    <div className="profile-activity-info">
                        <span>Has vencido a Carlitos ganando 120 puntos.</span>
                        <span>21:00  16 May 2024</span>
                    </div>
                    <div className="profile-activity-info">
                        <span>Has vencido a Dlad ganando 120 puntos.</span>
                        <span>21:00  16 May 2024</span>
                    </div>
                    <div className="profile-activity-info">
                        <span>Has vencido a MT ganando 120 puntos.</span>
                        <span>21:00  16 May 2024</span>
                    </div>
                </div>
            </div>
        </>
    )
}

export default TablonMenu;