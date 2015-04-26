
fs = require('fs')
path = require('path')
loopback = require("loopback")

module.exports = (app) ->

  # -- Each module  --
  # Load the configuration
  for name, enabled of require('./modules.json')

    do (name) ->
      # -- Boot module scripts  --
      # Module controllers, views, models
      if enabled
        mod = {}
        for filename in fs.readdirSync(path.join(__dirname, name, 'server/boot'))
          if path.extname(filename) in ['.coffee','.js']
            boot = require(path.join(__dirname, name, 'server/boot', filename))
            boot(app, mod)

    # -- Mount static files --
    # All static middleware should be registered at the end, as all requests
    # passing the static middleware are hitting the file system
    app.use loopback.static(path.join(__dirname, name, 'client/public'))
