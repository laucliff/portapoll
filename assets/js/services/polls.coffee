app.service 'pollService', ($http)->

  class poll
    constructor: (attributes, options) ->

      @_id = attributes._id if attributes._id?

      @name = attributes.name or 'New Poll'

      @pollOptions = []

      @addPollOption option for option in attributes.pollOptions if attributes?.pollOptions?

    addPollOption: (attributes = {}) ->
      @pollOptions.push
        name: attributes.name || 'Poll Option'
        votes: attributes.votes || 0

    vote: (index) ->
      if @pollOptions[index]?.votes?
        @pollOptions[index].votes++

    serialize: ->
      JSON.stringify this

  polls = []

  $http.get('/polls').success (data) ->
    console.log 'get', data

  at: (index)->
    polls[index]

  getAll: ->
    polls

  fetch: (callback) ->
    $http.get('/polls')
    .success (data) ->
      
      newPolls = []
      data.forEach (newPoll) ->
        newPolls.push new poll newPoll

      polls = newPolls

      callback null, polls
    .error (data) ->
      callback data

  create: (attributes) ->

    newPoll = new poll attributes
      # name: name
      # pollOptions: pollOptions

    $http.post('/polls', poll: newPoll).success (data) ->
      console.log 'create', data
      newPoll._id = data._id

    polls.push newPoll

  destroy: (poll)->
    if poll._id?
      $http.delete("/polls/#{poll._id}").success (data) ->
        console.log 'delete', data

        index = polls.indexOf(poll)

        if index != -1
          polls.splice(index, 1)
      .error (abc) ->
        console.log 'error', abc