express = require 'express'
router = express.Router()

jwt = require 'jsonwebtoken'
expressJwt = require 'express-jwt'

secret = 'secret'

router.get '/', (req, res) ->
  res.render 'index'

router.post '/login', (req, res) ->
  # if req.body.password == 'password'

  profile = 
    type: 'admin'

  token = jwt.sign profile, secret,
    expiresInMinutes: 60*5

  res.send token: token

module.exports = router;

