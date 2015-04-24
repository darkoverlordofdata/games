ensureLoggedIn = require("connect-ensure-login").ensureLoggedIn

module.exports = (app, mod) ->

  app.get "/demo", (req, res, next) ->
    mod.render res, "pages/index",
      user: req.user
      url: req.url
      messages: req.flash()

    return

  app.get "/auth/account", ensureLoggedIn("/login"), (req, res, next) ->
    mod.render res, "pages/loginProfiles",
      user: req.user
      url: req.url
      messages: req.flash()

    return

  app.get "/link/account", ensureLoggedIn("/login"), (req, res, next) ->
    mod.render res, "pages/linkedAccounts",
      user: req.user
      url: req.url
      messages: req.flash()

    return

  app.get "/local", (req, res, next) ->
    mod.render res, "pages/local",
      user: req.user
      url: req.url
      messages: req.flash()

    return

  app.get "/signup", (req, res, next) ->
    mod.render res, "pages/signup",
      user: req.user
      url: req.url
      messages: req.flash()

    return

  app.post "/signup", (req, res, next) ->
    User = app.models.user
    newUser = {}
    newUser.email = req.body.email.toLowerCase()
    newUser.username = req.body.username.trim()
    newUser.password = req.body.password
    User.create newUser, (err, user) ->
      if err
        req.flash "error", err.message
        res.redirect "back"
      else

  # Passport exposes a login() function on req (also aliased as logIn())
  # that can be used to establish a login session. This function is
  # primarily used when users sign up, during which req.login() can
  # be invoked to log in the newly registered user.
        req.login user, (err) ->
          if err
            req.flash "error", err.message
            return res.redirect("back")
          res.redirect "/auth/account"

      return

    return

  app.get "/login", (req, res, next) ->
    mod.render res, "pages/login",
      user: req.user
      url: req.url
      messages: req.flash()
    return

  app.get "/link", (req, res, next) ->
    mod.render res, "pages/link",
      user: req.user
      url: req.url
      messages: req.flash()

    return

  app.get "/auth/logout", (req, res, next) ->
    req.logout()
    res.redirect "/"
    return
