app.directive 'getFocus', ($timeout) ->
  link: (scope, el, attrs) ->
    $timeout () ->
      el[0].focus()