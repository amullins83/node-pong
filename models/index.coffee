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
    id: String
    score: [
        Number
    ]
    players: [
        String
    ]


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
    submissions: Schema.Types.Mixed


exports.ready = ready = (handler)->
    db.once "open", handler
    
    
ready ->
    Game = exports.Game = mongoose.model "Game", mongoose.Schema gameObject
    User = exports.User = mongoose.model "User", mongoose.Schema userObject
    console.log "Models Ready"