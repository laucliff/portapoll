app.factory 'Poll', ($resource) ->
  resource = $resource '/polls/:id'
  , null
  , vote:
    method: 'POST'
    url: "/polls/:pollId/vote/:optionId"
  , destroy:
    method: 'DELETE'
    url: "/polls/:pollId"

  resource

app.factory 'Polls', (Poll) ->

  polls = []

  Poll.query (data) ->
    polls = data

  getAll: ->
    polls

  at: (index) ->
    poll = polls[index]

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

    polls.push poll

  destroy: (poll) ->
    Poll.delete id: poll._id, (res) ->
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