mainController = ($scope, $location, Polls, admin) ->

  $scope.deletePoll = (poll) ->
    Polls.destroy poll

  $scope.$watch Polls.getAll, (polls) ->
    $scope.polls = polls
  ,
    true

  $scope.$watch admin.getToken, (token) ->
    $scope.isLoggedIn = token?

pollController = ($scope, $routeParams, $cookieStore, $location, Polls) ->

  redirectToResults = () ->
    # Ensures that when the browser goes back, it does not end up in the vote screen.
    $location.path "/polls/#{$routeParams.pollId}/results"
    $location.replace()

  $scope.poll = Polls.get $routeParams.pollId

  pollsVoted = $cookieStore.get 'pollsVoted'

  if $scope.poll.$promise
    $scope.poll.$promise.then (poll) ->
      if _.contains pollsVoted, poll._id
        redirectToResults()
  else
    if _.contains pollsVoted, $scope.poll._id
      redirectToResults()


  $scope.vote = (index) ->

    if $scope.hasVoted
      console.log 'Already voted!'
    else

      Polls.vote $scope.poll, index

      pollsVoted = $cookieStore.get('pollsVoted') or []

      pollsVoted.push $scope.poll._id
      $cookieStore.put 'pollsVoted', pollsVoted

      $scope.hasVoted = true

      # $location.url "/polls/#{$routeParams.pollId}/results"
      redirectToResults()

resultsController = ($scope, $routeParams, Polls) ->

  $scope.poll = Polls.get $routeParams.pollId

  $scope.incr = (option) ->
    option.votes++

newPollController = ($scope, $location, Polls) ->

  $scope.poll =
    name: 'New Poll'
    pollOptions: []

  $scope.addOption = ->
    $scope.poll.pollOptions.push
      name: 'New Option'
      votes: 0

  $scope.removeOption = (index) ->
    $scope.poll.pollOptions.splice(index, 1)

  $scope.savePoll = ->

    Polls.create $scope.poll, (newPoll) ->
      $location.url "/polls/#{newPoll._id}"

  $scope.addOption()
