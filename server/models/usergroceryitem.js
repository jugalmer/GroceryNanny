// get an instance of mongoose and mongoose.Schema
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

mongoose.connect(process.env.MONGOURI || '')
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
  // we're connected!
  console.log('connected to mongo')
});
// set up a mongoose model and pass it using module.exports
module.exports = mongoose.model('usergroceryitem', new Schema({ 
    product_id: Number, 
    user_id: Number, 
    product_name: String,
    cost: Number,
    expiry: Date
}));