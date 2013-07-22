models = models || require "../../models"

renderJSON = (res)->
    (err, objects)->
        if(err)
            res.json err
        else
            res.json objects

module.exports = users = {}


models.ready ->
    users =
        User: models.User

        get: (req, res)->
            findObject = {}
            if req.params.id?
                return @User.findOne({id:req.params.id}).exec renderJSON(res)
            if req.query?
                findObject = req.query
            @User.find(findObject).sort("id").exec renderJSON(res)
    
        create: (req, res)->
            @User.create req.body, renderJSON(res)
    
        edit:  (req, res)->
            if req.params.id?
                return @User.findOneAndUpdate({id:req.params.id}, req.body.updateObject).exec renderJSON(res)
            @User.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)
    
        destroy: (req, res)->
            if req.params.id?
                return @User.remove {id: req.params.id}, renderJSON(res)
            @User.remove req.body, renderJSON(res)
            
        count: (req, res)->
            @User.count renderJSON(res)