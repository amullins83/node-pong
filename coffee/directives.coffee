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
        console.log $element.attr "class"
        handleName = "on" + eventName[0].toUpperCase() + eventName[1..]
        onFn = $scope.$eval $attrs[handleName]
        functionName = $attrs[handleName]
        console.log "#{handleName} calls #{functionName}, which is:"
        console.dir onFn
        allowedKeys = $scope.$eval $attrs.keys
        console.log allowedKeys
        $element.bind eventName, (evt)->
            console.log "Detected key event"
            validKey = true
            if allowedKeys? and allowedKeys.length?
                validKey = false
                angular.forEach allowedKeys, (key)->
                    if key == evt.which
                        validKey = true
            if validKey
                console.log "Key changed state!"
                $scope.$apply ->
                    onFn.call $scope, evt.which

Directives.directive 'onKeyup', ->
    handle "keyup"

Directives.directive 'onKeydown', ->
    handle "keydown"