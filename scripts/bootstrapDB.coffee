"use strict"

models = require "../models"
grader = []

for chapter, index in ["1_2", "4", "5", "6", "7", "8"]
    grader.push require "../grade/grader_ch#{chapter}"

models.ready ->
    console.log "bootstrapping..."
    Assignment = models.Assignment

    bootstrapAssignment = (grader)->
        (err, assignment)->
            if err?
                console.log err
                return
            console.log assignment
            assignment.problems = []
            for id, problem of grader.problems
                console.log "        problem #{id}..."
                assignment.problems.push
                    id: id
                    example: problem.submission
                    tests: problem.mongooseTests
                console.log "                        pushed into problems array"
            assignment.save (err, updated)->
                if err
                    console.log "#{assignment.name} failed:"
                    console.log err
                else
                    console.log "#{assignment.name} done"


    for chapter, index in ["1_2", "4", "5", "6", "7", "8"]
        console.log "    chapter #{chapter}..."
        g = new grader[index] "./submissions/ch#{chapter}/Examples"
        Assignment.findOne {id: "ch#{chapter}"}, bootstrapAssignment(g)
