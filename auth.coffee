fs = require 'fs'

# Read in secrets.json, store the password/secret info as private attributes on module.
secretAttributes = ['adminPassword', 'tokenSecret']

data = JSON.parse fs.readFileSync('./config/secrets.json', 'utf8')

secretAttributes.forEach (attribute) =>
  this[attribute] = data?[attribute]

module.exports =
  verifyPassword: (password) =>
    password? and password == @adminPassword

  getTokenSecret: =>
    @tokenSecret