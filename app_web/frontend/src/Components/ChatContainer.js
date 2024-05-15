import React, { useEffect, useState, useRef } from 'react'
import socketIO from "socket.io-client";
import ChatBoxReciever, { ChatBoxSender } from './ChatBox';
import InputText from './InputText';
import info from '../Resources/info';

const urlChat = info['serverAddress'] + '/chat';
const urlObtenerChat = urlChat + '/obtenerChat';
const urlEnviarMensaje = urlChat + '/enviarMensaje';


// dirChat es \partidaidPartida o los id de los dos jugadores ("\chatid1id2" con id1<id2) en caso de chat privado
export default function ChatContainer(dirChat, idMiNombre, idSuNombre) { 
  
    let socketio  = socketIO(info['serverAddress'])
    const socketChat = socketio.connect(dirChat);
    const [chats , setChats] = useState([])
    const [user, setUser] = useState(null);
    setUser(idMiNombre);
    const avatar = localStorage.getItem('avatar')
    const messagesEndRef = useRef(null)
    const scrollToBottom = () => {
      messagesEndRef.current?.scrollIntoView({ behavior: "smooth" })
    }    

    useEffect(() => {
      scrollToBottom()
    }, [chats])

    useEffect(()=> {
        socketio.on('chat', senderChats => {
            setChats(senderChats)
        })
    })
    
    function loadChatsFromMongoDB() {
        fetch(urlObtenerChat, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ nombreId1: idMiNombre, nombreId2: idSuNombre })
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor obtenerChat:', response);
                throw new Error('Obtener chat ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor obtenerChat:', data);
            setChats(data.chat || []);
        })
        .catch(error => {
            console.error('Error al obtener el chat:', error);
        });
    }
    
    useEffect(() => {
        loadChatsFromMongoDB();
    }, []);

    function enviarMensajeMongo(mensaje) {
        fetch(urlEnviarMensaje, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ nombreId1: idMiNombre, nombreId2: idSuNombre, mensaje: mensaje })
        })
        .then(response => {
            if (!response.ok) {
                console.log('Respuesta del servidor enviarMensaje:', response);
                throw new Error('Enviar mensaje ha fallado');
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta del servidor enviarMensaje:', data);
            loadChatsFromMongoDB();
        })
        .catch(error => {
            console.error('Error al enviar el mensaje:', error);
        });
    }

    function addMessage(mensaje){
        enviarMensajeMongo(mensaje);
        const newChat = {...mensaje , user:localStorage.getItem("user") , avatar}
        setChats([...chats , newChat])        
    }

    function ChatsList(){
        return( <div style={{ height:'75vh' , overflow:'scroll' , overflowX:'hidden' }}>
              {
                 chats.map((chat, index) => {
                  if(chat.user === user) return <ChatBoxSender  key={index} message={chat.message} avatar={chat.avatar} user={chat.user} />
                  return <ChatBoxReciever key={index} message={chat.message} avatar={chat.avatar} user={chat.user} />
              })
              }
               <div ref={messagesEndRef} />
        </div>)
       
    }

  return (
    <div>
        {
         <div>
        
         <div style={{display:'flex', flexDirection:"row", justifyContent: 'space-between'}} >
          <h4>Username: {idSuNombre}</h4>
           </div>
            <ChatsList
             />
            
            <InputText addMessage={addMessage} />
        </div>
        }

     
    </div>
  )
}