express = require 'express'
router = express.Router()

mongo = require('../modules/db')
BSON = require('mongodb').BSONPure

pubsub = require '../modules/pubsub'

expressJwt = require 'express-jwt'
secret = require('../modules/auth').getTokenSecret()

# Get all polls
router.get '/', (req, res) ->

  polls = mongo.db.collection('polls');

  polls.find().toArray (err, docs) ->
    res.send docs

# Get specific poll
router.get '/:id', (req, res) ->
  polls = mongo.db.collection('polls');

  console.log req.params.id

  polls.findOne
    _id: new BSON.ObjectID(req.params.id)
  , (err, doc) ->

    console.log err, doc

    res.send doc


# User has voted on given poll
router.post '/:id/vote/:optionId', (req, res) ->

  polls = mongo.db.collection('polls')
  id = new BSON.ObjectID(req.params.id)
  optionIndex = req.params.optionId

  # Clunky way of building object string based on index.
  # May want to transition to basing on option id?
  updateObj =
    $inc: {}
  updateObj.$inc["pollOptions.#{optionIndex}.votes"] = 1

  polls.update
    _id: id
  ,
    updateObj
  , (err, doc) ->
    throw err if err
    console.log 'voted', err, doc
    res.send 200

    pubsub.bayeux.getClient().publish '/polls',
      message: 'vote'
      data: 
        pollId: req.params.id
        optionId: req.params.optionId

# Create new poll
router.post '/', expressJwt(secret: secret), (req, res) ->

  if not (req.user.type == 'admin')
    res.send 401, 'Not admin.'
    return

  polls = mongo.db.collection('polls')

  newPoll = req.body

  polls.insert newPoll, null, (err, doc)->
    throw err if err

    # Singular insert, so expecting a single result doc.
    res.send doc?[0]

    pubsub.bayeux.getClient().publish '/polls',
      message: 'new'
      data: doc?[0]

# Delete poll
router.delete '/:id', expressJwt(secret: secret), (req, res) ->
  if not (req.user.type == 'admin')
    res.send 401, 'Not admin.'
    return

  polls = mongo.db.collection('polls');

  polls.remove
    _id: new BSON.ObjectID(req.params.id)
  , null
  , (err, doc) ->
    throw err if err
    res.send 200

    pubsub.bayeux.getClient().publish '/polls',
      message: 'remove'
      data: req.params.id


module.exports = router