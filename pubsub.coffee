http = require 'http'
faye = require 'faye'

port = 8282

# Honestly password should be generated dynamically, but static will do for now.
publishPassword = 'N24mV29P4K'

module.exports.init = () ->
  server = http.createServer()

  module.exports.bayeux = bayeux = new faye.NodeAdapter
    mount: '/faye'
    timeout: 45

  # Security for server only publishing
  bayeux.addExtension
    incoming: (message, callback) ->
      if !message.channel.match /^\/meta\//
        password = message.ext?.password
        if password != publishPassword
          message.error = '403::Password required'

      callback message

    outgoing: (message, callback) ->
      if message.ext
        delete message.ext.password
      callback message

  bayeux.getClient().addExtension
    outgoing: (message, callback) ->
      message.ext = message.ext || {}
      message.ext.password = publishPassword
      callback message

  bayeux.attach server

  server.listen port, () ->
    console.log "Faye server listening on port #{server.address().port}"
