loopback = require("loopback")
boot = require("loopback-boot")
app = module.exports = loopback()

# Passport configurators..
loopbackPassport = require("loopback-component-passport")
PassportConfigurator = loopbackPassport.PassportConfigurator
passportConfigurator = new PassportConfigurator(app)

#
# * body-parser is a piece of express middleware that
# *   reads a form's input and stores it as a javascript
# *   object accessible through `req.body`
# *
# 
bodyParser = require("body-parser")

###*
Flash messages for passport

Setting the failureFlash option to true instructs Passport to flash an
error message using the message given by the strategy's verify callback,
if any. This is often the best approach, because the verify callback
can make the most accurate determination of why authentication failed.
###
flash = require("express-flash")

# attempt to build the providers/passport config
config = {}
try
  config = require("./providers.json")
catch err
  console.trace err
  process.exit 1 # fatal

# Set up the /favicon.ico
app.use loopback.favicon()

# request pre-processing middleware
app.use loopback.compress()

# -- Add your pre-processing middleware here --

# Setup the view engine (jade)
path = require("path")
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

# boot scripts mount components like REST API
boot app, __dirname

# to support JSON-encoded bodies
app.use bodyParser.json()

# to support URL-encoded bodies
app.use bodyParser.urlencoded(extended: true)

# The access token is only available after boot
app.use loopback.token(model: app.models.accessToken)
app.use loopback.cookieParser(app.get("cookieSecret"))
app.use loopback.session(
  secret: "kitty"
  saveUninitialized: true
  resave: true
)
passportConfigurator.init()

# We need flash messages to see passport errors
app.use flash()
passportConfigurator.setupModels
  userModel: app.models.user
  userIdentityModel: app.models.userIdentity
  userCredentialModel: app.models.userCredential

for s of config
  c = config[s]
  c.session = c.session isnt false
  passportConfigurator.configureProvider s, c
ensureLoggedIn = require("connect-ensure-login").ensureLoggedIn
app.get "/", (req, res, next) ->
  res.render "pages/index",
    user: req.user
    url: req.url

  return

app.get "/auth/account", ensureLoggedIn("/login"), (req, res, next) ->
  res.render "pages/loginProfiles",
    user: req.user
    url: req.url

  return

app.get "/link/account", ensureLoggedIn("/login"), (req, res, next) ->
  res.render "pages/linkedAccounts",
    user: req.user
    url: req.url

  return

app.get "/local", (req, res, next) ->
  res.render "pages/local",
    user: req.user
    url: req.url

  return

app.get "/signup", (req, res, next) ->
  res.render "pages/signup",
    user: req.user
    url: req.url

  return

app.post "/signup", (req, res, next) ->
  User = app.models.user
  newUser = {}
  newUser.email = req.body.email.toLowerCase()
  newUser.username = req.body.username.trim()
  newUser.password = req.body.password
  User.create newUser, (err, user) ->
    if err
      req.flash "error", err.message
      res.redirect "back"
    else
      
      # Passport exposes a login() function on req (also aliased as logIn())
      # that can be used to establish a login session. This function is
      # primarily used when users sign up, during which req.login() can
      # be invoked to log in the newly registered user.
      req.login user, (err) ->
        if err
          req.flash "error", err.message
          return res.redirect("back")
        res.redirect "/auth/account"

    return

  return

app.get "/login", (req, res, next) ->
  res.render "pages/login",
    user: req.user
    url: req.url

  return

app.get "/link", (req, res, next) ->
  res.render "pages/link",
    user: req.user
    url: req.url

  return

app.get "/auth/logout", (req, res, next) ->
  req.logout()
  res.redirect "/"
  return


# -- Mount static files here--
# All static middleware should be registered at the end, as all requests
# passing the static middleware are hitting the file system
# Example:
path = require("path")
app.use loopback.static(path.resolve(__dirname, "../client/public"))

# Requests that get this far won't be handled
# by any middleware. Convert them into a 404 error
# that will be handled later down the chain.
app.use loopback.urlNotFound()

# The ultimate error handler.
app.use loopback.errorHandler()
app.start = ->
  
  # start the web server
  app.listen ->
    app.emit "started"
    console.log "Web server listening at: %s", app.get("url")
    return

# start the server if `$ node server.js`
if path.basename(require.main.filename) is 'server.js'
  app.start()
