fs = require('fs')
path = require('path')
jade = require('jade')
cache = {}


module.exports = (app, mod) ->

  mod.render = (res, view, options = {}) ->

    filename = path.join(__dirname, '../views', view)+'.jade'

    if (template = cache[filename])?
      res.write(template(options))
      res.end()
      return
    else
      fs.readFile filename, (err, content) ->
        throw err if err
        template = cache[filename] = jade.compile(String(content), filename: filename)
        res.write(template(options))
        res.end()
        return
  return