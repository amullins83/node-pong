exports.name = (req, res)->
  res.json
    name: 'Node Pong'

exports.games = games = require "./api/games"

Game = exports.Game = games.Game

users = exports.users = require "./api/users"

User = exports.User = users.User