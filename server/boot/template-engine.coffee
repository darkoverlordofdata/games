###
 * Liquid Template rendering engine
###

fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')

module.exports = (app) ->
  return

  ###
   * Cache compiled templates
  ###
  cache = {}

  ###
   * Render the template
  ###
  app.engine 'tpl', (filePath, options, next) ->
    if (template = cache[filePath])?
      return next(null, template.render(options))
    else
      fs.readFile filePath, (err, content) ->
        return next(new Error(err)) if (err)
        template = cache[filePath] = liquid.Template.parse(String(content))
        return next(null, template.render(options))

  ###
   * Set default engine
  ###
  app.set('view engine', 'tpl')
  app.set('views', path.resolve(__dirname, '../views'))
  return
