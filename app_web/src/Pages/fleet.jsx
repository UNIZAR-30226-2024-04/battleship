import { Navbar } from "../Components/Navbar";
import '../Styles/style.css';

export function Fleet() {
    return (
        <div className="main-page-container">
            <Navbar/>
            <div className="fleet-main-container">
                <h1 className="fleet-banner-container">
                    This is the fleet page
                </h1>

            </div>
        </div>
    );
}