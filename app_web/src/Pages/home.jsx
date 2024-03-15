import { Navbar } from "../Components/Navbar";
import '../Styles/style.css';
import '../Styles/home-style.css';
import GameDemoImg from '../Images/home-game-demo.png';

export function Home() {
    return (
        <div className="main-page-container">
            <Navbar/>
            <div className="home-container">
                <div className="home-main-content-container">
                    <div className="home-main-img-container">
                        <img src={ GameDemoImg } />
                    </div>
                    <div className="home-main-content">
                        <h1 className="home-banner-container">
                            Juega a Hundir la Flota
                        </h1>
                        <button className="home-button">
                            <span> Jugar Online </span>
                        </button>
                        <button className="home-button">
                            <span> Jugar Offline </span>
                        </button>
                    </div>
                </div>
                <div className="home-secondary-content-container">

                </div>
            </div>
        </div>
    );
}