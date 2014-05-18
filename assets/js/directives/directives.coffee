app.directive 'getFocus', ($timeout) ->
  link: (scope, el, attrs) ->
    $timeout () ->
      el[0].focus()

app.directive 'loginWindow', (admin)->
  templateUrl: 'partials/login'
  controller: ($scope) ->
    $scope.$watch admin.getToken, (token) ->
      $scope.isLoggedIn = token?

    $scope.login = ()->
      admin.login($scope.password)
        .error (err) ->
          $scope.error = err
      $scope.password = null
      $scope.error = null

    $scope.logout = () ->
      admin.logout()

    $scope.toggleWindow = () ->
      $scope.showBigWindow = !$scope.showBigWindow

# Todo: some kind of modal or tooltip explaining that
# the password is located in config/secrets.json under adminPassword
    $scope.showPasswordHint = () ->
      console.log 'password hint'