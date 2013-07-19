	'use strict'

	# Directives


	angular.module('nodePong.directives', []).directive('appVersion', [
		'version',
		(version)->
			(scope, elm, attrs)->
	      		elm.text version
	]).directive('validColor', [
		'minWords',
		'maxWords',
		(minWords, maxWords)->
			(scope, elm, attrs)->
				setColor =  ->
					numWords = elm.text()
					if (numWords <= maxWords && numWords >= minWords)
						textColor = "#00aa00"
					else
						textColor = "#ff8888"
					elm.css({color:textColor})

				$(document).ready setColor
				$(document).on "keyup", "textarea", setColor
	])
