/* eslint-disable-line */ const aws = require("aws-sdk");

async function createGroupIfNeeded(
  groupName,
  userPoolId,
  cognitoidentityserviceprovider
) {
  const groupParams = {
    GroupName: groupName,
    UserPoolId: userPoolId,
  };

  try {
    await cognitoidentityserviceprovider.getGroup(groupParams).promise();
  } catch (e) {
    await cognitoidentityserviceprovider.createGroup(groupParams).promise();
  }
}

exports.handler = async (event, context, callback) => {
  const cognitoidentityserviceprovider = new aws.CognitoIdentityServiceProvider(
    { apiVersion: "2016-04-18" }
  );

  console.log("available event info:", event);

  // we dont' need to update groups on password change.
  if (event.triggerSource === "PostConfirmation_ConfirmForgotPassword") {
    callback(null, event);
    return;
  }

  let permissions = event.request.userAttributes["custom:permissions"];

  createGroupIfNeeded(
    process.env.GROUP, //Users - default group.
    event.userPoolId,
    cognitoidentityserviceprovider
  );
  createGroupIfNeeded(
    permissions,
    event.userPoolId,
    cognitoidentityserviceprovider
  );

  const addUserParams = {
    GroupName: process.env.GROUP,
    UserPoolId: event.userPoolId,
    Username: event.userName,
  };

  const addPermissionsParams = {
    GroupName: permissions,
    UserPoolId: event.userPoolId,
    Username: event.userName,
  };

  try {
    await cognitoidentityserviceprovider
      .adminAddUserToGroup(addUserParams)
      .promise();
    await cognitoidentityserviceprovider
      .adminAddUserToGroup(addPermissionsParams)
      .promise();
    callback(null, event);
  } catch (e) {
    callback(e);
  }
};
