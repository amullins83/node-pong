(->

    "use strict"
    fs = require "fs"

    
    filePath = require "./filePath"
    
    
    summarize = (path, keepExpression)->
        fs.readdir path, (err, data)->
            for name in data
                folderLocation = filePath(path, name)
                if fs.statSync(folderLocation).isDirectory() and name != "zips"
                    folderData = fs.readdirSync folderLocation
                    summary = ""
                    for file in folderData
                        fileLocation = filePath(folderLocation, file)
                        if file.match(/.rsl$/) and fs.statSync(fileLocation).isFile()
                            summary += file + "\n"
                            text = fs.readFileSync(fileLocation).toString()
                            matchText = text.match(keepExpression)
                            if matchText?
                                for line in matchText
                                    summary += line + "\n"
                        fs.writeFileSync filePath(folderLocation, "labs.txt"), summary

    module.exports = summarize

).call this