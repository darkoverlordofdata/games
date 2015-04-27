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
  # * Home page
  # *
  #
  app.all '/', (req, res) ->
    mod.render res, 'index',
      topHref: '/about'
      topButton: 'About'
    return

  #
  # * Terms and Conditions
  # *
  #
  app.all '/terms', (req, res) ->
    mod.render res, 'terms',
      topHref: '/'
      topButton: 'Home'
    return

  #
  # * Privacy Statement
  # *
  #
  app.all '/privacy', (req, res) ->
    mod.render res, 'privacy',
      topHref: '/'
      topButton: 'Home'
    return

  #
  # * About this site
  # *
  #
  app.all '/about', (req, res, next) ->
    mod.render res, 'about',
      topHref: '/'
      topButton: 'Home'
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
  # * K A T R A
  # *
  #
  app.all '/katra/run', (req, res) ->
    res.redirect 'https://darkoverlordofdata.com/katra/run'
    return

  app.all '/katra/sttr1', (req, res) ->
    res.redirect 'https://darkoverlordofdata.com/katra/run/?basic=hp2k&program=STTR1'
    return

  app.all '/katra/wumpus', (req, res) ->
    res.redirect 'https://darkoverlordofdata.com/katra/run/?basic=atari&program=WUMPUS'
    return

  app.all '/katra/eliza', (req, res) ->
    res.redirect 'https://darkoverlordofdata.com/katra/run/?basic=gwbasic&program=eliza'
    return

  app.all '/katra/oregon', (req, res) ->
    res.redirect 'https://darkoverlordofdata.com/katra/run/?basic=hp2k&program=OREGON'
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


