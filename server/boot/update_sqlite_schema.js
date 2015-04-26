module.exports = function(app) {
    app.dataSources.sqlite3.isActual(function(err, actual){
        if (!actual) {
            app.dataSources.sqlite3.autoupdate();
        }
    });
};