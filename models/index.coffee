"use strict"
class MyArray extends Array:
    find: (findObject)->
        found = []
        for item in this
            isMatch = true
            for element, key in findObject
                unless item[key] == element
                    isMatch = false
                    break
            if isMatch
                found.push item
        return found
    
    update: (findObject, updateObject)->
        objectsFound = this.find(findObject)
        unless objectsFound.length == 0
            objectsToUpdate = objectsFound[0]
            indexToUpdate = this.indexOf objectsToUpdate
            this[indexToUpdate] = updateObject
            return this[indexToUpdate]
        return false

    
mongoose = require "mongoose"


if process.env.TEST_MODE
    mongoose.connect "mongodb://localhost/test"
else
    mongoose.connect process.env.MONGOLAB_URI
            

Model = mongoose.model
Schema = mongoose.Schema
db = exports.db = mongoose.connection
    
    
exports.gameObject = gameObject =
    score: [
        Number
    ]
    players: [
        String
    ]
    startTime: Number
    runTime: Number
    ball:
        pos:
            x: Number
            y: Number
        velocity:
            x: Number
            y: Number
    pad1:
        pos:
            y: Number
        velocity:
            y: Number
    pad2:
        pos:
            y: Number
        velocity:
            y: Number


exports.userObject = userObject =
    firstName: type: String, required: true
    lastName: type: String, required: true
    userName: type: String, required: true, index: unique: true
    email: type: String, required: true, index: unique: true
    password: type: String, required: true
    salt: type: String, required: true
    creationDate: type: Date, index: true
    lastLogin: type: Date, default: new Date
    socialMediaPersonae: [{type: Schema.ObjectId, ref: "SocialMediaUser"}]

exports.Game = {}
exports.User = {}

db.once "open", ->
    exports.Game = mongoose.model "Game", mongoose.Schema gameObject
    exports.User = mongoose.model "User", mongoose.Schema userObject
    console.log "Models Ready"

exports.ready = ready = (models, callback)->
    db.once "open", ->
        models.Game = exports.Game 
        models.User = exports.User
        callback()