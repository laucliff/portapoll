mainController = ($scope, $location, pollService) ->
  $scope.holla = 'dolla bill yaaaaallll'

  console.log pollService, pollService.getAll()

  # if pollService.getAll().length == 0
    # pollService.create 'new poll', ['option1', 'option2']

  pollService.fetch (err, data) ->
    if data.length == 0
      pollService.create 'new poll', ['option1', 'option2']

  console.log pollService.getAll()

  $scope.$watch pollService.getAll, (polls) ->
    $scope.polls = polls
  ,
    true

  $scope.createPoll = () ->
    pollService.create()

pollController = ($scope, $routeParams, pollService) ->

  $scope.poll = pollService.get $routeParams.pollId

  $scope.vote = (index) ->
    $scope.poll.vote(index)
