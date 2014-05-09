mainController = ($scope, $location, Polls) ->
  $scope.holla = 'dolla bill yaaaaallll'

  $scope.deletePoll = (poll) ->
    Polls.destroy poll

  $scope.$watch Polls.getAll, (polls) ->
    $scope.polls = polls
  ,
    true

pollController = ($scope, $routeParams, $cookieStore, $location, Polls) ->

  Polls.get $routeParams.pollId, (poll) ->
    $scope.poll = poll

    pollsVoted = $cookieStore.get 'pollsVoted'
    $scope.hasVoted = _.contains pollsVoted, poll._id


  $scope.vote = (index) ->

    if $scope.hasVoted
      console.log 'Already voted!'
    else

      Polls.vote $scope.poll, index

      pollsVoted = $cookieStore.get('pollsVoted') or []

      pollsVoted.push $scope.poll._id
      $cookieStore.put 'pollsVoted', pollsVoted

      $scope.hasVoted = true

    $location.url "/polls/#{$routeParams.pollId}/results"

resultsController = ($scope, $routeParams, Polls) ->

  Polls.get $routeParams.pollId, (poll) ->
    $scope.poll = poll

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
