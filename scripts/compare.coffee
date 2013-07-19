(->

    "use strict"
    fs = require "fs"
    filePath = require "./filePath"
    
    
    diffs = (string1, string2)->
        output = ""
        lines1 = string1.split "\n"
        lines2 = string2.split "\n"
        foundDiff = false
        index1 = index2 = 0
        for index1 in [0...lines1.length]
            line1 = lines1[index1]
            if index2 < lines2.length
                line2 = lines2[index2]
    
            unless line1 == line2 or (line1.match(/\.rsl/) and not line2.match(/\.rsl/))
                output += "Student Response <<<<\n#{line1}\nCorrect Answer >>>>\n#{line2}\n\n"
                foundDiff ||= true
    
            if line1.match /\.rsl/
                unless foundDiff
                    output += " Good!\n\n"
                index2 += 1 until not(lines2[index2]?) or lines2[index2].match(/\.rsl/) or index2 == lines2.length - 1
                index2 += 1
                output += line1 + "\n"
                foundDiff = false
            else unless line2.match /\.rsl/
                index2 += 1
    
        return output
    
    compare = (path)->
        fs.readdir path, (err, data)->
            answers = fs.readFileSync(filePath(path, "Examples/labs.txt")).toString()
            for name in data
                unless name == "Examples" or name == "zips"
                    folderLocation = filePath(path, name)
                    if fs.statSync(folderLocation).isDirectory()
                        fileLocation = filePath(folderLocation, "labs.txt")
                        folderData = fs.readdirSync(folderLocation)
                        foundLabs = false
                        for file in folderData
                            if file == "labs.txt"
                                foundLabs = true
                                break
                        if foundLabs
                            studentLabs = fs.readFileSync(filePath(folderLocation, "labs.txt")).toString()
                            fs.writeFileSync(filePath(folderLocation, "diffs.txt"), diffs(studentLabs, answers))

    module.exports = compare
    
).call this