models = models || require "../../models"

models.ready ->
    User = models.User

user =
    get: (req, res)->    
