#+--------------------------------------------------------------------+
#| Cakefile
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2015
#+--------------------------------------------------------------------+
#|
#| This file is a part of games
#|
#| games is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# cake utils
#
fs = require 'fs'
util = require 'util'
{exec} = require 'child_process'


#
# Migrate
#
#
task 'migrate', 'Initialize the db', ->

  DataSource = require('loopback-datasource-juggler').DataSource
  Sqlite3 = require('loopback-connector-sqlite')

  db = new DataSource(Sqlite3, file_name: 'db.sqlite3', debug: false)

  model =
    id: type: Number, required: true
    active: type:  Boolean
    name:  type: String
    slug:  type: String
    url:  type: String
    author:  type: String
    description:  type: String
    version:  type: String
    icon:  type: String
    main:  type: String
    height:  type: Number
    width:  type: Number


  Games = db.define('Game', model)



  data = [
    {
      id: 1,
      active: 1,
      name: 'Katra',
      slug: 'katra',
      url: 'https://github.com/darkoverlordofdata/katra',
      author: 'darkoverlordofdata',
      description: '',
      version: '0.0.1',
      icon: 'katra.png',
      main: 'katra.html',
      height: 600,
      width: 800
    },
    {
      id: 2,
      active: 1,
      name: 'Asteroid Simulator',
      slug: 'asteroids',
      url: 'https://github.com/darkoverlordofdata/asteroids',
      author: 'darkoverlordofdata',
      description: 'Classic Asteroids using modern physics',
      version: '0.0.1',
      icon: 'asteroids36.png',
      main: 'asteroids.html',
      height: 600,
      width: 800
    }
  ]

  db.automigrate ->
    Games.create data, (err, h) ->
      if err
        console.log err
      else
        console.log h
