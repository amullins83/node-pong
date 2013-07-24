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
bcrypt = require "bcrypt"


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
    startTime: Date
    runTime: Number
    events: [
        name: String
        user: String
        time: Date
    ]
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

Game = exports.Game = mongoose.model "Game", mongoose.Schema gameObject


exports.userObject = userObject =
    firstName: type: String
    lastName: type: String
    userName: type: String
    email: type: String, required: true, index: unique: true
    password: type: String, required: true
    creationDate: type: Date, index: true
    lastLogin: type: Date, default: new Date
    socialMediaPersonae: [{type: Schema.ObjectId, ref: "SocialMediaUser"}]

userSchema = mongoose.Schema userObject

userSchema.pre "save", (next)->
    unless @isModified 'password'
        return next()

    bcrypt.genSalt parseInt(process.env.SALT_WORK_FACTOR, 10), (err, salt)=>
        if err
            return next err

        bcrypt.hash @password, salt, (err, hash)=>
            if err
                return next err
            @password = hash
            @salt = salt
            next()

userSchema.methods.comparePassword = (candidatePassword, cb)->
    bcrypt.compare candidatePassword, @password, (err, isMatch)->
        if err
            console.dir err
            return cb err
        cb null, isMatch


User = exports.User = mongoose.model "User", userSchema

db.once "open", ->
    console.log "Models Ready"

exports.ready = ready = (callback)->
    db.once "open", callback
