express = require 'express'
router = express.Router()

jwt = require 'jsonwebtoken'
expressJwt = require 'express-jwt'

auth = require '../modules/auth'

router.get '/', (req, res) ->
  res.render 'index'

router.post '/login', (req, res) ->

  if not auth.verifyPassword req.body.password
    res.send 401, 'Wrong password.'
    return

  profile = 
    type: 'admin'

  token = jwt.sign profile, auth.getTokenSecret(),
    expiresInMinutes: 60*5

  res.send token: token

module.exports = router;

