# Dependencies

express = require('express')
routes = require('./routes')
api = require('./routes/api')
models = require('./models')

app = module.exports = express()

# Configure

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser({keepExtensions:true})
  app.use express.methodOverride()
  app.use express.static(__dirname + '/public')
  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

# Routes

app.get '/', routes.index
app.post '/', routes.index
app.get '/partial/:name', routes.partial

app.get '/modal/:name', routes.modal

# JSON API

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

# redirect all others to the index (HTML5 history)
app.get '*', routes.index

# Start server

app.listen process.env.PORT, ->
  console.log "Server started ping-ponging on port #{process.env.PORT}"
