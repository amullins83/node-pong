// This is a module for cloud persistance in mongolab - https://mongolab.com
angular.module('mongolab', ['ngResource']).
    factory('Game', function($resource) {
      var Game = $resource('api/Games/:id');
      return Game;
    }).
    factory('User', function($resource) {
        var User = $resource('api/user/:id', {id:"@id"});
        return User;
    });