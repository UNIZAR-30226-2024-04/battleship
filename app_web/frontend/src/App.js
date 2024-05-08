import './App.css';
import { HashRouter as Router, Routes, Route } from 'react-router-dom';
import { Home }  from './Pages/home';
import { Fleet } from './Pages/fleet';
import  Profile from './Pages/profile';
import { Settings } from './Pages/settings';
import { Social } from './Pages/social';
import { Register } from './Pages/register';
import { Login } from './Pages/login';
import { Game } from './Pages/game';
import { GameMulti } from './Pages/gameMulti';
import { SocketProvider } from './Contexts/SocketContext';



function App() {
  return (
    <>
      <Router>
        <SocketProvider>
          <Routes>
            <Route path="/" element={<Login/>}/>
            <Route path="/game" element={<Game/>}/>
            <Route path="/gameMulti" element={<GameMulti/>}/>
            <Route path="/fleet" element={<Fleet/>}/>
            <Route path="/profile" element={<Profile/>}/>
            <Route path="/settings" element={<Settings/>}/>
            <Route path="/social" element={<Social/>}/>
            <Route path="/register" element={<Register/>}/>
            <Route path="/home" element={<Home/>}/>
          </Routes>
        </SocketProvider>
      </Router>
    </>
  )
}

export default App;
