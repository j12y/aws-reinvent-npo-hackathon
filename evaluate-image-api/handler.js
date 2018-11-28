'use strict';

const AWS = require('aws-sdk');
const get = require('lodash.get');

const rekognition = new AWS.Rekognition();

module.exports.image = async (event, context) => {
  // https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Rekognition.html#detectLabels-property
  return rekognition.detectLabels({
    "Image": {
       "Bytes": new Buffer(event.body, 'base64'),
    },
    MaxLabels: 1,
  }).promise()
    .then(data => {
      console.log('success', data);
      const firstName = get(data, 'Labels[0].Name', 'Unknown');
      const result = {result: firstName};
      return {
        statusCode: 200,
        body: JSON.stringify(result),
      };
    })
    .catch(err => {
      console.log('error', err);
      return {
        statusCode: 400,
        body: JSON.stringify(err),
      };
    });
};
