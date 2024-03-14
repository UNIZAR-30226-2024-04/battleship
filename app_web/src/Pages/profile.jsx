import { Navbar } from "../Components/Navbar";
import '../Styles/style.css';

export function Profile() {
    return (
        <div className="main-page-container">
            <Navbar/>
            <div className="profile-main-container">
                <h1 className="profile-banner-container">
                    This is the profile page
                </h1>
            </div>
        </div>
    );
}