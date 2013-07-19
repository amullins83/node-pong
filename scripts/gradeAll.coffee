(->

    "use strict"
    fs = require "fs"

    Grader_ch1_2 = require "../grade/grader_ch1_2.coffee"
    Grader_ch4   = require "../grade/grader_ch4.coffee"
    Grader_ch5   = require "../grade/grader_ch5.coffee"
    Grader_ch6   = require "../grade/grader_ch6.coffee"
    Grader_ch7   = require "../grade/Grader_ch7.coffee"
    Grader_ch8   = require "../grade/grader_ch8.coffee"
    
    gradeAll = ->
        chapterMap =
            ch1_2: Grader_ch1_2
            ch4:   Grader_ch4
            ch5:   Grader_ch5
            ch6:   Grader_ch6
            ch7:   Grader_ch7
            ch8:   Grader_ch8
    
        for chapter, grader of chapterMap
            path = "./submissions/#{chapter}"
            data = fs.readdirSync(path)
                
            for folder in data
                folderLocation = "#{path}/#{folder}"
                if fs.existsSync folderLocation
                    if fs.statSync(folderLocation).isDirectory() and not folderLocation.match(/(zips|examples)/i)?
                        gradingPath = folderLocation
                        myGrader = new grader gradingPath
                        feedbackText = myGrader.feedback + "\nGrade: " + myGrader.grade
                        fs.writeFile((gradingPath + "/" + "feedback.txt"), feedbackText)

    module.exports = gradeAll
    
).call this