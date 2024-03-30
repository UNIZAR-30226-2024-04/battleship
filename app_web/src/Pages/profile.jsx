import { Navbar } from "../Components/Navbar";

export function Profile() {
    return (
        <div className="home-page-container">
            <Navbar/>
            <div className="profile-main-container">
                <h1 className="profile-banner-container">
                    This is the profile page
                </h1>
            </div>
        </div>
    );
}