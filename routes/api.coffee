exports.name = (req, res)->
  res.json
    name: 'Node Pong'

models = require "../models"

renderJSON = (res)->
    (err, objects)->
        if(err)
            res.json err
        else
            res.json objects

resource = (name, filterFunction)->
    name = name.toLowerCase()
    Name = name[0].toUpperCase() + name[1..]
    Model = models[Name]
    result =
        get: (req, res)->
            filter = filterFunction(req)
            console.dir filter
            if req.user?
                findObject = {}
                if req.params.id?
                    findObject._id = req.params.id
                    for key of filter
                        findObject[key] = filter[key]
                    return Model.findOne(findObject).exec renderJSON(res)
                if req.query?
                    findObject = req.query
                for key of filter
                    findObject[key] = filter[key]
                Model.find(findObject).sort("startTime").exec renderJSON(res)
            else
                return res.json {}

        create: (req, res)->
            Model.create req.body, renderJSON(res)
            
        edit:  (req, res)->
            filter = filterFunction(req)
            findObject = {}
            if req.params.id?
                for key of filter
                    findObject[key] = filter[key]
                findObject._id = req.params.id
                return Model.findOneAndUpdate(findObject, req.body.updateObject).exec renderJSON(res)
            
            for key of filter
                findObject[key] = filter[key]
            for key of req.body.findObject
                findObject[key] = req.body.findObject[key]
            Model.findOneAndUpdate findObject, req.body.updateObject, renderJSON(res)
            
        destroy: (req, res)->
            filter = filterFunction(req)
            findObject = {}
            for key of filter
                findObject[key] = filter[key]
            if req.params.id?
                findObject._id = req.params.id
                return Model.remove findObject, renderJSON(res)
            for key of filter
                findObject[key] = filter[key]
            for key of req.body
                findObject[key] = req.body[key]
            Model.remove findObject, renderJSON(res)

        count: (req, res)->
            filter = filterFunction(req)
            findObject = {}
            for key of filter
                findObject[key] = filter[key]
            Model.count findObject, renderJSON(res)

games = exports.games = resource "Game", (req)->
    players: $all: [req.user._id]

# games = exports.games =        
#         get: (req, res)->
#             if req.user?
#                 findObject = {}
#                 if req.params.id?
#                     return Game.findOne(id:req.params.id, players: $all: [req.user]).exec renderJSON(res)
#                 if req.query?
#                     findObject = req.query
#                 findObject["players"] = { "$all": [req.user] }
#                 Game.find(findObject).sort("startTime").exec renderJSON(res)
#             else
#                 return res.json {}

#         create: (req, res)->
#             Game.create req.body, renderJSON(res)
            
#         edit:  (req, res)->
#             if req.params.id?
#                 return Game.findOneAndUpdate({id:req.params.id}, req.body.updateObject).exec renderJSON(res)
#             Game.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)
            
#          destroy: (req, res)->
#              if req.params.id?
#                  return Game.remove {id: req.params.id}, renderJSON(res)
#              Game.remove req.body, renderJSON(res)
                    
#         count: (req, res)->
#             Game.count renderJSON(res)

users = exports.users = resource "User", (req)->
    _id: req.user._id

# users = exports.users  =
#         get: (req, res)->
#             findObject = {}
#             if req.params.id?
#                 return User.findOne({id:req.params.id}).exec renderJSON(res)
#             if req.query?
#                 findObject = req.query
#             User.find(findObject).sort("id").exec renderJSON(res)
        
#         create: (req, res)->
#             User.create req.body, renderJSON(res)
        
#         edit:  (req, res)->
#             if req.params.id?
#                 return User.findOneAndUpdate({id:req.params.id}, req.body.updateObject).exec renderJSON(res)
#             User.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)
        
#         destroy: (req, res)->
#             if req.params.id?
#                 return User.remove {id: req.params.id}, renderJSON(res)
#             User.remove req.body, renderJSON(res)
                
#         count: (req, res)->
#             User.count renderJSON(res)
