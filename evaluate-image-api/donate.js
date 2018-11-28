'use strict';

var fs = require('fs');
var data = fs.readFileSync("donation-guide.json", "utf8");
var guide = JSON.parse(data);

// Given an item will return determination of whether or not
// the item can be accepted by Goodwill for donation.
//
// GET /donate/policy?name=Toaster
module.exports.getPolicyDecision = async (event, context) => {
    let query = event.queryStringParameters["item"].toLowerCase();
    let result = false;
    let value = '0.00';

    query.split(',').forEach(function(query) {
        if (Object.keys(guide['accept']).indexOf(query) >= 0) {
            result = true;
            value = guide['accept'][query]['price'] || '0.00';
        }
    });

    return {
        statusCode: 200,
        body: JSON.stringify({
            accepted: result,
            value: value
        })
    }
}

module.exports.healthcheck = async (event, context) => {
    /*
    "resource": "/donate/health",
     "path": "/donate/health",
     "httpMethod": "GET",
     "headers": {...},
     "queryStringParameters: { "Item": "Toaster"}"
    */
    console.log(event);
    console.log(context);
    return {
        statusCode: 200,
        body: JSON.stringify({
            event: event,
            context: context,
        })
    }
}

// Returns a list of all donatable items that fall into the
// given category
//
// GET /donate/category?name=Clothing
module.exports.getCategory = async (event, context) => {
    console.log("Not implemented.");
    return {
        statusCode: 200,
        body: JSON.stringify([
            "Pants",
            "Shirt",
            "Hat"
        ])
    }
}

// Creates a new record for a donatable item
//
// POST /donate/item
// {"name": "Toaster", "category": "Appliance", "value": "3.99", "aliases": []}
module.exports.postItem = async (event, context) => {
    console.log("Not implemented.");
    return {
        statusCode: 201,
        body: JSON.stringify({})
    }
}

// Updates a record with new details for the donation guide
//
// PUT /donate/item
// {"name": "Toaster", "category": "Appliance", "value": "3.99", "aliases": ["bread warmer"]}
module.exports.putItem = async (event, context) => {
  console.log("Not implemented.");
  return {
    statusCode: 204,
    body: JSON.stringify({})
  };
};
