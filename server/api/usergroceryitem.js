var express = require('express');
var router = express.Router();

var usergroceryitem = require('../models/usergroceryitem');

router.get('/', (req, res) => {
    var user_id = req.query["user_id"]
    console.log("fetching usergroceryitem for user: " + user_id)
    usergroceryitem.find({
        "user_id": user_id
    }, (err, result) => {
        if (err) {
            res.status(400);
            console.log(err)
        } else {
            res.send(result)
        }
    });
})

router.post('/', (req, res) => {
    var user_id = req.query["user_id"] || 0
    console.log(JSON.stringify(req.body))
    var product_id = req.body["product_id"]
    var product_name = req.body["product_name"]
    var cost = req.body["cost"]
    var expiry = req.body["expiry"]
    var product_img = req.body["product_img"]
    var item = new usergroceryitem({
        product_id: product_id,
        user_id: user_id,
        product_name: product_name,
        cost: cost,
        expiry: expiry,
        product_img: product_img
    })
    console.log(JSON.stringify(item))

    item.save((err) => {
        if (err) {
            res.status(400).send(err)
        }

        res.status(200).json({
            "msg": "user grocery item created",
            "id": item._id
        })
    })
});


module.exports = router;