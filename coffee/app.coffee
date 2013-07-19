
	'use strict'

	# Declare app level module which depends on filters, and services

	angular.module('nodePong', [
		'nodePong.filters'
		'nodePong.services'
		'nodePong.directives'
		'gameObjects'
		'ui'
		'ui.bootstrap'
		'mongolab'
	]).config [
			'$routeProvider'
			'$locationProvider'
			'$dialogProvider'
			($routeProvider, $locationProvider, $dialogProvider)->
				$routeProvider.when('/game', {templateUrl: 'partial/1', controller: GameCtrl})
				$routeProvider.when('/todo', {templateUrl: 'partial/2', controller: TodoCtrl})
				$routeProvider.otherwise({redirectTo: '/game'})
				$locationProvider.html5Mode(true)
	]
