fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')
cache = {}


module.exports = (app, mod) ->

  mod.render = (res, view, options = {}) ->

    filename = path.join(__dirname, '../views', view)+'.tpl'

    if (template = cache[filename])?
      res.write(template.render(options))
      res.end()
      return
    else
      fs.readFile filename, (err, content) ->
        throw err if err
        template = cache[filename] = liquid.Template.parse(String(content))
        res.write(template.render(options))
        res.end()
        return
  return