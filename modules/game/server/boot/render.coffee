fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')
cache = {}


module.exports = (app, mod) ->

  mod.render = (res, view, options = {}) ->

    filename = path.join(__dirname, '../views', view)+'.tpl'

    if (template = cache[filename])?

      html = template.render(options)
      res.writeHead 200,
        'Content-Length'  : html.length
        'Content-Type'    : 'text/html; charset=utf-8'
      res.write(html)
      res.end()
      return
    else
      fs.readFile filename, (err, content) ->
        throw err if err
        template = cache[filename] = liquid.Template.parse(String(content))
        html = template.render(options)
        res.writeHead 200,
          'Content-Length'  : html.length
          'Content-Type'    : 'text/html; charset=utf-8'
        res.write(html)
        res.end()
        return
  return


  @res.writeHead 200,
    'Content-Length'  : $html.length
    'Content-Type'    : 'text/html; charset=utf-8'
