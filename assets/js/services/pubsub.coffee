app.factory 'pubsub', () ->
  client = new Faye.Client 'http://localhost:8282/faye'

  client