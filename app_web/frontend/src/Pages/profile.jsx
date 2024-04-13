import { Navbar } from "../Components/Navbar";
import Flag from 'react-world-flags'
import '../Styles/profile-style.css';

export function Profile() {
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
                                    <span>Butanero Putero</span>
                                    <Flag code={ "ES" } height="25em" fallback={ <span>Nada</span> }/>
                                </div>
                                <div className="profile-banner-second-row">
                                    <span>Butanero de oficio putero por vicio</span>
                                </div>
                            </div>
                        </div>
                        <div className="profile-activity-container">
                            <div className="profile-activity-header">
                                <span>ACTIVIDAD RECIENTE</span>
                            </div>
                            <div className="profile-activity-content">
                                <div className="profile-activity-info">
                                    <span>Has vencido a Nanosecso ganando 120 puntos.</span>
                                    <span>21:00  16 May 2024</span>
                                </div>
                                <div className="profile-activity-info">
                                    <span>Has vencido a Nanosecso ganando 120 puntos.</span>
                                    <span>21:00  16 May 2024</span>
                                </div>
                                <div className="profile-activity-info">
                                    <span>Has vencido a Nanosecso ganando 120 puntos.</span>
                                    <span>21:00  16 May 2024</span>
                                </div>
                                <div className="profile-activity-info">
                                    <span>Has vencido a Nanosecso ganando 120 puntos.</span>
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
                                    <span className="profile-sidebar-stat-value">1800</span>
                                </div>
                                <div className="profile-sidebar-stat-matches">
                                    <span className="profile-sidebar-stat-header">Partidas</span>
                                    <span className="profile-sidebar-stat-value">143</span>
                                </div>
                                <div className="profile-sidebar-stat-win">
                                    <span className="profile-sidebar-stat-header">Victorias</span>
                                    <span className="profile-sidebar-stat-value">100</span>
                                </div>
                                <div className="profile-sidebar-stat-loss">
                                    <span className="profile-sidebar-stat-header">Derrotas</span>
                                    <span className="profile-sidebar-stat-value">43</span>
                                </div>
                                <div className="profile-sidebar-stat-sunkenships">
                                    <span className="profile-sidebar-stat-header">Barcos hundidos</span>
                                    <span className="profile-sidebar-stat-value">524</span>
                                </div>
                                <div className="profile-sidebar-stat-winrate">
                                    <span className="profile-sidebar-stat-header">Ratio de victorias</span>
                                    <span className="profile-sidebar-stat-value">52%</span>
                                </div>
                                <div className="profile-sidebar-stat-ability">
                                    <span className="profile-sidebar-stat-header">Habilidad favorita</span>
                                    <span className="profile-sidebar-stat-value">Misil</span>
                                </div>
                            </div>
                        </div>
                        <div className="profile-sidebar-friends-container">
                            <div className="profile-sidebar-friend-info">
                                <div className="profile-sidebar-friend-img">
                                </div>
                                <div className="profile-sidebar-friend-name">
                                    <span>Nanosecso</span>
                                </div>
                                <div className="profile-sidebar-friend-flag">
                                    <Flag code={ "ES" } height="15em" fallback={ <span>Nada</span> }/>
                                </div>
                            </div>
                            <div className="profile-sidebar-friend-info">
                                <div className="profile-sidebar-friend-img">
                                </div>
                                <div className="profile-sidebar-friend-name">
                                    <span>Nanosecso</span>
                                </div>
                                <div className="profile-sidebar-friend-flag">
                                    <Flag code={ "ES" } height="15em" fallback={ <span>Nada</span> }/>
                                </div>
                            </div>
                            <div className="profile-sidebar-friend-info">
                                <div className="profile-sidebar-friend-img">
                                </div>
                                <div className="profile-sidebar-friend-name">
                                    <span>Nanosecso</span>
                                </div>
                                <div className="profile-sidebar-friend-flag">
                                    <Flag code={ "ES" } height="15em" fallback={ <span>Nada</span> }/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}