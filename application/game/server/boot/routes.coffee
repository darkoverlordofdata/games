#
# * Games controllers
# *
# * Use app.all
#
fs = require('fs')
liquid = require('liquid.coffee')
ensureLoggedIn = require("connect-ensure-login").ensureLoggedIn

module.exports = (app, mod) ->

  #
  # * Home page for the site
  # *
  #
  app.all '/', (req, res) ->
    mod.render(res, 'index')
    return

  #
  # * Administrative functions
  # * The use will have to login
  # *
  #
  app.get '/admin', (req, res) ->
    mod.render(res, 'admin')
    return

  #
  # * Play a game
  # * Use app.all for FB compatability
  # * This dynamically serves up a game folder
  # *
  #
  app.all '/game/:name', (req, res) ->
    res.redirect req.params.name+'/'+req.params.name+'.html'
    return