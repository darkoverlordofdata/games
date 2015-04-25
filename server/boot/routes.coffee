#slash   = require('express-slash');

module.exports = (app) ->
  
  # Install a `/` route that returns server status
  router = app.loopback.Router
    caseSensitive: app.get('case sensitive routing')
    strict       : app.get('strict routing')


  router.get "/status", app.loopback.status()
  app.use router
#  app.use slash()
  return
