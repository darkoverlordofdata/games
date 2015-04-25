fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')
cache = {}

send = (res, html) ->
  res.writeHead 200,
    'Content-Length'  : html.length
    'Content-Type'    : 'text/html; charset=utf-8'
  res.write(html)
  res.end()

module.exports = (app, mod) ->

  mod.render = (res, view, options = {}) ->
    filename = path.join(__dirname, '../views', view)+'.tpl'
    if (template = cache[filename])?
      send(res, template.render(options))
      return
    else
      fs.readFile filename, (err, content) ->
        throw err if err
        template = cache[filename] = liquid.Template.parse(String(content))
        send(res, template.render(options))
        return
  return

