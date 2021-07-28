var AWS = require("aws-sdk");
var documentClient = new AWS.DynamoDB.DocumentClient();

async function invitationExists(invitationTableName, email) {
  let params = {
    TableName: invitationTableName,
    IndexName: "byEmail",
    KeyConditionExpression: "email = :emailKey",
    ExpressionAttributeValues: {
      ":emailKey": email,
    },
  };
  var data = await documentClient.query(params).promise();
  console.log("query result =", data);
  if (data.Items.length > 0) {
    return data.Items[0];
  } else {
    throw "No invitation exists for email: " + email;
  }
}

async function userExists(userTableName, userId) {
  let params = {
    TableName: userTableName,
    KeyConditionExpression: "id = :idKey",
    ExpressionAttributeValues: {
      ":idKey": userId,
    },
  };
  var data = await documentClient.query(params).promise();
  console.log("query result =", data);
  if (data.Items.length > 0) {
    return true;
  } else {
    throw "Error: User entry does not exist.";
  }
}

const InvitationStatus = {
  Started: "Started",
  Notified: "Notified",
  Resolved: "Resolved",
};

async function setInvitationStatus(
  invitationTableName,
  invitationId,
  status = InvitationStatus.Resolved
) {
  let updatedStatus = status;
  let params = {
    TableName: invitationTableName,
    Key: {
      id: invitationId,
    },
    ExpressionAttributeNames: {
      "#is": "invitationStatus",
    },
    ExpressionAttributeValues: {
      ":is": updatedStatus,
    },
    UpdateExpression: "set #is = :is",
    ReturnValues: "UPDATED_NEW",
  };
  console.log("Invitation Parameters: ", params);
  let updatedInvitation = await documentClient.update(params).promise();
  return updatedInvitation;
}

async function updateUser(userTableName, userData) {
  let creationDateString = new Date().toISOString();
  let newUserParams = {
    TableName: userTableName,
    Key: {
      id: userData.id,
    },
    ExpressionAttributeNames: {
      "#c": "createdAt",
      "#u": "updatedAt",
      "#s": "userName",
    },
    ExpressionAttributeValues: {
      ":c": creationDateString,
      ":u": creationDateString,
      ":s": userData.userName,
    },
    UpdateExpression: "set #c = if_not_exists(#c, :c), #u = :u, #s = :s",
    ReturnValues: "UPDATED_NEW",
  };

  console.log("User Parameters: ", newUserParams);
  let newUser = await documentClient.update(newUserParams).promise();
  return { ...newUser.Attributes, id: userData.id };
}

exports.InvitationStatus = InvitationStatus;
exports.updateUser = updateUser;
exports.userExists = userExists;
exports.invitationExists = invitationExists;
exports.setInvitationStatus = setInvitationStatus;
