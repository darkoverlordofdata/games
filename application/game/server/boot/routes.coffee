fs = require('fs')
liquid = require('liquid.coffee')
module.exports = (app, mod) ->

  app.get "/", (req, res) ->
    mod.render(res, 'index')
    return

  app.get "/admin", (req, res) ->
    mod.render(res, 'admin')
    return

  app.get "/asteroids", (req, res) ->
    res.redirect "games/asteroids/asteroids.html"
    return

  app.get "/asteroids", (req, res) ->
    res.redirect "games/asteroids/asteroids.html"
    return
