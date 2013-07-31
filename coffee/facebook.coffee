"use strict"

fbInitialize = ->

window.fbAsyncInit = ->
    FB.init 
        appId: process.env.FB_KEY
        channelUrl: "//node-pong.herokuapp.com/fbChannel"
        status: true
        xfbml: true

    fbInitialize()

((d, s, id)->
    fjs = d.getElementsByTagName(s)[0]
    return if d.getElementById id
    js = d.createElement s
    js.id = id
    js.src = "//connect.facebook.net/en_US/all.js"
    fjs.parentNode.insertBefore(js, fjs)
)(document, 'script', 'facebook-jssdk')