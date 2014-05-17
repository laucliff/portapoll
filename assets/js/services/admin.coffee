app.service 'admin', ($http, $window)->

  login: (password) ->
    delete $window.sessionStorage.token
    console.log $window.sessionStorage

    token = $http.post('/login', password: password).success (data) ->
      $window.sessionStorage.token = data.token

  logout: ->
    delete $window.sessionStorage.token

  getToken: ->
    $window.sessionStorage.token

app.factory 'authInterceptor', ($window) ->
  request: (config) ->
    config.headers = config.headers || {}

    if $window.sessionStorage.token
      config.headers.Authorization = "Bearer #{$window.sessionStorage.token}"

    config

app.config ($httpProvider) ->
  $httpProvider.interceptors.push 'authInterceptor'