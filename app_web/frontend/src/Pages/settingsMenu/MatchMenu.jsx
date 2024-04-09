import React, { useState } from 'react';

const MatchMenu = () => {

    const [allowRivalName, setRivalName] = useState(false);
    const [allowRivalElo, setRivalElo] = useState(false);
    const [allowRivalEmotes, setRivalEmotes] = useState(false);

    const handleToggleActive = (e) => {
        switch (e.target.name){
        case "rivalName":
                setRivalName(!allowRivalName);
                break;
        case "rivalEmotes":
            setRivalEmotes(!allowRivalEmotes);    
            break;
        case "rivalElo":
            setRivalElo(!allowRivalElo);
            break;
        default:
        }
    };

    return (
        <>
            <form className="settings-match-body settings-menu-body" name="matchsettings" method="post" action="/backend/match">
                <div className="settings-match-rivalname-header">
                    <span>Ver nombre del rival</span>
                </div>
                <div className="settings-match-rivalname-input">
                    <input
                        type="checkbox"
                        name="rivalName"
                        value={allowRivalName}
                        checked={allowRivalName}
                        onChange={handleToggleActive}
                    />
                    <input type="hidden" name="rivalName" value="false"/>
                </div>
                <div className="settings-match-rivalelo-header">
                    <span>Ver elo del rival</span>
                </div>
                <div className="settings-match-rivalelo-input">
                    <input
                        type="checkbox"
                        name="rivalElo"
                        value={allowRivalElo}
                        checked={allowRivalElo}
                        onChange={handleToggleActive}
                    />
                    <input type="hidden" name="rivalElo" value="false"/>
                </div>
                <div className="settings-match-rivalemotes-header">
                    <span>Ver emoticonos en partida</span>
                </div>
                <div className="settings-match-rivalemotes-input">
                    <input
                        type="checkbox"
                        name="rivalEmotes"
                        value={allowRivalEmotes}
                        checked={allowRivalEmotes}
                        onChange={handleToggleActive}
                    />
                    <input type="hidden" name="rivalEmotes" value="false"/>
                </div>
                <div className="settings-match-apply">
                    <input type="submit" value="Aplicar cambios"></input>
                </div>
            </form>
        </>
    )
}

export default MatchMenu;