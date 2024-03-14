import './App.css';
import { HashRouter as Router, Routes, Route } from 'react-router-dom';
import { Home }  from './Pages/home';
import { Fleet } from './Pages/fleet';
import { Profile } from './Pages/profile';
import { Settings } from './Pages/settings';
import { Social } from './Pages/social';
import { Navbar } from "./Components/Navbar";


function App() {
  return (
    <div>
      <Router>
        <Routes>
          <Route path="/" element={<Home/>}/>
          <Route path="/fleet" element={<Fleet/>}/>
          <Route path="/profile" element={<Profile/>}/>
          <Route path="/settings" element={<Settings/>}/>
          <Route path="/social" element={<Social/>}/>
        </Routes>
      </Router>
    </div>
  )
}

export default App;
