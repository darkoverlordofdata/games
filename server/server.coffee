###

    _____                   ____      ___
   / ___/__ ___ _  ___ ____/ __ \____/ _ \___ ___ _  ___ _
  / (_ / _ `/  ' \/ -_)___/ /_/ /___/ , _/ _ `/  ' \/ _ `/
  \___/\_,_/_/_/_/\__/    \____/   /_/|_|\_,_/_/_/_/\_,_/


###
loopback = require("loopback")
boot = require("loopback-boot")
core = require('./core')
path = require('path')
fs = require('fs')

app = module.exports = loopback()
app.enable('strict routing')


#
# * Console logging requests.
# * use smallest format in production
# * color coded log in dev
#
if app.get('env') is 'production'
  app.use require('morgan')('tiny')
else
  app.use require('morgan')('dev')

#
# * Passport configurators..
#
loopbackPassport = require("loopback-component-passport")
PassportConfigurator = loopbackPassport.PassportConfigurator
passportConfigurator = new PassportConfigurator(app)

#
# * body-parser is a piece of express middleware that
# *   reads a form's input and stores it as a javascript
# *   object accessible through `req.body`
#
bodyParser = require("body-parser")

#
# * Flash messages for passport
# *
# * Setting the failureFlash option to true instructs Passport to flash an
# * error message using the message given by the strategy's verify callback,
# * if any. This is often the best approach, because the verify callback
# * can make the most accurate determination of why authentication failed.
#
flash = require("express-flash")

#
# * Set up the /favicon.ico
#
app.use loopback.favicon()

#
# * request pre-processing middleware
#
app.use loopback.compress()

#
# * boot scripts mount components like REST API
#
boot app, __dirname

#
# * to support JSON-encoded bodies
#
app.use bodyParser.json()

#
# to support URL-encoded bodies
#
app.use bodyParser.urlencoded(extended: true)

#
# * The access token is only available after boot
#
app.use loopback.token(model: app.models.accessToken)
app.use loopback.cookieParser(app.get("cookieSecret"))

#
# * Use sessions to save passport tokens
#
RedisStore = require('connect-redis')(loopback.session)
app.use loopback.session
  secret: process.env.OPENSHIFT_SECRET_TOKEN or 'Kh2RWaQO1SbU55UbnWXZ8jO3L8JH35zF'
  saveUninitialized: true
  resave: true
  store: new RedisStore(if app.get('env') is 'production'
    host: process.env.REDISCLOUD_URL
    port: process.env.REDISCLOUD_PORT
    pass: process.env.REDISCLOUD_PASSWORD
  else {})

#
# * Passport Configuration
#
passportConfigurator.init()

#
# * We need flash messages to see passport errors
#
app.use flash()

#
# * Configure the passport models
#
passportConfigurator.setupModels
  userModel: app.models.user
  userIdentityModel: app.models.userIdentity
  userCredentialModel: app.models.userCredential

#
# * Configure the passport providers
#
providers = require("./providers.json")
providers['google-login']['clientID'] = process.env.GOOG_CLIENT_ID
providers['google-login']['clientSecret'] = process.env.GOOG_CLIENT_SECRET
do -> # each
  for name, provider of providers
    provider.session = provider.session isnt false
    passportConfigurator.configureProvider name, provider

#
# * Set 'global' static root and views
# * Set default template engine to ejs
#
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')
app.use(loopback.static(path.resolve(__dirname, '../client/public')))
#
# * Load MMVC applications
# * each module has it's own static content,
# * models, views, controllers, etc.
#
modular = require('../application')
modular app

#
# * Requests that get this far won't be handled
# * by any middleware. Convert them into a 404 error
# * that will be handled later down the chain.
#
app.use core.errorHandler()

#
# *
# * The ultimate (final) error handler.
# *
#
app.use core.urlNotFound()

#
# * start the server if `$ node server.js`
# * for use by slc arc
#
if path.basename(require.main.filename) is 'server.js'
  app.listen ->
    app.emit "started"
    console.log "Web server listening at: %s", app.get("url")
    return
