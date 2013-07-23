# Dependencies
express = require 'express'
routes = require './routes'
models = require './models'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

app = module.exports = express()

# Configure
app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser({keepExtensions:true})
  app.use express.methodOverride()
  app.use express.static(__dirname + '/public')
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

# Passport Setup

passport.serializeUser (user, done)->
  done null, user.id

User = models.User

passport.deserializeUser (id, done)->
    User.findById id, done

passport.use new LocalStrategy (username, password, done)->
    User.findOne {username: username}, (err, user)->
        if err
            return done err
        unless user
            return done null, false
        user.comparePassword password, (err, match)->
            if err
                return done err

            if match
                return done null, user
            else
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

app.get '/api/games/:id', api.games.get
app.get '/api/games', api.games.get
app.put '/api/games/:id', api.games.edit
app.post '/api/games', api.games.create
app.delete '/api/games/:id', api.games.destroy

app.get '/api/users/:id', api.users.get
app.get '/api/users', api.users.get
app.put '/api/users/:id', api.users.edit
app.post '/api/users', api.users.create
app.delete '/api/users/:id', api.users.destroy

app.get '*', routes.index

#     Login
app.post "/login", passport.authenticate("local", failureRedirect:"/todo"), (req, res)->
    res.redirect "/"

# Start
app.listen process.env.PORT, ->
    console.log "Server started ping-ponging on port #{process.env.PORT}"
