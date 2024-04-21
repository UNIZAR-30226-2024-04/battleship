import React, {useState, useEffect} from 'react';
import Cookies from 'universal-cookie';
import { Navbar } from "../Components/Navbar";
import Flag from 'react-world-flags'
import '../Styles/profile-style.css';

const urlObtenerEstadisticas = 'http://localhost:8080/perfil/obtenerUsuario';

const Profile = () => {
    const cookies = new Cookies();

    const [profileData, setprofileData] = useState({
        uname: '',
        country: '',
        exp: '',
        elo: '',
        sunkenShips: '',
        lostShips: '',
        nMatches: '',
        nWins: '',
        winrate: '',
        hitShots: '',
        missShots: '',
    });

    useEffect(() => {
        const fetchUserData = async () => {
            try {
                const profileCookie = cookies.get('perfil');

                const response = await fetch(urlObtenerEstadisticas, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ nombreId: profileCookie['nombreId'] })
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('La solicitud de obtener estadísticas ha fallado');
                    }
                    return response.json();
                })
                .then(data => {
                    console.log(data);
                    
                    setprofileData({
                        uname: profileCookie['nombreId'] || '0',
                        country: profileCookie['pais'] || 'Nada',
                        exp: data['puntosExperiencia'] || '0',
                        elo: data['trofeos'] || '0',
                        sunkenShips: data['barcosHundidos'] || '0',
                        lostShips: data['barcosPerdidos'] || '0',
                        nMatches: data['partidasJugadas'] || '0',
                        nWins: data['partidasGanadas'] || '0',
                        winrate: 100 * (data['partidasGanadas'] / data['partidasJugadas']) || '0',
                        hitShots: data['disparosAcertados'] || '0',
                        missShots: data['disparosFallados'] || '0',
                    });
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            } catch (error) {
                console.error('Error:', error);
            }
        };

        fetchUserData();
    }, []);


    return (
        <div className="profile-page-container">
            <Navbar/>
            <div className="profile-container">
                <div className="profile-all-content">
                    <div className="profile-main-content">
                        <div className="profile-banner-content">
                            <div className="profile-banner-img">
                                Imagen
                            </div>
                            <div className="profile-banner-info">
                                <div className="profile-banner-first-row">
                                    <span>{profileData.uname}</span>
                                    <Flag code={ "ES" } height="25em" fallback={ <span>Nada</span> }/>
                                </div>
                                <div className="profile-banner-second-row">
                                    <span>Puntos de experiencia: {profileData.exp}</span>
                                </div>
                            </div>
                        </div>
                        <div className="profile-activity-container">
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
                    </div>
                    <div className="profile-sidebar-container">
                        <div className="profile-sidebar-stats-container">
                            <div className="profile-sidebar-stats-header">
                                <span>ESTADÍSTICAS</span>
                            </div>
                            <div className="profile-sidebar-stats-content">
                                <div className="profile-sidebar-stat-elo">
                                    <span className="profile-sidebar-stat-header">Elo</span>
                                    <span className="profile-sidebar-stat-value">{profileData.elo}</span>
                                </div>
                                <div className="profile-sidebar-stat-matches">
                                    <span className="profile-sidebar-stat-header">Partidas</span>
                                    <span className="profile-sidebar-stat-value">{profileData.nMatches}</span>
                                </div>
                                <div className="profile-sidebar-stat-win">
                                    <span className="profile-sidebar-stat-header">Victorias</span>
                                    <span className="profile-sidebar-stat-value">{profileData.nWins}</span>
                                </div>
                                <div className="profile-sidebar-stat-winrate">
                                    <span className="profile-sidebar-stat-header">Tasa de victorias</span>
                                    <span className="profile-sidebar-stat-value">{profileData.winrate} %</span>
                                </div>
                                <div className="profile-sidebar-stat-sunkenships">
                                    <span className="profile-sidebar-stat-header">Barcos hundidos</span>
                                    <span className="profile-sidebar-stat-value">{profileData.sunkenShips}</span>
                                </div>
                                <div className="profile-sidebar-stat-lostships">
                                    <span className="profile-sidebar-stat-header">Barcos perdidos</span>
                                    <span className="profile-sidebar-stat-value">{profileData.lostShips}</span>
                                </div>
                                <div className="profile-sidebar-stat-hitshots">
                                    <span className="profile-sidebar-stat-header">Disparos acertados</span>
                                    <span className="profile-sidebar-stat-value">{profileData.hitShots}</span>
                                </div>
                                <div className="profile-sidebar-stat-missshots">
                                    <span className="profile-sidebar-stat-header">Disparos fallados</span>
                                    <span className="profile-sidebar-stat-value">{profileData.missShots}</span>
                                </div>
                            </div>
                        </div>
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
                    </div>
                </div>
            </div>
        </div>
    );
}

export default Profile;