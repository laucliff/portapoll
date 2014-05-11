http = require 'http'
faye = require 'faye'

port = 8282

module.exports.init = () ->
  server = http.createServer()

  module.exports.bayeux = bayeux = new faye.NodeAdapter
    mount: '/faye'
    timeout: 45

  bayeux.attach server

  server.listen port, () ->
    console.log "Faye server listening on port #{server.address().port}"

  # This part right now only for debug.
  # bayeux.getClient().subscribe '/abc', (message) ->
  #   console.log 'faye', message

    # if ((message != 'abc') or (message != 'def'))
    #   bayeux.getClient().publish '/abc', 'abc'
