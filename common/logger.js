var moment = require('moment');

class Logger {
    constructor(){

    }

    info(msg){
        console.log(`[${moment().format()}]: ${msg}`);
    }
}

module.exports = new Logger();