'use strict'

class DialogCtrl

    constructor: (@$scope, @$http, @$dialog)->
        @$scope.opts =
            templateUrl: 'modal/signIn'
            controller:  SignInCtrl

        @$scope.openSignIn = =>
            d = @$dialog.dialog @$scope.opts
            d.open().then (result)=>
                @$scope.didSignIn = result
                console.log result

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
    constructor: (@$scope, @$http, Game)->
        @$scope.games = []
        @$scope.feedback = []
        @$scope.games = Game.query()
        @$scope.problems = []
        @$scope.$watch "selectedGameId", =>
            @$scope.selectedGame = Game.get( {id: @$scope.selectedGameId}, (Game)=>
                @$scope.score = Game.score
            ) if @$scope.selectedGameId?        

    @$inject: ['$scope', '$http', 'Game']


class TodoCtrl
    constructor: (@$scope, @$http, Todo)->
        @$scope.todos = []
        @$scope.todos = Todo.query()
       
    @$inject: ['$scope', '$http', 'Todo']

class SignInCtrl
    constructor: (@$scope, @$http, User, @dialog)->
        @$scope.user = {}
        @$scope.close = (result)=>
            @dialog.close result

    @$inject: ['$scope', '$http', 'User', 'dialog']
