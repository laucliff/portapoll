express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
  res.send 'polls'

router.get '/:id', (req, res) ->
  # res.render "partials/#{req.params.name}"
  res.send "polls/#{req.params.id}"

module.exports = router