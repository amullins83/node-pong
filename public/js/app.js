'use strict';
angular.module('nodePong', ['nodePong.filters', 'nodePong.services', 'nodePong.directives', 'gameObjects', 'ui', 'ui.bootstrap', 'mongolab']).config([
  '$routeProvider', '$locationProvider', '$dialogProvider', function($routeProvider, $locationProvider, $dialogProvider) {
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
