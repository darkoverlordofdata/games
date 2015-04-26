#
# * Pseudo Api
# * Not sure if I need the expense of a db
# * just for a read-only list of games.
# * This frees up a gear on OpenShift
# *
#

module.exports = (app, mod) ->
  mod.games = [
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

  mod.byName = {}
  for game in mod.games
    mod.byName[game.slug] = game
