import './App.css';
import { HashRouter as Router, Routes, Route } from 'react-router-dom';
import { Home }  from './Pages/home';
import { Fleet } from './Pages/fleet';
import { Profile } from './Pages/profile';
import { Settings } from './Pages/settings';
import { Social } from './Pages/social';
import { Register } from './Pages/register';
import { Login } from './Pages/login';


function App() {
  return (
    <>
      <Router>
        <Routes>
          <Route path="/" element={<Home/>}/>
          <Route path="/fleet" element={<Fleet/>}/>
          <Route path="/profile" element={<Profile/>}/>
          <Route path="/settings" element={<Settings/>}/>
          <Route path="/social" element={<Social/>}/>
          <Route path="/register" element={<Register/>}/>
          <Route path="/login" element={<Login/>}/>
        </Routes>
      </Router>
    </>
  )
}

export default App;
