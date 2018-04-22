var express = require('express'),
    app = express(),
    bodyParser = require('body-parser');

const log = require('./common/logger');

app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(express.static(__dirname + '/public'));
app.get('/', (req, res)=> {
    res.sendFile('index.html');
});

app.use(bodyParser.json());

var server = app.listen(process.env.PORT || 8811, process.env.IP || 'localhost', () => {
    log.info(`Server running @host:${server.address().address} and @port:${server.address().port}`);
})

module.exports = app;