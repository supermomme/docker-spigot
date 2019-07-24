if (!process.env.WEB_PASSWORD) process.exit()
// Setup basic express server
var express = require('express');
var app = express();
var path = require('path');
var server = require('http').createServer(app);
var io = require('socket.io')(server);
var port = process.env.PORT || 3000;
var Rcon = require('rcon');
const exitHook = require('exit-hook');

const RCON_HOST = process.env.RCON_HOST || 'localhost'
const RCON_PORT = process.env.RCON_PORT || 25575
const RCON_PASSWORD = process.env.RCON_PASSWORD || '9hBM9Hqj4IJu'

var authedSockets = []
var conn = new Rcon(RCON_HOST, RCON_PORT, RCON_PASSWORD);
conn.on('auth', function() {
  console.log("Authed!");
  authedSockets.forEach(socket => {
    socket.emit('newMessage', 'Authed via RCON')
  });
}).on('response', function(str) {
  console.log("Got response: " + str);
  authedSockets.forEach(socket => {
    socket.emit('newMessage', str)
  });
}).on('end', function() {
  console.log("Socket closed!");
  authedSockets.forEach(socket => {
    socket.emit('newMessage', 'Socket via RCON closed!')
  });
  setTimeout(() => conn.connect(), 15000)
}).on('error', function(err) {
  console.log("err!", err);
  authedSockets.forEach(socket => {
    socket.emit('newMessage', 'error via rcon! '+err)
  });
  setTimeout(() => conn.connect(), 15000)
});

conn.connect();

server.listen(port, () => {
  console.log('Server listening at port %d', port);
});

app.use(express.static(path.join(__dirname, 'public')));

io.on('connection', (socket) => {
  socket.on('login', pass => {
    if (authedSockets.indexOf(socket.id) !== -1) socket.emit('loggedIn', true)
    else if (pass === process.env.WEB_PASSWORD) {
      authedSockets.push(socket)
      socket.emit('loggedIn', true)
    } else {
      socket.emit('loggedIn', false)
    }
  })

  socket.on('checkLoggedIn', () => {
    socket.emit('loggedIn', authedSockets.indexOf(socket.id) !== -1)
  })

  socket.on('sendCommand', command => {
    console.log(command)
    conn.send(command);
    authedSockets.forEach(socket => {
      socket.emit('newMessage', `Send to server: ${command}`)
    });
  })
});

exitHook(() => {
  console.log('Cleanup')
  conn.disconnect()
});