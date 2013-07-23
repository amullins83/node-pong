# This is a module for cloud persistance in mongolab - https://mongolab.com
mongolab = angular.module 'mongolab', ['ngResource']

mongolab.factory 'Game', ($resource)->
    Game = $resource 'api/Games/:id', id:"@id"

mongolab.factory 'User', ($resource)->
    User = $resource 'api/user/:id', id:"@id"