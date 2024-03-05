import './App.css';
import { HashRouter as Router, Routes, Route } from 'react-router-dom';
import { Home }  from './Pages/home';
import { Fleet } from './Pages/fleet';
import { Profile } from './Pages/profile';
import { Settings } from './Pages/settings';
import { Social } from './Pages/social';
import { Layout } from './Layout';
import { Navbar } from "./Components/Navbar";


function App() {
  return (
    <Router>
      <Routes>
        <Route element={<Layout/>}>
        <Route path="/" element={<Home/>}/>
        <Route path="/fleet" element={<Fleet/>}/>
        <Route path="/profile" element={<Profile/>}/>
        <Route path="/settings" element={<Settings/>}/>
        <Route path="/social" element={<Social/>}/>
        </Route>
      </Routes>
    </Router>
  )
}


/*{ <Router>
      <Routes>
          <Route path="/home" element={<Home/>}/>
          <Route path="/fleet" element={<Fleet/>}/>
          <Route path="/profile" element={<Profile/>}/>
          <Route path="/settings" element={<Settings/>}/>
          <Route path="/social" element={<Social/>}/>
      </Routes>
      <Navbar/>
    </Router> }*/

export default App;
