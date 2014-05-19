app.directive 'getFocus', ($timeout) ->
  link: (scope, el, attrs) ->
    $timeout () ->
      el[0].focus()

app.directive 'loginWindow', (admin)->
  templateUrl: 'partials/login'
  scope: {}
  link: ($scope) ->
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

app.directive 'piechart', ()->
  scope:
    data: '='
  link: (scope, el, attrs) ->

    colour = d3.scale.category20()
    
    width = el[0].offsetWidth
    height = width
    # height = el[0].offsetHeight
    r = Math.min(width, height)/2

    arc = d3.svg.arc().outerRadius(r*0.5).innerRadius(0)

    svg = d3.select(el[0]).append('svg')
          .attr('width', width)
          .attr('height', height)

    pie = svg.append('g')
          .attr('class', 'pie')
          .attr('transform', "translate(#{width/2}, #{height/2})")

    labels = svg.append('g')
              .attr('class', 'labels')
              .attr('transform', "translate(#{width/2}, #{height/2})")


    pieData = d3.layout.pie().value((data) ->
      data.votes
    ).sort(null)

    scope.render = (data) ->

      pieChart = pie.selectAll('path').data(pieData(data))

      pieChart.enter().append('path')
      .attr('fill', (d, i) -> colour i)
      .attr('d', arc)
      .each((d) -> this._current = d )


      pieChart.transition()
      .attrTween 'd', (d) ->
        interpolate = d3.interpolate this._current, d
        this._current = interpolate(0)
        (t) ->
          arc(interpolate(t))


      labelGroup = labels.selectAll('text').data(pieData(data))

      labelGroup.enter()
      .append('text')
      .attr('transform', (d) ->
        "translate(#{arc.centroid(d)})"
      )
      .attr('font-size', '20')
      .attr('text-anchor', 'middle')
      .text((d) -> d.data.name)
      .each((d) -> this._current = d)

      labelGroup.transition()
      .attrTween 'transform', (d) ->
        interpolate = d3.interpolate this._current, d
        this._current = interpolate(0)
        (t) ->
          "translate(#{arc.centroid(interpolate(t))})"
      # Hide label if poll option does not take up space on the pie chart (zero votes).
      .attr 'opacity', (d) ->
        if d.value == 0 then 0 else 1


    scope.$watch 'data', (poll) ->
      scope.render poll.pollOptions if poll?.pollOptions?
    , true
