/* Generates the indexes on elastic search */
var elasticsearch = require('elasticsearch');

(function () {
    'use strict'
    
    console.log('Connecting to Elastic Search Cluster')

    var uname = process.env.ESUNAME || ''
    var pass = process.env.ESPASS || ''
    var host = process.env.ESHOST || 'localhost'
    var port = process.env.ESPORT || 9243

    var client = new elasticsearch.Client({
        hosts:['https://'+ uname + ":" + pass + "@" + host + ":" + port]
        //hosts: ['https://elastic:Rz7ttlR5OK4JDAg0hyl92wwc@efb9d029b5e853c7154e661385276da6.us-central1.gcp.cloud.es.io:9243']
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
})();