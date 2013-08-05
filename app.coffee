# Dependencies
connect = require 'connect'
express = require 'express'
routes = require './routes'
models = require './models'
dateformat = require 'dateformat'

SessionStore = require("session-mongoose")(express)
store = new SessionStore
   url: process.env.MONGOLAB_URI

passport = require 'passport'

LocalStrategy = require('passport-local').Strategy
FBStrategy = require('passport-facebook').Strategy

app = module.exports = express()

# Configure
app.configure ->
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.use express.logger()
    app.use express.cookieParser()
    app.use express.bodyParser keepExtensions: true
    app.use express.methodOverride()
    app.use express.static(__dirname + '/public')
    app.use express.session
        store: store
        cookie: maxAge: 12*60*60*1000
        secret: process.env.SESSION_SECRET
    app.use passport.initialize()
    app.use passport.session()
    app.use app.router

app.configure 'development', ->
    app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
    app.use express.errorHandler()

# Passport Setup

passport.serializeUser (user, done)->
    done null, user.id

User = models.User
SocialMediaUser = models.SocialMediaUser

passport.deserializeUser (id, done)->
    User.findById id, done

passport.use new LocalStrategy {usernameField:"email"}, (email, password, done)->
    console.log "Inside LocalStrategy(#{email}, #{password}, #{done})"
    User.findOne {email: email}, (err, user)->
        if err
            console.dir err
            return done err
        unless user
            console.log "No user found"
            return done null, false, "No user found"

        user.comparePassword password, (err, match)->
            if err
                console.dir err
                return done err

            if match
                console.log "Eureka!"
                return done null, user, "Eureka!"
            else
                console.log "Password mismatched"
                return done null, false, "Password mismatched"

passwordGen = (number)->
    number = 8 unless number? and number > 8
    symbols = "-_#$%^&+=?!"
    letters = "abcdefghijklmnopqrstuvwxyz"
    LETTERS = letters.toUpperCase()
    numbers = (String(i) for i in [0..9]).join ""
    chars = [symbols, letters, LETTERS, numbers].join ""
    len = chars.length
    password = ""
    for i in [0...number]
        password += chars[Math.floor Math.random()*len]
    return password

passport.use new FBStrategy
    clientID: process.env.FB_KEY
    clientSecret: process.env.FB_SECRET
    callbackURL: "//#{process.env.HOST}/auth/facebook/callback"
    profileFields: ["id", "displayName", "photos"]
, (accessToken, refreshToken, profile, done)->
    SocialMediaUser.findOneAndUpdate
        providerUserId: profile.id
        providerName: "facebook"
    , 
        providerUserId: profile.id
        displayName: profile.displayName
        providerName: "facebook"
    ,
        upsert: true
    , getLocalUserFromSMUser done

getLocalUserFromSMUser = (done)->
    (err, smUser)->
        done err if err


# Routes
#     Normal
app.get '/', routes.index
app.post '/', routes.index
app.get '/partial/:name', routes.partial

#     Modal
app.get '/modal/:name', routes.modal

#     JSON API
api = require "./routes/api"
app.get '/api/name', api.name

api.games.resourceForApp app
api.users.resourceForApp app



#     Login
app.post "/login", (req, res, next)->
    passport.authenticate("local", (err, user, info)-> 
        if err
            console.dir err
            return next err

        unless user
            req.session.messages = [info.message] if info?
            return res.json {}

        req.logIn user, (err)->
            if err
                console.dir err
                return next err
            res.json req.user
    )(req, res, next)

app.get "/auth/facebook",
    passport.authenticate 'facebook'

app.get "/auth/facebook/callback", (req, res, next)->
    passport.authenticate('facebook', (err, socialMediaUser, info)->
        if err
            console.dir err
            return next err

        unless socialMediaUser
            req.session.messages = [info.message] if info?
            return res.json {}

        if req.user?
            User.findOne
                _id: req.user._id
            , (err, user)->
                next err if err
                next null, false unless user?
                user.socialMediaPersonae.push socialMediaUser._id
                user.save (err, user)->
                    next err if err
                    next null, false unless user?
        else
            User.findOne
                socialMediaPersonae: "$all": [smUser._id]
            , (err, user)->
                next err if err
                if user?
                    req.logIn user, (err)->
                        next err if err
                        res.json req.user
                else
                    User.create
                        displayName: smUser.displayName
                        email: "#{smUser.providerUserId}@#{smUser.providerName}.com"
                        userName: smUser.providerUserId
                        firstName: smUser.displayName.split(" ")[0]
                        lastName: smUser.displayName.split(" ")[-1..][0]
                        password: passwordGen 12
                        socialMediaPersonae: [smUser._id]
                    , (err, user)->
                        next err if err
                        req.logIn user, (err)->
                            next err if err
                            res.json req.user

        req.logIn socialMediaUser, (err)->
            if err
                console.dir err
                return next err
            res.json req.user
    )(req, res, next)

logout = (req, res)->
    req.logout()
    res.redirect "/"

app.post "/logout", logout

app.delete "/logout", (req, res)->
    req.logout()
    res.json message:"logout succeeded"

app.get "/logout", logout


#FB Channel
#    set an expiration date 1 year into the future.
expireDate = new Date
expireDate.setTime expireDate.getTime() + 365*24*60*60*1000
#    set response headers to force long-term caching
#    then send a script link as the content of the response.
app.get "/fbChannel", (req, res)->
    oneYear = 60*60*24*365
    res.setHeader "Pragma", "public"
    res.setHeader "Cache-Control", "max-age=#{oneYear}"
    res.setHeader "Expires",  dateformat(expireDate, "dddd, d mmmm yyyy H:MM:ss", true) + " GMT"
    res.end '<script src="//connect.facebook.net/en_US/all.js"></script>'

app.get '*', routes.index

# Start
app.listen process.env.PORT, ->
    console.log "Server started ping-ponging on port #{process.env.PORT}"
