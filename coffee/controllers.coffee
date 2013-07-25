'use strict'

class DialogCtrl

    constructor: (@$scope, @$http, @$dialog)->
        @$scope.opts =
            templateUrl: 'modal/signIn'
            controller:  SignInCtrl

        @$scope.openSignIn = =>
            d = @$dialog.dialog @$scope.opts
            d.open().then (result)=>
                @$scope.didSignIn = result?
                @$scope.user = result
                console.log result

        @$scope.logOut = =>
            @$http.delete("./logout").success (data, status, headers, config)=>
                @$scope.user = null

    @$inject: ['$scope', '$http', '$dialog']


class AppCtrl

    constructor: (@$scope, @$http)->
        @getName()

    getName: ->
        @$http(
            method: 'GET'
            url: '/api/name'
        ).success( (data, status, headers, config)=>
            @$scope.name = data.name
        ).error (data, status, headers, config)=>
            @$scope.name = 'Error!'

    @$inject: ['$scope', '$http']

class GameCtrl
    width: 600
    height: 400
    fps: 60
    scoreMax: 10
    ballsize: 20
    padHeight: 100
    padWidth: 10
    padOffset: 20

    constructor: (@$scope, @$http, Game, Pad, Ball, HitDetector)->
        $(".popUp").removeClass "shown"
        @$scope.games = []
        @$scope.feedback = []
        @$scope.games = Game.query()
        @$scope.problems = []

        @$scope.score = [0, 0]

        #@$scope.$watch "selectedGameId", =>
        #    @$scope.selectedGame = Game.get( {id: @$scope.selectedGameId}, (Game)=>
        #        @$scope.score = Game.score
        #    ) if @$scope.selectedGameId?        
        
        #@$scope.move = @move
        #@$scope.stop = @stop

        @pad1 = new Pad "pad1", @padOffset, (@height - @padHeight) / 2, @padWidth, @padHeight, "w", "s"
        @pad2 = new Pad "pad2", (@width - @padWidth - @padOffset), (@height - @padHeight) / 2, @padWidth, @padHeight, "up", "down"

        @pads = [@pad1, @pad2]

        @ball = new Ball (@width - @ballsize)/2, (@height - @ballsize)/2, @ballsize

        @hitDetect = new HitDetector(@width, @height)

        @status = "Running"
        @updateInterval = setInterval =>
            if @status == "Running"
                @update()
            else
                clearInterval @updateInterval
        , 1000 / @fps

        $(document).on "keyup", (evt)=>
            @stop evt.which

        $(document).on "keydown", (evt)=>
            @move evt.which

    move: (key)=>
        for pad in @pads
            pad.pressKey key

    stop: (key)=>
        for pad in @pads
            pad.releaseKey key

    update: =>
        @updateBall()
        @updatePads()
        @updateScore()
        @redraw()

    updateScore: =>
        if @hitDetect.hitLeftWall @ball
            @score 1
        else if @hitDetect.hitRightWall @ball
            @score 0

    score: (i)=>
        @$scope.score[i] += 1
        if @$scope.score[i] >= @scoreMax
            @status = "Player #{i+1} Wins"
            @$scope.message = "Player #{i+1} Wins"
            $(".popUp").text @$scope.message
            $(".popUp").addClass "shown"
        @ball = new Ball (@width - @ballsize)/2, (@height - @ballsize)/2, @ballsize

    updateBall: =>
        if @hitDetect.hit(@ball, @pad1) or @hitDetect.hit(@ball, @pad2)
            if @hitDetect.hitRight(@ball, @pad1) or @hitDetect.hitLeft(@ball, @pad2)
                @ball.velocity.x *= -1
        
        if @hitDetect.hitVertical(@ball, @pad1) or @hitDetect.hitVertical(@ball, @pad2) or @hitDetect.hitVerticalWall(@ball)
                @ball.velocity.y *= -1

        @ball.pos.x += @ball.velocity.x
        @ball.pos.y += @ball.velocity.y

    updatePads: =>
        for pad in [@pad1, @pad2]
            if @hitDetect.hitBottomWall pad
                pad.pos.y = @height - pad.size.height - 1
            else if @hitDetect.hitTopWall pad
                pad.pos.y = 1
            else
                pad.pos.y += pad.velocity.y

    redraw: =>
        for item in [@pad1, @pad2, @ball]
            $("##{item.id}").css top: item.top()
            $("##{item.id}").css left: item.left()
        for index in [0, 1]
            $("#score#{index + 1}").text @$scope.score[index]

    @$inject: ['$scope', '$http', 'Game', 'Pad', 'Ball', 'HitDetector']


class TodoCtrl
    constructor: (@$scope, @$http, Todo)->
        @$scope.todos = []
        @$scope.todos = Todo.query()
       
    @$inject: ['$scope', '$http', 'Todo']

class SignInCtrl
    constructor: (@$scope, @$http, User, @dialog)->
        @$scope.user = "Player 1"
        @$scope.close = (result)=>
            @dialog.close result

        @$scope.signIn = =>
            postData =
                email: @$scope.email
                password: @$scope.password

            @$http.post("./login", postData).success( (data, status, headers, config)=>
                @$scope.user = data
                @dialog.close data
            ).error (data, status, headers, config)=>
                @$scope.user = "Player 1"
                @dialog.close false


    @$inject: ['$scope', '$http', 'User', 'dialog']
