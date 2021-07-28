var AWS = require("aws-sdk");
var dynamodb = new AWS.DynamoDB();

//NOTE: This function is duplicated in bedsideAddNewUser.
//      This is not ideal, and we need to figure out how to
//      share code between different lambda functions.
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

exports.getTableNameFn = getTableNameFn;
