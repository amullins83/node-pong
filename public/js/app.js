'use strict';
var app;

app = angular.module('nodePong', ['nodePong.filters', 'nodePong.services', 'nodePong.directives', 'nodePong.controllers', 'gameObjects', 'ui', 'ui.bootstrap', 'ui.bootstrap.dialog', 'mongolab']).config([
  '$routeProvider', '$locationProvider', '$dialogProvider', function($routeProvider, $locationProvider) {
    $routeProvider.when('/game', {
      templateUrl: 'partial/1',
      controller: GameCtrl
    });
    $routeProvider.when('/todo', {
      templateUrl: 'partial/2',
      controller: TodoCtrl
    });
    $routeProvider.otherwise({
      redirectTo: '/game'
    });
    return $locationProvider.html5Mode(true);
  }
]);
