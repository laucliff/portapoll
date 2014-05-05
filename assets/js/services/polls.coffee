app.service 'pollService', ()->

  class poll
    constructor: (name, pollOptions) ->
      @name = name or 'New Poll'

      @pollOptions = []

      console.log option for option in pollOptions

      @addPollOption option for option in pollOptions

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

  get: (index)->
    polls[index] or polls    

  create: (name, pollOptions) ->
    polls.push new poll(name, pollOptions)