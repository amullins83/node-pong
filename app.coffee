# Dependencies

express = require('express')
routes = require('./routes')
api = require('./routes/api')
#models = require('./models')

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

#app.get '/api/assignments/:id', api.assignments.get
#app.get '/api/assignments', api.assignments.get
#app.put '/api/assignments/:id', api.assignments.edit
#app.post '/api/assignments', api.assignments.create
#app.delete '/api/assignments/:id', api.assignments.destroy

#app.post '/api/grade/:problemId', api.grade.post

#app.get '/api/user/:id', api.user.get

# redirect all others to the index (HTML5 history)
app.get '*', routes.index

# Start server

app.listen process.env.PORT, ->
  console.log "Server started ping-ponging on port #{process.env.PORT}"
