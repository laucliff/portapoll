#= require /pubsub

app.factory 'Poll', ($resource) ->
  resource = $resource '/polls/:id'
  , null
  , vote:
    method: 'POST'
    url: "/polls/:pollId/vote/:optionId"

  resource

app.service 'Polls', ($rootScope, Poll, pubsub) ->

  polls = []

  Poll.query (data) ->
    newPolls = []
    angular.copy data, newPolls

    # Find intersection of new polls and old polls

    nonMatchingPolls = []

    newPolls.forEach (poll) ->
      matchingPoll = _.find polls, _id: poll._id
      if matchingPoll
        # Merge
        # For now just have existing overwrite.
      else
        nonMatchingPolls.push poll

    console.log polls, nonMatchingPolls

    polls = polls.concat nonMatchingPolls

    console.log polls


  client = pubsub
  client.subscribe '/polls', (response) ->
    console.log 'faye', response
    switch response.message
      when 'new'
        if not _.find(polls, response.data)
          console.log "Inserting #{response.data._id} into polls."
          polls.push response.data

          # We need to trigger digest to update any views watching polls.
          $rootScope.$digest()
      when 'remove'
        console.log 'remove', response
        _.remove polls, (poll) ->
          poll._id == response.data
        $rootScope.$digest()
      when 'vote'
        poll = _.find polls, _id: response.data.pollId
        poll?.pollOptions[parseInt(response.data.optionId)]?.votes++
        $rootScope.$digest()

# Attempt to get from locally stored polls. Otherwise fetch from server if not found.
# Returns either the poll itself or a promise object. The promise object is 
  get: (id, callback) ->

    poll = _.find polls, _id: id

    if not poll?
      poll = Poll.get id: id

      polls.push poll

    poll

  getAll: ->
    polls

  at: (index) ->
    poll = polls[index]

  vote: (poll, index) ->

    # Currently relies on the vote callback to update vote count.

    (new Poll poll).$vote
      pollId: poll._id
      optionId: index

  fetch: (args...)->
    promise = Poll.query args...
    promise.$promise.then (result) ->
      polls = result

  create: (attributes, callback) ->

    defaults =
      name: 'New Poll'
      options: []

    angular.extend defaults, attributes

    poll = new Poll attributes

    poll.$save (response) ->
      callback response

    # polls.push poll

  destroy: (poll) ->
    # See comment under vote for reason behind creating a new poll.
    (new Poll poll).$delete id: poll._id, (res) ->
      polls = _.without polls, poll

# app.service 'pollService', ($http)->

#   class poll
#     constructor: (attributes, options) ->

#       @_id = attributes._id if attributes._id?

#       @name = attributes.name or 'New Poll'

#       @pollOptions = []

#       @addPollOption option for option in attributes.pollOptions if attributes?.pollOptions?

#     addPollOption: (attributes = {}) ->
#       @pollOptions.push
#         name: attributes.name || 'Poll Option'
#         votes: attributes.votes || 0

#     vote: (index) ->
#       if @pollOptions[index]?.votes?
#         @pollOptions[index].votes++
#       else @pollOptions[index].votes = 1

#     serialize: ->
#       JSON.stringify this

#   polls = []

#   $http.get('/polls').success (data) ->
#     console.log 'get', data

#   at: (index)->
#     polls[index]

#   getAll: ->
#     polls

#   fetch: (callback) ->
#     $http.get('/polls')
#     .success (data) ->
      
#       newPolls = []
#       data.forEach (newPoll) ->
#         newPolls.push new poll newPoll

#       polls = newPolls

#       callback null, polls
#     .error (data) ->
#       callback data

#   create: (attributes) ->

#     newPoll = new poll attributes
#       # name: name
#       # pollOptions: pollOptions

#     $http.post('/polls', poll: newPoll).success (data) ->
#       console.log 'create', data
#       newPoll._id = data._id

#     polls.push newPoll

#   destroy: (poll)->
#     if poll._id?
#       $http.delete("/polls/#{poll._id}").success (data) ->
#         console.log 'delete', data

#         index = polls.indexOf(poll)

#         if index != -1
#           polls.splice(index, 1)
#       .error (abc) ->
#         console.log 'error', abc

#   vote: (poll, optionIndex) ->
#     poll.vote(optionIndex)

#     $http.post("/polls/#{poll._id}/vote/#{optionIndex}").success (data) ->
#       console.log 'voted', poll._id, optionIndex, data