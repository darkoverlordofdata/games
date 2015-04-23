module.exports = {
  "gamesDb": {
    "host": process.env.OPENSHIFT_MYSQL_DB_HOST,
    "port": process.env.OPENSHIFT_MYSQL_DB_PORT,
    "database": process.env.OPENSHIFT_APP_NAME,
    "password": process.env.OPENSHIFT_MYSQL_DB_PASSWORD,
    "name": "gamesDb",
    "connector": "mysql",
    "user": process.env.OPENSHIFT_MYSQL_DB_USERNAME
  }
};
