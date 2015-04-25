fs = require('fs')
liquid = require('liquid.coffee')
module.exports = (app, mod) ->

  app.all '/', (req, res) ->
    mod.render(res, 'index')
    return

  app.all '/admin', (req, res) ->
    mod.render(res, 'admin')
    return

  app.all '/asteroidz', (req, res) ->
    res.redirect 'games/asteroids/asteroids.html'
    return
    
#  app.all /\/asteroids\/\?.*/, (req, res) ->
#    res.redirect 'games/asteroids/asteroids.html'
#    return

