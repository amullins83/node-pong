bcrypt = require "bcrypt"
models = require "../models"

User = models.User
hashy = {}
salty = {}
password = "abcd1234"
u =
    email: "a@a.com"
    password: password


models.ready ->
    User.create u, gotUser


gotUser = (err, user)->
    throw err if err?

    console.dir user

    console.log "User hash is #{user.password}"
    console.log "Original password was #{password}"
    
    #user.remove destroyed


destroyed = (err)->
    throw err if err?

    console.log "Destroyed user #{u.email}"
