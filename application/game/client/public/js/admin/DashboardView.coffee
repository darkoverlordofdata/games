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

