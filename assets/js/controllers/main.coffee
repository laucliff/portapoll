mainController = ($scope, $location, pollService) ->
  $scope.holla = 'dolla bill yaaaaallll'

  console.log pollService, pollService.get()

  if pollService.get().length == 0
    pollService.create 'new poll', ['option1', 'option2']

  console.log pollService.get()

  $scope.$watch pollService.get, (polls) ->
    $scope.polls = polls
  ,
    true

  $scope.createPoll = () ->
    pollService.create()

pollController = ($scope, $routeParams, pollService) ->

  $scope.poll = pollService.get $routeParams.pollId

  $scope.vote = (index) ->
    $scope.poll.vote(index)
