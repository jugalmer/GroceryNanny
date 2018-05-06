var express     = require('express');
var app         = express();
var bodyParser  = require('body-parser');
var morgan      = require('morgan');
var mongoose    = require('mongoose');

var jwt    = require('jsonwebtoken'); // used to create, sign, and verify tokens
var User   = require('../server/models/user'); // get our mongoose model
var auth   = require('../server/api/auth');
var recommendation   = require('../server/api/recommendation');

var ip = process.env.IP || '0.0.0.0'
var port = process.env.PORT || 8080; // used to create, sign, and verify tokens
var mongo_db = process.env.MONGOURI || ''
var app_secret = process.env.APPSECRET || ''

mongoose.connect(mongo_db); // connect to database
app.set('superSecret', app_secret); // secret variable

// use body parser so we can get info from POST and/or URL parameters
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


// =======================
// routes ================
// =======================
// basic route
app.get('/check', function(req, res) {
    res.send('Hello! The API is at http://localhost:' + port + '/api');
});

app.use('/api/auth', auth)
app.use('/api/recommendation', recommendation)
var server = app.listen(port, 'localhost', () => {
    console.log("Running on " + server.address().address +" port: " + server.address().port)
});