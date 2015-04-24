###
 * Preload the templates & Start
###
$ ->
  gameshare.loadTemplates [
    'MainView'
    'DashboardView'
    'GamesTableView'
    'GameView'
    'GameDetailView'
    ],
    ->
      gameshare.router = new gameshare.Router()
      Backbone.history.start()

###
 * gameshare application namespace
###
gameshare =
  views         : {}
  models        : {}
  loadTemplates : (views, next) ->

    deferredGets = []
    ###
     * Async load Liquid Templates
     * Each template is named the same as it's view class
    ###
    $.each views, (index, view) ->
      if gameshare[view]
        deferredGets.push $.get('tpl/'+view+'.html',  (data) ->
          gameshare[view].prototype.template = Liquid.Template.parse(data)
        , 'html')

    $.when.apply(null, deferredGets).done(next)
    return

###
 * SPA Router
###
class gameshare.Router extends Backbone.Router
  ###
   * these routes correspond to the navbar menu
  ###
  routes:
    ''          : 'dashboard'
    'dashboard' : 'dashboard'
    'settings'  : 'settings'
    'profile'   : 'profile'
    'logout'    : 'logout'
    'new'       : 'newgame'
    'import'    : 'import'
    'export'    : 'export'
    'game/:id'  : 'game'



  ###
   * Set the document body to the main template
  ###
  initialize: ->
    gameshare.mainView = new gameshare.MainView()
    $('body').html(gameshare.mainView.render().el)
    @$content = $("#content");

    return

  ###
   * The default route
  ###
  dashboard: ->
    gameshare.dashView = new gameshare.DashboardView()
    @$content.html(gameshare.dashView.render().el)
    return

  ###
   * Site settings
  ###
  settings: ->
    return

  ###
   * Loged in profile
  ###
  profile: ->
    return

  ###
   * Logout
  ###
  logout: ->
    location.replace '/logout'
    return

  game: (id) ->
    gameshare.gameView = new gameshare.GameView(game: id)
    @$content.html(gameshare.gameView.render().el)
    return

  newgame: ->
    return

###
 * Game Model
###
class gameshare.GameModel extends Backbone.Model
  urlRoot: '/api/Games'

  parse: (data) =>
    return if Array.isArray(data) then data[0] else data


###
 * Game Model Collection
###
class gameshare.GameCollection extends Backbone.Collection
  model: gameshare.GameModel
  url: '/api/Games'



###
 * Main View - document.body
###
class gameshare.MainView extends Backbone.View

  initialize: ->
    return

  render: ->
    @$el.html(@template.render())
    return this


###
 * Dash View
###
class gameshare.DashboardView extends Backbone.View

  initialize: ->
    @games = new gameshare.GameCollection()
    @tableView = new gameshare.GamesTableView(model: @games)
    return

  render: =>
    @$el.html(@template.render())
    $('#games', @el).replaceWith(@tableView.render().el)
    return this

###
 * Dash SubView
###
class gameshare.GamesTableView extends Backbone.View

  tagName: 'tbody'

  initialize: ->
    @model.bind 'reset', @render
    @model.fetch(reset: true)
    return

  render: =>
    $el = $(@template.render(games: @model.models))
    @$el.html($el.html())
    return this

###
 * Game View
###
class gameshare.GameView extends Backbone.View

  initialize: (options) ->
    @game = new gameshare.GameModel(id: options.game)
    @gameView = new gameshare.GameDetailView(model: @game)
    return

  render: =>
    @$el.html(@template.render())
    $('#game', @el).replaceWith(@gameView.render().el)
    return this

###
 * Dash SubView
###
class gameshare.GameDetailView extends Backbone.View

  tagName: 'table'

  initialize: ->
    @model.bind 'change', @render
    @model.fetch()
    return

  render: =>
    $el = $(@template.render(game: @model.attributes))
    @$el.html($el.html())
    return this

