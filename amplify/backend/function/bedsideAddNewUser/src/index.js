/* Amplify Params - DO NOT EDIT
You can access the following resource attributes as environment variables from your Lambda function
var environment = process.env.ENV
var region = process.env.REGION

Amplify Params - DO NOT EDIT */
var AWS = require("aws-sdk");
var dynamodb = new AWS.DynamoDB();
var crypto = require("crypto");

async function readAllTables() {
  var params = {};
  var tables = [];

  while (true) {
    var response = await dynamodb.listTables(params).promise();
    tables = tables.concat(response.TableNames);

    if (undefined === response.LastEvaluatedTableName) {
      break;
    } else {
      params.ExclusiveStartTableName = response.LastEvaluatedTableName;
    }
  }

  return tables;
}

async function getTableNameFn() {
  let data = await readAllTables();
  console.log("all tables:", data);

  return function getTableName(name) {
    let tableNames = data.filter(
      (tableName) =>
        tableName.startsWith(name + "-") && tableName.endsWith(process.env.ENV)
    );
    if (tableNames.length > 1) {
      throw (
        "Ambiguous table names: " +
        tableNames.reduce((prev, curr, index) => {
          prev + ", " + curr;
        })
      );
    }
    if (tableNames.length === 0) {
      throw "Table not found";
    }

    return tableNames[0];
  };
}

exports.handler = async (event, context, callback) => {
  var getTableName = await getTableNameFn();
  var tableName = getTableName("User");
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
    let creationDateString = new Date().toISOString();

    let tableInsert = {
      TableName: tableName,
      Item: {
        id: { S: userId },
        email: { S: email },
        userName: { S: userName },
        createdAt: { S: creationDateString },
      },
    };

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
