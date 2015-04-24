fs = require('fs')
path = require('path')
loopback = require("loopback")

module.exports = (app, modules) ->

  for name, enabled of modules

    # -- Boot module scripts  --
    if enabled
      do (name) ->
        mod = {}
        for filename in fs.readdirSync(path.join(__dirname, name, 'server/boot'))
          if path.extname(filename) in ['.coffee','.js']
            boot = require(path.join(__dirname, name, 'server/boot', filename))
            boot(app, mod)

    # -- Mount static files here--
    # All static middleware should be registered at the end, as all requests
    # passing the static middleware are hitting the file system
    app.use loopback.static(path.join(__dirname, name, 'client/public'))
