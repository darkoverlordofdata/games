fs = require('fs')
path = require('path')
eco = require('eco')

layout = fs.readFileSync(path.resolve(__dirname, '..', 'views/errors/layout.eco'), 'utf-8')
err404 = fs.readFileSync(path.resolve(__dirname, '..', 'views/errors/404.eco'), 'utf-8')
err5xx = fs.readFileSync(path.resolve(__dirname, '..', 'views/errors/5xx.eco'), 'utf-8')

render = (res, template, data) ->
  html = eco.render(layout, content: eco.render(template, data))
  res.writeHead 200,
    'Content-Length'  : html.length
    'Content-Type'    : 'text/html; charset=utf-8'
  res.write(html)
  res.end()

module.exports =

  errorHandler: ->
    (err, req, res, next) ->
      res.status(err.status || 500)
      render(res, err5xx, error: err)

  urlNotFound: ->
    (req, res, next) ->
      res.status(404)
      render(res, err404, url: req.url)


