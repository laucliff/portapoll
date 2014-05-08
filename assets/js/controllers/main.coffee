mainController = ($scope, $location, Polls) ->
  $scope.holla = 'dolla bill yaaaaallll'

  $scope.deletePoll = (poll) ->
    Polls.destroy poll

  $scope.$watch Polls.getAll, (polls) ->
    $scope.polls = polls
  ,
    true

pollController = ($scope, $routeParams, $cookieStore, Polls) ->
  $scope.poll = Polls.at $routeParams.pollId
  # $scope.poll = pollService.at $routeParams.pollId

  # $scope.vote = (index) ->
  #   pollService.vote $scope.poll, index

  #   pollsVoted = $cookieStore.get 'pollsVoted'

  #   pollsVoted = [] if not pollsVoted?

  #   # Ensure unique keys
  #   if pollsVoted.indexOf($scope.poll._id) == -1
  #     pollsVoted.push $scope.poll._id
  #     $cookieStore.put 'pollsVoted', pollsVoted    

newPollController = ($scope, $location, pollService, Polls) ->

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

    Polls.create $scope.poll, (response) ->
      console.log response

    $location.url '/'