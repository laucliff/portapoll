app.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'partials/main'
      controller: 'mainController'
    .when '/polls/new',
      templateUrl: 'partials/new'
      controller: 'newPollController'
    .when '/polls/:pollId',
      templateUrl: 'partials/poll'
      controller: 'pollController'
    .otherwise
      redirectTo: '/'