#
# * Games controllers
# *
# * Use app.all
#
fs = require('fs')
path = require('path')
zipdir = require('zip-dir')
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

  app.get '/about', (req, res, next) ->
    mod.render(res, 'about', {})
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

  #
  # * Download a game
  # * Download folder contents in zip format
  # * Name as name.nw to run with NodeWebKit on desktop
  # *
  #
  app.get '/nw/:name', (req, res) ->
    zipdir path.join(__dirname, '../../client/public/game/', req.params.name), (err, data) ->
      return req.next(err) if err

      res.set('Content-Type', 'application/zip')
      res.set('Content-Disposition', 'attachment; filename='+req.params.name+'.nw')
      res.set('Content-Length', data.length)
      res.end(data, 'binary')
      return


  #
  # * Download a game
  # * Download folder contents in zip format
  # * Name as name.nw to run with NodeWebKit on desktop
  # *
  #
  app.get '/zip/:name', (req, res) ->
    zipdir path.join(__dirname, '../../client/public/game/', req.params.name), (err, data) ->
      return req.next(err) if err

      res.set('Content-Type', 'application/zip')
      res.set('Content-Disposition', 'attachment; filename='+req.params.name+'.zip')
      res.set('Content-Length', data.length)
      res.end(data, 'binary')
      return




#process.env.OPENSHIFT_DATA_DIR
#upload = ->
#  zip = new AdmZip(filepath)
#  zip.extractAllToAsync(path, true, next)

