#
# * Render Liquid Templates
# *
#
fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')
memjs = require('memjs')

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

  if process.env.memcachedcloud_aaaeb?
    p = JSON.parse(process.env.memcachedcloud_aaaeb)
    memcached = memjs.Client.create(p.servers, username: p.username, password: p.password)
  else
    memcached = memjs.Client.create('localhost:11211')

  memcached.flush (err) ->
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
      if html isnt null
        console.log "%s bytes retrieved from cache", String(html).length
        send(res, html)
        return
      else
        filename = path.join(__dirname, '../views', view)+'.tpl'
        fs.readFile filename, 'utf-8', (err, content) ->
          return res.req.next(err) if err
          template = liquid.Template.parse(content)
          html = template.render(data)
          send(res, html)
          memcached.set view, html, (err) ->
            console.log err if err
          return
  return


