import { Navbar } from "../Components/Navbar";
import '../Styles/style.css';
import GameDemoImg from '../Images/home-game-demo.png';

export function Home() {
    return (
        <div className="main-page-container">
            <Navbar/>
            <div className="home-main-container">
                <div className="home-main-content-container">
                    <img src={ GameDemoImg } />
                    <div className="home-main-content">
                        <h1 className="home-banner-container">
                            Juega a Hundir la Flota
                        </h1>
                        <button className="button-online-game">
                            <span> Jugar Online </span>
                        </button>
                        <button className="button-offline-game">
                            <span> Jugar Offline </span>
                        </button>
                    </div>
                </div>
                <div className="home-secondary-content">

                </div>
            </div>
        </div>
    );
}