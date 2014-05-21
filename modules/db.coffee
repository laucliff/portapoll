MongoClient = require('mongodb')
format = require('util').format

module.exports.init = (callback) ->
  MongoClient.connect 'mongodb://127.0.0.1:27017/portapoll', (err, db) ->

    module.exports.db = db

    callback err, db