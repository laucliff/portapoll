#= require lib/angular/angular.js
#= require lib/angular/angular-route.js

app = angular.module 'portapoll', ['ngRoute']

app.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'partials/main'
      controller: 'mainController'

mainController = ($scope) ->
  console.log 'maincontroller'
  $scope.holla = 'dolla bill yaaaaallll'
