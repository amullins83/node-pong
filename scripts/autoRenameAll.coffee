( ->
    "use strict"
    renameAll = require "./renameAll.coffee"
    fs = require "fs"
    Find = require "../models/find.coffee"

    autoRenameAll = ->    
        replacements =
            dotsToDashes:
                regex   : /(\d+)\.([\(\)\w]+)\.rsl/
                replace : "$1-$2.rsl"
        
            toLowerCase:
                regex   : /([A-Z])/
                replace : "$1"
        
            removeLeading:
                regex   : /^[\w\s]+(\d+)[-\.]/
                replace : "$1-"
        
            addZeros:
                regex   : /-(\d)\(?([A-Za-z]?)\)?\.rsl/
                replace : "-0$1$2.rsl"
    
            removeParens:
                regex   : /\((\w+)\)/
                replace : "$1"

            removeSpaces:
                regex   : /\s/g
                replace : ""
                
        chapters = fs.readdirSync("./submissions")
        Find.filterOut(chapters, /^\./)
        for chapter in chapters
            if fs.statSync("./submissions/#{chapter}").isDirectory()
                for name, {regex: regex, replace: replace} of replacements
                    renameAll "./submissions/#{chapter}", regex, replace

    module.exports = autoRenameAll 
).call this