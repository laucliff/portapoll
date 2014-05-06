app.service 'pollService', ($http)->

  class poll
    constructor: (name, pollOptions) ->
      @name = name or 'New Poll'

      @pollOptions = []

      @addPollOption option for option in pollOptions if pollOptions?

    addPollOption: (name, votes) ->
      @pollOptions.push
        name: name || 'Poll Option'
        votes: votes || 0

    vote: (index) ->
      if @pollOptions[index]?.votes?
        @pollOptions[index].votes++

    serialize: ->
      JSON.stringify this

  polls = []

  $http.get('/polls').success (data) ->
    console.log 'get', data

  get: (index)->
    polls[index]

  getAll: ->
    polls

  fetch: (callback) ->
    $http.get('/polls')
    .success (data) ->
      polls = data
      callback null, polls
    .error (data) ->
      callback data

  create: (name, pollOptions) ->

    poll = new poll name, pollOptions

    index = polls.push(poll)-1

    $http.post('/polls', poll: poll).success (data) ->
      console.log 'create', data
      polls[index]._id = data._id
