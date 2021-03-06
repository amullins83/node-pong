# GET home page.

exports.index = (req, res)->
  res.render 'index', user: req.user

exports.partial = (req, res)->
  name = req.params.name
  res.render "partials/partial#{name}", user: req.user

exports.modal = (req, res)->
    name = req.params.name
    res.render "modals/#{name}", user: req.user