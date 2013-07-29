'use strict'

class DialogCtrl

    constructor: (@$scope, @$http, @$dialog, User)->
        @$scope.opts =
            templateUrl: 'modal/signIn'
            controller:  SignInCtrl

        @$scope.user = User.query()[0]
        @$scope.logOutText = "Log Out"
        @$scope.signInText = "Sign In"

        @$scope.signInOutText = if @$scope.user? @$scope.logOutText else @$scope.signInText

        @$scope.openSignIn = =>
            d = @$dialog.dialog @$scope.opts
            d.open().then (result)=>
                if result? and result.email? 
                    @$scope.didSignIn = true
                    @$scope.signInOutText = "Log Out"
                    @$scope.user = result

        @$scope.logOut = =>
            @$http.delete("./logout").success (data, status, headers, config)=>
                @$scope.signInOutText = "Sign In"
                @$scope.user = null

        @$scope.signInOutButton = =>
            unless @$scope.user?
                return @$scope.openSignIn()
            else
                return @$scope.logOut()

    @$inject: ['$scope', '$http', '$dialog', 'User']


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

    constructor: (@$scope, @$http, @$timeout, Game, Pad, Ball, HitDetector)->
        @$scope.games = []
        @$scope.feedback = []
        #@$scope.games = Game.query()
        @$scope.problems = []

        @$scope.score = [0, 0]

        #@$scope.$watch "selectedGameId", =>
        #    @$scope.selectedGame = Game.get( {id: @$scope.selectedGameId}, (Game)=>
        #        @$scope.score = Game.score
        #    ) if @$scope.selectedGameId?        
        


        @$scope.pad1 = new Pad "pad1", @padOffset, (@height - @padHeight) / 2, @padWidth, @padHeight, "w", "s"
        @$scope.pad2 = new Pad "pad2", (@width - @padWidth - @padOffset), (@height - @padHeight) / 2, @padWidth, @padHeight, "up", "down"

        @$scope.pads = [@$scope.pad1, @$scope.pad2]

        @$scope.ball = new Ball (@width - @ballsize)/2, (@height - @ballsize)/2, @ballsize

        @$scope.hitDetect = new HitDetector(@width, @height)

        @$scope.status = "Running"

        @$scope.move = (key)=>
            for pad in @$scope.pads
                pad.pressKey key

        @$scope.stop = (key)=>
            for pad in @$scope.pads
                pad.releaseKey key

        @updateLater()

    updateLater: =>
        @$timeout.cancel @updateInterval
        if @$scope.status == "Running"
            @updateInterval = @$timeout =>
                @update()
                @updateLater()
            , 1000 / @fps


    move: (key)=>
        for pad in @$scope.pads
            pad.pressKey key

    stop: (key)=>
        for pad in @$scope.pads
            pad.releaseKey key

    update: =>
        @updateBall()
        @updatePads()
        @updateScore()
        @redraw()

    updateScore: =>
        if @$scope.hitDetect.hitLeftWall @$scope.ball
            @score 1
        else if @$scope.hitDetect.hitRightWall @$scope.ball
            @score 0

    score: (i)=>
        @$scope.score[i] += 1
        if @$scope.score[i] >= @scoreMax
            @$scope.status = "Player #{i+1} Wins"
            @$scope.message = "Player #{i+1} Wins"
        @$scope.ball = new Ball (@width - @ballsize)/2, (@height - @ballsize)/2, @ballsize

    updateBall: =>
        if @$scope.hitDetect.hit(@$scope.ball, @$scope.pad1) or @$scope.hitDetect.hit(@$scope.ball, @$scope.pad2)
            if @$scope.hitDetect.hitRight(@$scope.ball, @$scope.pad1) or @$scope.hitDetect.hitLeft(@$scope.ball, @$scope.pad2)
                @$scope.ball.velocity.x *= -1
        
        if @$scope.hitDetect.hitVertical(@$scope.ball, @$scope.pad1) or @$scope.hitDetect.hitVertical(@$scope.ball, @$scope.pad2) or @$scope.hitDetect.hitVerticalWall(@$scope.ball)
                @$scope.ball.velocity.y *= -1

        @$scope.ball.pos.x += @$scope.ball.velocity.x
        @$scope.ball.pos.y += @$scope.ball.velocity.y

    updatePads: =>
        for pad in @$scope.pads
            if @$scope.hitDetect.hitBottomWall pad
                pad.pos.y = @height - pad.size.height - 1
            else if @$scope.hitDetect.hitTopWall pad
                pad.pos.y = 1
            else
                pad.pos.y += pad.velocity.y

    redraw: =>
        @$scope.pad1style = 
            top: @$scope.pad1.pos.y

        @$scope.pad2style =
            top: @$scope.pad2.pos.y

        @$scope.ballstyle =
            top: @$scope.ball.pos.y
            left: @$scope.ball.pos.x

    @$inject: ['$scope', '$http', '$timeout','Game', 'Pad', 'Ball', 'HitDetector']


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
