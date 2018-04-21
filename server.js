var express = require('express'),
    app = express(),
    bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(bodyParser.json());

var server = app.listen(process.env.PORT || 8811, process.env.IP || 'localhost', () => {
    console.log(`Server running @host:${server.address().address} and @port:${server.address().port}`);
})

module.exports = app;