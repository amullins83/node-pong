'use strict'

# Directives


Directives = angular.module('nodePong.directives', [])

Directives.directive 'appVersion', [
	'version',
	(version)->
		(scope, elm, attrs)->
	      	elm.text version
]

handle = (eventName)->
    ($scope, $element, $attrs)->
        handleName = "on" + eventName[0].toUpperCase() + eventName[1..]
        onFn = $scope.$eval $attrs[handleName]
        functionName = $attrs[handleName]
        allowedKeys = $scope.$eval $attrs.keys
        $(document).bind eventName, (evt)->
            validKey = true
            if allowedKeys? and allowedKeys.length?
                validKey = false
                angular.forEach allowedKeys, (key)->
                    if key == evt.keyCode
                        validKey = true
            if validKey
                $scope.$apply ->
                    onFn.call $scope, evt.keyCode

Directives.directive 'onKeyup', ->
    handle "keyup"

Directives.directive 'onKeydown', ->
    handle "keydown"
