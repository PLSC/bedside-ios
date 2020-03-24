/* Amplify Params - DO NOT EDIT
You can access the following resource attributes as environment variables from your Lambda function
var environment = process.env.ENV
var region = process.env.REGION

Amplify Params - DO NOT EDIT */
var AWS = require("aws-sdk");
var dynamodb = new AWS.DynamoDB();
var crypto = require("crypto");

exports.handler = async (event, context, callback) => {
  var tableName;
  if (process.env.ENV === "prod") {
    tableName = "User-up7cnctj6bbstiz5vgnuzmeywe-prod";
  } else {
    tableName = "User-sard6swytbdvzoj4plcaxpdj4i-dev";
  }

  console.log(event);
  var userName = event.userName;
  var email = event.request.userAttributes.email;
  var userPoolId = event.userPoolId;
  var region = event.region;
  var userId = crypto
    .createHash("md5")
    .update(`${userName}-${userPoolId}-${region}`)
    .digest("hex");

  if (userName) {
    console.log("Adding to DB: username: " + userName);
    console.log("Adding to DB: email: " + email);
    console.log("Adding to DB: id: " + userId);

    let tableInsert = {
      TableName: tableName,
      Item: {
        id: { S: userId },
        email: { S: email },
        userName: { S: userName }
      }
    };
    var data = null;
    try {
      let dataReq = dynamodb.putItem(tableInsert);
      data = await dataReq.promise();
    } catch (e) {
      console.log("error caught:");
      console.log(e);
      callback(e);
    }
  }
  context.done(null, event);
};
