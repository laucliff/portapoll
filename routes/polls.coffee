express = require 'express'
router = express.Router()

mongo = require('../db')
BSON = require('mongodb').BSONPure

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

# Create new poll
router.post '/', (req, res) ->
  polls = mongo.db.collection('polls')

  newPoll = req.body.poll

  polls.insert newPoll, null, (err, doc)->
    throw err if err

    # Singular insert, so expecting a single result doc.
    res.send doc?[0]


# Delete poll
router.delete '/:id', (req, res) ->
  polls = mongo.db.collection('polls');

  polls.remove
    _id: new BSON.ObjectID(req.params.id)
  , null
  , (err, doc) ->
    throw err if err
    res.send 200




module.exports = router