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

resource = (name, filterFunction, sortFunction)->
    name = name.toLowerCase()
    Name = name[0].toUpperCase() + name[1..]
    Model = models[Name]
    pluralize = (word)->
            return word + 's' unless word[word.length - 1].toLowerCase() in ['s', 'x', 'y']
            return word[..-2] + 'ies' if word[word.length -1] == 'y'
            return word + 'es'
    name = pluralize name

    result =
        name: name + "s"

        get: (req, res)->
            filter = filterFunction(req)
            sort = sortFunction()
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
                Model.find(findObject).sort(sort).exec renderJSON(res)
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

        resourceForApp: (app)->
            app.get "/api/#{@name}/:id", @get
            app.get "/api/#{@name}", @get
            app.put "/api/#{@name}/:id", @edit
            app.post "/api/#{@name}", @create
            app.delete "/api/#{@name}/:id", @destroy

games = exports.games = resource "Game", (req)->
    if req.user? and req.user._id?
        return players: $all: [req.user._id]
    else
        return players: 'No user defined'
, ->
    return "startTime"

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
    if req.user? and req.user._id?
        return _id: req.user._id
    else
        return _id: 'No user defined'
, ->
    return "userName"
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
