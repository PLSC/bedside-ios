/* Amplify Params - DO NOT EDIT
	API_BEDSIDE_GRAPHQLAPIENDPOINTOUTPUT
	API_BEDSIDE_GRAPHQLAPIIDOUTPUT
	API_BEDSIDE_GRAPHQLAPIKEYOUTPUT
	API_BEDSIDE_USERINVITATIONTABLE_ARN
	API_BEDSIDE_USERINVITATIONTABLE_NAME
	API_BEDSIDE_USERTABLE_ARN
	API_BEDSIDE_USERTABLE_NAME
	ENV
	REGION
Amplify Params - DO NOT EDIT */ /* Amplify Params - DO NOT EDIT
You can access the following resource attributes as environment variables from your Lambda function
var environment = process.env.ENV
var region = process.env.REGION

Amplify Params - DO NOT EDIT */
var AWS = require("aws-sdk");
var dbAPI = require("./dbAPI");

exports.handler = async (event, context, callback) => {
  var userTypeName = "User";
  var invitationTypeName = "UserInvitation";
  var userTableName = process.env.API_BEDSIDE_USERTABLE_NAME;
  var userName = event.userName;
  var invitationTableName = process.env.API_BEDSIDE_USERINVITATIONTABLE_NAME;
  console.log(event);
  var email = event.request.userAttributes.email;
  var userId;
  try {
    invitation = await dbAPI.invitationExists(invitationTableName, email);
    userId = invitation.inviteeId;

    let userExists = await dbAPI.userExists(userTableName, userId);
    console.log("User Exists: ", userExists);

    const userData = {
      id: userId,
      typeName: userTypeName,
      userName: userName,
      email: email,
      orgID: event.request.userAttributes["custom:orgId"],
    };

    let newUser = await dbAPI.updateUser(userTableName, userData);
    console.log("New User: ", newUser);

    await dbAPI.setInvitationStatus(
      invitationTableName,
      invitation.id,
      dbAPI.InvitationStatus.Resolved
    );
    console.log("User Invitation Resolved.");
  } catch (e) {
    console.log("error caught:", e);
    callback(e);
  }

  context.done(null, event);
};
