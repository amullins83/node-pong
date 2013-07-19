
    'use strict'

    # Filters

    angular.module('nodePong.filters', []).filter('interpolate', [
        'version',
        (version)->
            (text)-> String(text).replace /\%VERSION\%/mg, version
    ]).filter 'wordCount', ->
        (text)->
            count = String(text).split(" ").length
            if !text? || text.length == 0
                return 0
            else
                return count
