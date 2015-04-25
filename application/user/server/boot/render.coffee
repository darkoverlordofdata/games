#
# * Render Jade Templates
# *
#
fs = require('fs')
path = require('path')
jade = require('jade')
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



module.exports = (app, mod) ->

  #
  # * Render the template
  # *
  #
  mod.render = (res, view, data = {}) ->

    data.messages = res.req.flash()

    filename = path.join(__dirname, '../views', view)+'.jade'
    if (template = cache[filename])?
      send(res, template(data))
      return
    else
      fs.readFile filename, (err, content) ->
        throw err if err
        template = cache[filename] = jade.compile(String(content), filename: filename)
        send(res, template(data))
        return
  return