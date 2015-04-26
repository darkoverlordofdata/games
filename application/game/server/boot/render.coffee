#
# * Render Liquid Templates
# *
#
fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')
cache = {}

#
# * Send the html
# *
#
send = (res, html) ->
  res.writeHead 200,
    'Content-Length'  : html.length
    'Content-Type'    : 'text/html; charset=utf-8'
  res.write(html)
  res.end()
  return

###
 * used for {% extends 'layout' %}
###
liquid.Template.fileSystem =
  root: path.resolve(__dirname, '../views')
  readTemplateFile: (view) ->
    filename = path.join(__dirname, '../views', view)+'.tpl'
    return fs.readFileSync(filename, 'utf-8')


module.exports = (app, mod) ->

  #
  # * Render the template
  # *
  #
  mod.render = (res, view, data = {}) ->

    ###
     * So I can refresh the page without restarting in dev
    ###
    cache = {} if app.get('env') is 'development'

    ###
     * Get the latest flash message from the middleware
    ###
    data.messages = res.req.flash()

    filename = path.join(__dirname, '../views', view)+'.tpl'
    if (template = cache[filename])?
      send(res, template.render(data))
      return
    else
      fs.readFile filename, (err, content) ->
        return res.req.next(err) if err
        template = cache[filename] = liquid.Template.parse(String(content))
        send(res, template.render(data))
        return
  return

