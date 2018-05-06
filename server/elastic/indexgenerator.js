/* Generates the indexes on elastic search */
var elasticsearch = require('elasticsearch');
var fs = require('fs');

(function () {
    'use strict'

    console.log('Connecting to Elastic Search Cluster')

    var uname = process.env.ESUNAME || ''
    var pass = process.env.ESPASS || ''
    var host = process.env.ESHOST || 'localhost'
    var port = process.env.ESPORT || 9243

    var client = new elasticsearch.Client({
        hosts: ['https://' + uname + ":" + pass + "@" + host + ":" + port]
    });

    client.ping({
        requestTimeout: 30000,
    }, function (error) {
        if (error) {
            console.error('elasticsearch cluster is down!');
        } else {
            console.log('Everything is ok');
        }
    });

    fs.readFile('./products.json', {
        encoding: 'utf-8'
    }, function (err, data) {

        if (err) {
            throw err;
        }

        var product = null;

        var bulk_request = []
        data = JSON.parse(data)
        data.forEach(element => {
            product = {
                id: element.product_id,
                product_name: element.product_name,
                aisle_id: element.aisle_id,
                department_id: element.department_id
            }

            bulk_request.push({
                index: {
                    _index: 'products',
                    _type: 'product',
                    _id: product.id
                }
            });
            bulk_request.push(product);
        });

        var busy = false;
        var callback = function (err, resp) {
            if (err) {
                console.log(err);
            }

            busy = false;
        };

        var bulk_insert = function () {
            if (!busy) {
                busy = true;
                client.bulk({
                    body: bulk_request.slice(0, 1000)
                }, callback);
                bulk_request = bulk_request.slice(1000);
                console.log(bulk_request.length);
            }

            if (bulk_request.length > 0) {
                setTimeout(bulk_insert, 10);
            } else {
                console.log('Inserted all records.');
            }
        };

        bulk_insert();

    });

})();