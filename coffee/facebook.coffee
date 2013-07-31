$(document).ready ->
    $.ajaxSetup
        cache: true

    $.getScript '//connect.facebook.net/en_US/all.js', ->
        FB.init 
            appId: 483976228358350
            channelUrl: "//node-pong.herokuapp.com/fbChannel"
            status: true
            cookie: true
            xfbml: true

        fbInitialize()

testAPI = ->
    console.log 'Welcome!  Fetching your information.... '
    FB.api '/me', (response)->
      console.log 'Good to see you, ' + response.name + '.'

updateStatusCallback = (status)->
    testAPI() if status.status == 'connected'

fbInitialize = ->
    console.log "Initializing FB"
    FB.Event.subscribe 'auth.authResponseChange', (response)->
        if response.status == 'connected'
            testAPI()
        else if response.status == 'not_authorized'
            console.log "This fb user has not authorized this app"
        else
            console.log "This user is not logged in to FB"

    FB.getLoginStatus updateStatusCallback