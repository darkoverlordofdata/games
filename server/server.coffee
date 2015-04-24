###

    _____                   ____      ___
   / ___/__ ___ _  ___ ____/ __ \____/ _ \___ ___ _  ___ _
  / (_ / _ `/  ' \/ -_)___/ /_/ /___/ , _/ _ `/  ' \/ _ `/
  \___/\_,_/_/_/_/\__/    \____/   /_/|_|\_,_/_/_/_/\_,_/


###
loopback = require("loopback")
boot = require("loopback-boot")
path = require('path')
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

# Set up the /favicon.ico
app.use loopback.favicon()

# request pre-processing middleware
app.use loopback.compress()

# boot scripts mount components like REST API
boot app, __dirname

#
# to support JSON-encoded bodies
app.use bodyParser.json()

# to support URL-encoded bodies
app.use bodyParser.urlencoded(extended: true)

## The access token is only available after boot
app.use loopback.token(model: app.models.accessToken)
app.use loopback.cookieParser(app.get("cookieSecret"))

# Use secure session cookies
session =
  secret: process.env.OPENSHIFT_SECRET_TOKEN or 'Kh2RWaQO1SbU55UbnWXZ8jO3L8JH35zF'
  saveUninitialized: true
  resave: true
#if app.get('env') is 'production'
#  app.set('trust proxy', 1)
#  session.cookie.secure = true

app.use loopback.session(session)
passportConfigurator.init()

# We need flash messages to see passport errors
app.use flash()
passportConfigurator.setupModels
  userModel: app.models.user
  userIdentityModel: app.models.userIdentity
  userCredentialModel: app.models.userCredential

# Configure the providers
for s, c of require("./providers.json")
  c.session = c.session isnt false
  passportConfigurator.configureProvider s, c


# Load Modular MVC
# each module has it's own static content,
# models, views, controllers, etc.
modules = require('../modules')
modules app, require('./modules.json')

# Requests that get this far won't be handled
# by any middleware. Convert them into a 404 error
# that will be handled later down the chain.
app.use loopback.urlNotFound()

# The ultimate (final) error handler.
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
