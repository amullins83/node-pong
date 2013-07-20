'use strict'

# Directives


Directives = angular.module('nodePong.directives', [])

Directives.directive 'appVersion', [
	'version',
	(version)->
		(scope, elm, attrs)->
	      	elm.text version
]