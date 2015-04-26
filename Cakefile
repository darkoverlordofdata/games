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
# Migrate Game table
#
#
task 'migrate:game', 'Initialize the db', ->

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


#
# Migrate Katra table
#
#
task 'migrate:katra', 'Initialize the db', ->

  DataSource = require('loopback-datasource-juggler').DataSource
  Sqlite3 = require('loopback-connector-sqlite')

  db = new DataSource(Sqlite3, file_name: 'db.sqlite3', debug: false)

  model =
    id: type: Number, required: true
    active: type:  Boolean
    slug:  type: String
    title: type: String
    description:  type: String
    image:  type: String


  Katra = db.define('Katra', model)



  data = [
    {
      id: 1,
      active: 1,
      slug: 'katra/sttr1',
      title: 'Katra . . .',
      description: 'Like, beam me up, dude.',
      image: 'assets/katra.png',
    },
    {
      id: 2,
      active: 1,
      slug: 'katra/wumpus',
      title: 'Hunt the Wumpus',
      description: 'What\'s a Wumpus?',
      image: 'assets/wumpus.png',
    },
    {
      id: 3,
      active: 1,
      slug: 'katra/eliza',
      title: 'Eliza',
      description: 'A shrink with a \'tude.',
      image: 'assets/wumpus.png',
    },
    {
      id: 4,
      active: 1,
      slug: 'katra/oregon',
      title: 'Oregon',
      description: 'Why do you put your wagons in a circle?<br>To get better Wi-Fi!',
      image: 'assets/oregon.png',
    }


  ]

  db.automigrate ->
    Katra.create data, (err, h) ->
      if err
        console.log err
      else
        console.log h
