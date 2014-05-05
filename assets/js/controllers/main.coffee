mainController = ($scope, pollService) ->
  console.log 'maincontroller'
  $scope.holla = 'dolla bill yaaaaallll'

  console.log pollService, pollService.get()

  pollService.create()

  console.log pollService.get()

  # $scope.$watch abc.get, (n, v)->
  #   console.log abc.get(), n, v
  #   $scope.holla = n