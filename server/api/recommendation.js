var express = require('express');
var router = express.Router();
var recommendation = require('../models/recommendation');

router.get('/', (req, res) => {
    var user_id = req.query["user_id"]
    console.log("fetching recommendations for user: " + user_id)
    recommendation.find({"user_id": user_id}, (err, result) => {
        if(err) {
            res.status(400);
            console.log(err)
        } else {
            res.send(result)
        }
    });
})

module.exports = router;