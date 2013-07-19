(->

    "use strict"
    fs = require "fs"
    
    filePath = (path, name)->
        return path + "/" + name
    
    rename = (path, findExpression, replaceExpression)->
        data = fs.readdirSync path
        for file in data
            fileLocation = filePath path, file
            replaceVariables = replaceExpression.match /\$(\d+)/g
            interpolatedExpression = replaceExpression
            if replaceVariables? and file.match(findExpression)?
                for variable, index in file.match findExpression
                    interpolatedExpression = interpolatedExpression.replace new RegExp("\\$#{index}","g"), variable.toLowerCase()
            newName = file.replace findExpression, interpolatedExpression
            newPath = filePath path, newName
            fs.renameSync fileLocation, newPath

    module.exports = rename
).call this