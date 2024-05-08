// import settingsIcon from '../Images/settings_icon.png';
// import '../Styles/settings-style.css';
// import TablonMenu from './socialMenu/TablonMenu';
// import SolicitudesMenu from './socialMenu/SolicitudesMenu';
// import ChatsMenu from './socialMenu/ChatsMenu';
// import AmigosMenu from './socialMenu/AmigosMenu';


// export function Settings() {
//     const [selectedMenu, setSelectedMenu] = useState('Tablon');
//     const [menuTitle, setMenuTitle] = useState('Tablon');

//     const handleMenuClick = (menu) => {
//         setMenuTitle(menu);
//         setSelectedMenu(menu);
//     };


//     const renderMenu = () => {
//         switch (selectedMenu) {
//             case 'Tablon':
//                 return <TablonMenu />;
//             case 'Solicitudes':
//                 return <SolicitudesMenu />;
//             case 'Chats':
//                 return <ChatsMenu />;
//             case 'Amigos':
//                 return <AmigosMenu />;
//             default:
//                 return <TablonMenu />;
//         }
//     };


//     return (
//         <div className="settings-page-container">
//             <Navbar/>
//             <div className="settings-container">
//                 <div className="settings-all-content">
//                     <div className="settings-banner-container">
//                         <img src={settingsIcon} />
//                         <span>{menuTitle}</span>
//                     </div>
//                     <div className="settings-main-content">
//                         <div className="settings-sidebar">
//                             <button onClick={() => handleMenuClick('Tablon')}>Tablon</button>
//                             <button onClick={() => handleMenuClick('Amigos')}>Amigos</button>
//                             <button onClick={() => handleMenuClick('Chats')}>Chats</button>
//                             <button onClick={() => handleMenuClick('Solicitudes')}>Solicitudes</button>
//                         </div>
//                         <div className="setings-menus">
//                             {renderMenu()}
//                         </div>
//                     </div>
//                 </div>
//             </div>
//         </div>
//     );
// }