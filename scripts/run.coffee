( ->
    "use strict"

    scripts = require "./scripts.coffee"
    fs = require "fs"
    
    fs.readdir "./submissions", (err, folderList)->
        return "Error reading file" if err?
        for folder in folderList
            folderLocation = "./submissions/" + folder
            if fs.statSync(folderLocation).isDirectory() and folder != "Homework"
                scripts.summarize folderLocation, /SOR,\d+ .* EOR,\d+/g
                scripts.compare folderLocation
).call this