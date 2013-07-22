"use strict"
knox = require 'knox'

client = knox.createClient
    key: process.env.S3_KEY
    secret: process.env.S3_SECRET
    bucket: "node-pong"

module.exports = ->
    client.putFile "../dist/css/application.css", "assets/css/application.css", (err)->
        unless err
            client.putFile "../dist/js/application.js", "assets/js/application.js", (err)->
                report err if err
        else
            report err

report = (err)->
    console.dir err
