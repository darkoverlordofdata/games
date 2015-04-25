#
# * System Error Handler
# *
# * Display 404 and 5xx errors
# *
#
fs = require('fs')
path = require('path')
eco = require('eco')

#
# * Load template files
# *
#
layout = ''
fs.readFile path.resolve(__dirname, '../views/errors/layout.eco'), 'utf-8',
  (err, data) ->
    layout = data
    return

err404 = ''
fs.readFile path.resolve(__dirname, '../views/errors/404.eco'), 'utf-8',
  (err, data) ->
    err404 = data
    return

err5xx = ''
fs.readFile path.resolve(__dirname, '../views/errors/5xx.eco'), 'utf-8',
  (err, data) ->
    err5xx = data
    return


#
# * Transform the template using the data
# * Render the resulting html
# *
#
render = (res, template, data) ->
  html = eco.render(layout, content: eco.render(template, data))
  res.writeHead 200,
    'Content-Length'  : html.length
    'Content-Type'    : 'text/html; charset=utf-8'
  res.write(html)
  res.end()

module.exports =

  #
  # * errorHandler
  # *
  #
  errorHandler: ->
    (err, req, res, next) ->
      res.status(err.status || 500)
      render(res, err5xx, error: err)

  #
  # * urlNotFound
  # *
  #
  urlNotFound: ->
    (req, res, next) ->
      res.status(404)
      render(res, err404, url: req.url)


