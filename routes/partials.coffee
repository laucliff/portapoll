express = require 'express'
router = express.Router()

router.get '/:name', (req, res) ->
  res.render "partials/#{req.params.name}"

module.exports = router