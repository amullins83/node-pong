exports.name = (req, res)->
  res.json
    name: 'Node Pong'

exports.games = games = require "./api/games"

Game = exports.Game = games.Game

exports.user = require "./api/user"
