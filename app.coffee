# Dependencies
connect = require 'connect'
express = require 'express'
routes = require './routes'
models = require './models'

#SessionStore = require("session-mongoose")(express)
#store = new SessionStore
#    url: process.env.MONGOLAB_URI
#    sweeper: false

passport = require 'passport'

LocalStrategy = require('passport-local').Strategy

app = module.exports = express()

# Configure
app.configure ->
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.use express.logger()
    app.use express.cookieParser()
    app.use express.bodyParser keepExtensions: true
    app.use express.methodOverride()
    app.use express.static(__dirname + '/public')
    app.use express.session
        secret: process.env.SESSION_SECRET
    app.use passport.initialize()
    app.use passport.session()
    app.use app.router

app.configure 'development', ->
    app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
    app.use express.errorHandler()

# Passport Setup

passport.serializeUser (user, done)->
    done null, user.id

User = models.User

passport.deserializeUser (id, done)->
    User.findById id, done

passport.use new LocalStrategy {usernameField:"email"}, (email, password, done)->
    console.log "Inside LocalStrategy(#{email}, #{password}, callback)"
    User.findOne {email: email}, (err, user)->
        if err
            console.dir err
            return done err
        unless user
            console.log "No user found"
            return done null, false

        user.comparePassword password, (err, match)->
            if err
                console.dir err
                return done err

            if match
                console.log "Eureka!"
                return done null, user
            else
                console.log "Password mismatched"
                return done null, false

# Routes
#     Normal
app.get '/', routes.index
app.post '/', routes.index
app.get '/partial/:name', routes.partial

#     Modal
app.get '/modal/:name', routes.modal

#     JSON API
api = require "./routes/api"
app.get '/api/name', api.name

api.games.resourceForApp app
api.users.resourceForApp app

app.get '*', routes.index

#     Login
app.post "/login", (req, res, next)->
    passport.authenticate("local", (err, user, info)-> 
        if err
            console.dir error
            return next err

        unless user
            req.session.messages = [info.message]
            return res.json {}

        req.logIn user, (err)->
            if err
                console.dir err
                return next err
            res.json req.user
    )(req, res, next)

logout = (req, res)->
    req.logout()
    res.redirect "/"

app.post "/logout", logout

app.delete "/logout", (req, res)->
    req.logout()
    res.json message:"logout succeeded"

app.get "/logout", logout



# Start
app.listen process.env.PORT, ->
    console.log "Server started ping-ponging on port #{process.env.PORT}"
