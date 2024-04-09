import React, {useState} from 'react';

const GraphicsMenu = () => {
    const [oceanEffects, setOceanEffects] = useState('');
    const [climateEffects, setClimateEffects] = useState('');
    const [boatEffects, setBoatEffects] = useState('');

    const handleChange = (e) => {
        switch (e.target.name){
        case "oceanState":
            setOceanEffects(e.target.value);    
            break;
        case "climateState":
            setClimateEffects(e.target.value);    
            break;
        case "boatEffects":
            setBoatEffects(e.target.value);    
            break;
        default:
        }
    };

    return (
        <>
            <form className="settings-passwd-body settings-menu-body" name="soundSettings" method="post" action="/backend/sound">
                <div className="settings-password-currentpasswd-header">
                    <span>Apariencia del océano</span>
                </div>
                <div className="settings-password-currentpasswd-input">
                    <select name="oceanEffects" onChange={handleChange}>
                        <option value='0'>En movimiento</option>
                        <option value='1'>Estático</option>
                    </select>
                </div>
                <div className="settings-password-newpasswd-header">
                    <span>Efecto clima</span>
                </div>
                <div className="settings-password-newpasswd-input">
                    <select name="climateEffects" onChange={handleChange}>
                        <option value='0'>En movimiento</option>
                        <option value='1'>Estático</option>
                    </select>
                </div>
                <div className="settings-password-confirmpasswd-header">
                    <span>Efectos barco tocado y hundido</span>
                </div>
                <div className="settings-password-confirmpasswd-input">
                    <select name="boatEffects" onChange={handleChange}>
                        <option value='0'>Simple</option>
                        <option value='1'>Complejo</option>
                    </select>
                </div>
                <div className="settings-password-apply">
                    <input type="submit" value="Aplicar cambios"></input>
                </div>
            </form>
        </>
    )
}

export default GraphicsMenu;