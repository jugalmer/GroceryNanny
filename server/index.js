var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var morgan = require('morgan');
var mongoose = require('mongoose');
var redis = require('redis');

var jwt = require('jsonwebtoken'); // used to create, sign, and verify tokens
var User = require('../server/models/user'); // get our mongoose model
var auth = require('../server/api/auth');
var recommendation = require('../server/api/recommendation');
var usergroceryitem = require('../server/api/usergroceryitem');

/* CONFIG PARAMS */
var ip = process.env.IP || '0.0.0.0'
var port = process.env.PORT || 8080; // used to create, sign, and verify tokens
var mongo_db = process.env.MONGOURI || ''
var app_secret = process.env.APPSECRET || ''

var redis_url = "//redis-10479.c8.us-east-1-2.ec2.cloud.redislabs.com:10479"
var redis_db = "gn-app"
var redis_pass = "GMD7QRt2uTAOPYRhnYtUGKL1sLDsZO49"

mongoose.connect(mongo_db); // connect to database
app.set('superSecret', app_secret); // secret variable

// use body parser so we can get info from POST and/or URL parameters
app.use(bodyParser.urlencoded({
    extended: false
}));
app.use(bodyParser.json());


// =======================
// routes ================
// =======================
// basic route

/* Connect to redis */
var redisClient = redis.createClient(redis_url);
redisClient.auth(redis_pass)

redisClient.on("connect", function () {
    console.log('redis connected')
});

redisClient.on("error", function (err) {
    response.end("redis ERROR: " + err);
});

redisClient.exists('visits', function(err, reply) {
    if (reply === 1) {
        console.log('visits key exists in redis ');
    } else {
        console.log('visits key doesn\'t exist redis');
        redisClient.set('visits', 1)
    }
});

app.get('/', (req, res) => {
    redisClient.incr('visits', function(err, reply) {
        console.log(reply); // 11
        res.json({
            "msg": "welcome to grocerry nanny app",
            "total_visits": reply
        })
    });
    
})

app.get('/check', function (req, res) {
    res.send('Hello! The API is at' + ip + " " + port + '/api');
});

app.use('/api/auth', auth)
app.use('/api/recommendation', recommendation)
app.use('/api/usergroceryitem', usergroceryitem)

var server = app.listen(port, ip, () => {
    console.log("Running on " + server.address().address + " port: " + server.address().port)
});