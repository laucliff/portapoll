mainController = ($scope, $location, pollService) ->
  $scope.holla = 'dolla bill yaaaaallll'

  console.log pollService, pollService.getAll()

  # if pollService.getAll().length == 0
    # pollService.create 'new poll', ['option1', 'option2']
    # pollService.create
      # name: 'new poll'
      # pollOptions: ['option1', 'option2']

  pollService.fetch (err, data) ->
    console.log data
    if data.length == 0
      1
      # pollService.create 'new poll', ['option1', 'option2']

  console.log pollService.getAll()

  $scope.$watch pollService.getAll, (polls) ->
    $scope.polls = polls
  ,
    true

  $scope.createPoll = () ->
    pollService.create()

  $scope.deletePoll = (index) ->
    poll = pollService.at index

    pollService.destroy poll

pollController = ($scope, $routeParams, $cookieStore, pollService) ->

  $scope.poll = pollService.at $routeParams.pollId

  $scope.vote = (index) ->
    $scope.poll.vote(index)

    pollsVoted = $cookieStore.get 'pollsVoted'

    pollsVoted = [] if not pollsVoted?

    # Ensure unique keys
    if pollsVoted.indexOf($scope.poll._id) == -1
      pollsVoted.push $scope.poll._id
      $cookieStore.put 'pollsVoted', pollsVoted    

newPollController = ($scope, $location, pollService) ->

  $scope.poll = 
    name: 'New Poll'
    pollOptions: []

  $scope.addOption = ->
    $scope.poll.pollOptions.push
      name: 'New Option'

  $scope.removeOption = (index) ->
    $scope.poll.pollOptions.splice(index, 1)

  $scope.savePoll = ->
    pollService.create $scope.poll

    $location.url '/'