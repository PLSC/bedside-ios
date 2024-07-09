/* Amplify Params - DO NOT EDIT
	API_BEDSIDE_GRAPHQLAPIENDPOINTOUTPUT
	API_BEDSIDE_GRAPHQLAPIIDOUTPUT
	API_BEDSIDE_GRAPHQLAPIKEYOUTPUT
	ENV
	REGION
Amplify Params - DO NOT EDIT */ /**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
var dbAPI = require("./dbAPI");

exports.handler = async (event, context, callback) => {
  console.log(`EVENT: ${JSON.stringify(event)}`);
  var userName = event.userName;
  try {
    // Check if the user exists in the database
    let userId = await dbAPI.getUserId(userName);
    if (userId === "USER_DOES_NOT_EXIST" || userId === "UNKNOWN_ERROR") {
      //throw error
    } else {
      console.log("user id: ", userId);
      //update user by userId
    }

    // Update the last login time for the user
    await dbAPI.updateUserLastLogin(userId);
  } catch (e) {
    console.log("error caught:", e);
    callback(e);
  }

  context.done(null, event);
};
