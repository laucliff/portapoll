app = angular.module 'portapoll', ['ngRoute']

app.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'partials/main'
      controller: 'mainController'