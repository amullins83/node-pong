(->

    "use strict"

    class Find
        constructor: ->
    
        @match: (testObject, findObject)->
            isMatch = true
            for property of testObject
                if typeof testObject[property] == "object"
                    isMatch = typeof findObject[property] == "object" and @match testObject[property], findObject[property]
                else
                    unless testObject[property] == findObject[property]
                        isMatch = false
                        break
            return isMatch

        @find: (array, findObject)->
            for element, index in array
                if @match findObject, element
                    return index
            return -1
    
        @filter: (array, regExp)->
            output = []
            for element in array
                output.push element if element.match regExp
            return output

        @filterOut: (array, regExp)->
            output = []
            for element in array
                output.push element unless element.match regExp
            return output

    module.exports = Find
).call this