module.exports = (app) ->

  User = app.models.User
  Role = app.models.Role
  RoleMapping = app.models.RoleMapping

  User.create [
    username: "admin"
    email: "admin@admin.com"
    password: "admin"
  ], (err, users) ->
    return console.error(err)  if err
    
    # Create the admin role
    Role.create
      name: "admin"
    , (err, role) ->
      return console.error(err)  if err
      
      # Give Admin user the admin role
      role.principals.create
        principalType: RoleMapping.USER
        principalId: users[0].id
      , (err, principal) ->
        console.error err  if err

      return

    return

  return

# done!
