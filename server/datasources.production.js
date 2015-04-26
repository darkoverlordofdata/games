module.exports = {
  "mysql": {
    "host": process.env.OPENSHIFT_MYSQL_DB_HOST,
    "port": process.env.OPENSHIFT_MYSQL_DB_PORT,
    "database": process.env.OPENSHIFT_APP_NAME,
    "password": process.env.OPENSHIFT_MYSQL_DB_PASSWORD,
    "name": "mysql",
    "connector": "mysql",
    "user": process.env.OPENSHIFT_MYSQL_DB_USERNAME
  }
};
