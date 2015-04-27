#
# * Render Liquid Templates
# *
#
fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')
Memcached = require('memcached')

lifetime = 2592000 # 30 days
#
# * Send the html
# *
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

  console.log process.env.MEMCACHED_LOCATIONS ? 'localhost:11211'
  try
    memcached = new Memcached(process.env.MEMCACHED_LOCATIONS ? 'localhost:11211')
    console.log 'memcached'
    console.log memcached
  catch err
    console.log err

  memcached.flush (err) ->
    console.log err
  #
  # * Render the template
  # * first look in cache
  # *
  #
  mod.render = (res, view, data = {}) ->

    ###
     * Get the latest flash message from the middleware
    ###
    data.messages = res.req.flash()

    memcached.get view, (err, html) ->
      console.log err
      console.log html
      if 'string' is typeof html
        console.log 'result found in cache: %s bytes', html.length
        send(res, html)
        return
      else
        filename = path.join(__dirname, '../views', view)+'.tpl'
        fs.readFile filename, 'utf-8', (err, content) ->
          return res.req.next(err) if err
          template = liquid.Template.parse(content)
          html = template.render(data)
          send(res, html)
          memcached.set view, html, lifetime, (err) ->
            console.log err if err
          return
  return


