models = require "../../models"

renderJSON = (res)->
    (err, objects)->
        if(err)
            res.json err
        else
            res.json objects

module.exports =
        Game: models.Game
        
        get: (req, res)->
            findObject = {}
            if req.params.id?
                return @Game.findOne({id:req.params.id}).exec renderJSON(res)
            if req.query?
                findObject = req.query
            @Game.find(findObject).sort("startTime").exec renderJSON(res)
            
        create: (req, res)->
            @Game.create req.body, renderJSON(res)
            
        edit:  (req, res)->
            if req.params.id?
                return @Game.findOneAndUpdate({id:req.params.id}, req.body.updateObject).exec renderJSON(res)
            @Game.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)
            
         destroy: (req, res)->
             if req.params.id?
                 return @Game.remove {id: req.params.id}, renderJSON(res)
             @Game.remove req.body, renderJSON(res)
                    
        count: (req, res)->
            @Game.count renderJSON(res)