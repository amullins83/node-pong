var mongolab;

mongolab = angular.module('mongolab', ['ngResource']);

mongolab.factory('Game', function($resource) {
  var Game;
  return Game = $resource('api/games/:id');
});

mongolab.factory('User', function($resource) {
  var User;
  return User = $resource('api/users/:id');
});
