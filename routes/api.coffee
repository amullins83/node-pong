exports.name = (req, res)->
  res.json
    name: 'Node Pong'

models = require "../models"

Game = exports.Game = models.Game
User = exports.User = models.User

renderJSON = (res)->
    (err, objects)->
        if(err)
            res.json err
        else
            res.json objects


games = exports.games =        
        get: (req, res)->
            if req.user?
                findObject = {}
                if req.params.id?
                    return Game.findOne(id:req.params.id, players: $all: [req.user]).exec renderJSON(res)
                if req.query?
                    findObject = req.query
                findObject["players"] = { "$all": [req.user] }
                Game.find(findObject).sort("startTime").exec renderJSON(res)
            else
                return res.json {}

        create: (req, res)->
            Game.create req.body, renderJSON(res)
            
        edit:  (req, res)->
            if req.params.id?
                return Game.findOneAndUpdate({id:req.params.id}, req.body.updateObject).exec renderJSON(res)
            Game.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)
            
         destroy: (req, res)->
             if req.params.id?
                 return Game.remove {id: req.params.id}, renderJSON(res)
             Game.remove req.body, renderJSON(res)
                    
        count: (req, res)->
            Game.count renderJSON(res)


users = exports.users  =
        get: (req, res)->
            findObject = {}
            if req.params.id?
                return User.findOne({id:req.params.id}).exec renderJSON(res)
            if req.query?
                findObject = req.query
            User.find(findObject).sort("id").exec renderJSON(res)
        
        create: (req, res)->
            User.create req.body, renderJSON(res)
        
        edit:  (req, res)->
            if req.params.id?
                return User.findOneAndUpdate({id:req.params.id}, req.body.updateObject).exec renderJSON(res)
            User.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)
        
        destroy: (req, res)->
            if req.params.id?
                return User.remove {id: req.params.id}, renderJSON(res)
            User.remove req.body, renderJSON(res)
                
        count: (req, res)->
            User.count renderJSON(res)
