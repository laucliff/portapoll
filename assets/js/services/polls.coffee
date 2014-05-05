app.service 'pollService', ()->

  class poll
    constructor: (name, pollOptions) ->
      @name = name or 'New Poll'
      @pollOptions = pollOptions or []

    vote: (index) ->
      if @pollOptions[index]?.count?
        @pollOptions[index].count++

  polls = []

  get: (index)->
    polls[index] or polls    

  create: (name, pollOptions) ->
    polls.push new poll(name, pollOptions)