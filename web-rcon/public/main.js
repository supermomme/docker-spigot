$(function() {
  var socket = io();

  var FADE_TIME = 150; // ms
  var $window = $(window);
  var $passwordInput = $('.passwordInput'); // Input for password
  var $messages = $('.messages'); // Messages area
  var $inputMessage = $('.inputMessage'); // Input message input box

  var password;
  var connected = false;
  var authed = false;
  var $currentInput = $passwordInput.focus();
  
  var $loginPage = $('.login.page'); // The login page
  var $chatPage = $('.chat.page'); // The chatroom page

  $window.keydown(event => {
    // Auto-focus the current input when a key is typed
    if (!(event.ctrlKey || event.metaKey || event.altKey)) {
      $currentInput.focus()
    }
    
    if (event.which === 13) {
      if (authed) {
        sendMessage()
      } else {
        sendPassword()
      }
    }
  });

  const addMessageElement = (el, options) => {
    var $el = $(el);

    // Setup default options
    if (!options) {
      options = {};
    }
    if (typeof options.fade === 'undefined') {
      options.fade = true;
    }
    if (typeof options.prepend === 'undefined') {
      options.prepend = false;
    }

    // Apply options
    if (options.fade) {
      $el.hide().fadeIn(FADE_TIME);
    }
    if (options.prepend) {
      $messages.prepend($el);
    } else {
      $messages.append($el);
    }
    $messages[0].scrollTop = $messages[0].scrollHeight;
  }

  const log = (message, classType, options) => {
    message = message.replace(/§([A-Za-z0-9])/g, '')
    let messages = message.split('\n')
    console.log(message)
    messages.forEach(element => {
      var $el = $('<li>').addClass(classType).text(element);
      addMessageElement($el, options);
    });
    
  }

  const sendMessage = () => {
    var message = $inputMessage.val();
    message = cleanInput(message);
    if (message && authed) {
      $inputMessage.val('');
      socket.emit('sendCommand', message);
    }
  }

  $loginPage.click(() => {
    $currentInput.focus();
  });

  // Focus input when clicking on the message input's border
  $inputMessage.click(() => {
    $inputMessage.focus();
  });

  const cleanInput = (input) => {
    return $('<div/>').text(input).html();
  }

  const sendPassword = () => {
    password = cleanInput($passwordInput.val().trim());
    if (password) {
      socket.emit('login', password);
    }
  }

  socket.on('loggedIn', loggedIn => {
    authed = loggedIn
    if (loggedIn) {
      $loginPage.fadeOut()
      $chatPage.show()
      $loginPage.off('click')
      $currentInput = $inputMessage.focus()
    } else {
      $loginPage.fadeIn()
      $chatPage.hide()
      $loginPage.on('click')
      $currentInput = $passwordInput.focus()
    }
  })

  socket.on('newMessage', message => {
    log(message, 'message')
  })

  socket.on('disconnect', () => {
    log('you have been disconnected', 'log');
  });

  socket.on('reconnect', () => {
    log('you have been reconnected', 'log');
    if (password) {
      socket.emit('login', password);
    }
  });

  socket.on('reconnect_error', () => {
    log('attempt to reconnect has failed', 'log');
  });
});