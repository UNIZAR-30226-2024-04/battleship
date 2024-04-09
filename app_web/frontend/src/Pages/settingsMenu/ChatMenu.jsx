import React, {useState} from 'react';

const ChatMenu = () => {
    const [ingameChat, setIngameChat] = useState('');
    const [privateChat, setPrivateChat] = useState('');
    const [allowBadWords, setBadWords] = useState(false);

    const handleChange = (e) => {
        switch (e.target.name){
        case "selectAllowIngameChat":
            setIngameChat(e.target.value);
            break;
        case "selectAllowPrivateChat":
            setPrivateChat(e.target.value);
            break;
        default:
        }
    };

    const handleToggleActive = () => {
        setBadWords(!allowBadWords);
    };

    return (
        <>
            <form className="settings-passwd-body settings-menu-body" name="chatSettings" method="post" action="/backend/chat">
                <div className="settings-password-currentpasswd-header">
                    <span>Permitir chat en partida</span>
                </div>
                <div className="settings-password-currentpasswd-input">
                    <select name="allowIngameChat" onChange={handleChange}>
                        <option value='2'>Todos</option>
                        <option value='1'>Amigos</option>
                        <option value='0'>Nadie</option>
                    </select>
                </div>
                <div className="settings-password-newpasswd-header">
                    <span>Permitir chat privado</span>
                </div>
                <div className="settings-password-newpasswd-input">
                    <select name="allowPrivateChat" onChange={handleChange}>
                        <option value='2'>Todos</option>
                        <option value='1'>Amigos</option>
                        <option value='0'>Nadie</option>
                    </select>
                </div>
                <div className="settings-password-confirmpasswd-header">
                    <span>Filtrar lenguaje soez</span>
                </div>
                <div className="settings-password-confirmpasswd-input">
                    <input
                        type="checkbox"
                        name="badwords"
                        value={allowBadWords}
                        checked={allowBadWords}
                        onChange={handleToggleActive}
                    />
                    <input type="hidden" name="badwords" value="false"/>
                </div>
                <div className="settings-password-apply">
                    <input type="submit" value="Aplicar cambios"></input>
                </div>
            </form>
        </>
    )
}

export default ChatMenu;