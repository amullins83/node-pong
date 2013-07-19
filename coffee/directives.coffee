'use strict'

# Directives


Directives = angular.module('nodePong.directives', [])

Directives.directive 'appVersion', [
	'version',
	(version)->
		(scope, elm, attrs)->
	      	elm.text version
]

Directives.directive 'onKeyup',
    (scope, elm, attrs)->
        applyKeyup = (key)->
          scope.key = key
          scope.$apply attrs.onKeyup
        
        allowedKeys = scope.$eval attrs.keys

        elm.bind 'keyup', (evt)->
            # if no key restriction specified, always fire
            unless allowedKeys? and allowedKeys.length
                applyKeyup(evt.which)
            else
                angular.forEach allowedKeys, (key)->
                    if key == evt.which
                        applyKeyup(key)
