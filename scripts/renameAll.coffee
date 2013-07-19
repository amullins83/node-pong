  (->
   

    "use strict"
    fs = require "fs"
    rename = require "./rename"
    filePath = require "./filePath"
    
    renameAll = (path, findExpression, replaceExpression)->
        data = fs.readdirSync path
            
        for folder in data
            if fs.statSync(filePath(path, folder)).isDirectory() and folder isnt "zips"
                rename filePath(path, folder), findExpression, replaceExpression
    
    module.exports = renameAll

  ).call this