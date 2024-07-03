const appsyncUrl = process.env.API_BEDSIDE_GRAPHQLAPIENDPOINTOUTPUT;
const apiKey = process.env.API_BEDSIDE_GRAPHQLAPIKEYOUTPUT;
const { request } = require("/opt/appSyncRequest");
const { checkIfUserExists } = require("/opt/graphql/customQueries");
const { updateUser } = require("/opt/graphql/mutations");

async function getUserId(userName) {
  try {
    var result = await request(
      {
        query: checkIfUserExists,
        operationName: "CheckIfUserExists",
        variables: {
          userName: userName,
          limit: 1000,
        },
      },
      appsyncUrl,
      apiKey
    );
    console.log("Result: ", result);
    if (result.data.listUsers.items.length > 0) {
      return result.data.listUsers.items[0].id;
    } else {
      return "USER_DOES_NOT_EXIST";
    }
  } catch (error) {
    console.error("User Lookup Error: ", error);
    return "UNKNOWN_ERROR";
  }
}

async function updateUserLastLogin(userId) {
  try {
    let result = await request(
      {
        query: updateUser,
        operationName: "UpdateUser",
        variables: {
          input: {
            id: userId,
            lastLogin: new Date(),
          },
        },
      },
      appsyncUrl,
      apiKey
    );
    console.log("Result: ", result);
  } catch (error) {
    console.error("User Update Error: ", error);
    return "UNKNOWN_ERROR";
  }
}

exports.getUserId = getUserId;
exports.updateUserLastLogin = updateUserLastLogin;
