import { Navbar } from "../Components/Navbar";
import '../Styles/style.css';

export function Settings() {
    return (
        <div className="main-page-container">
        <Navbar/>
        <div className="settings-main-container">
            <h1 className="settings-banner-container">
                This is the settings page
            </h1>

        </div>
    </div>
    );
}