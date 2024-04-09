import React, {useState} from 'react';

const SoundMenu = () => {
    const [allowSound, setSound] = useState(false);
    const [allowMusic, setMusic] = useState(false);
    const [allowSFX, setSFX] = useState(false);

    const handleToggleActive = (e) => {
        switch (e.target.name){
        case "allowSound":
            setSound(!allowSound);
            break;
        case "allowMusic":
            setMusic(!allowMusic);    
            break;
        case "allowSFX":
            setSFX(!allowSFX);    
            break;
        default:
        }
    };

    return (
        <>
            <form className="settings-passwd-body settings-menu-body" name="soundSettings" method="post" action="/backend/sound">
                <div className="settings-password-currentpasswd-header">
                    <span>Activar sonido</span>
                </div>
                <div className="settings-password-currentpasswd-input">
                    <input
                        type="checkbox"
                        name="allowSound"
                        value={allowSound}
                        checked={allowSound}
                        onChange={handleToggleActive}
                    />  
                    <input type="hidden" name="allowSound" value="false"/>
                </div>
                <div className="settings-password-newpasswd-header">
                    <span>Activar música</span>
                </div>
                <div className="settings-password-newpasswd-input">
                    <input
                        type="checkbox"
                        name="allowMusic"
                        value={allowMusic}
                        checked={allowMusic}
                        onChange={handleToggleActive}
                    />
                    <input type="hidden" name="allowMusic" value="false"/>
                </div>
                <div className="settings-password-confirmpasswd-header">
                    <span>Activar efectos de sonido</span>
                </div>
                <div className="settings-password-confirmpasswd-input">
                    <input
                        type="checkbox"
                        name="allowSFX"
                        value={allowSFX}
                        checked={allowSFX}
                        onChange={handleToggleActive}
                    />
                    <input type="hidden" name="allowSFX" value="false"/>
                </div>
                <div className="settings-password-apply">
                    <input type="submit" value="Aplicar cambios"></input>
                </div>
            </form>
        </>
    )
}

export default SoundMenu;