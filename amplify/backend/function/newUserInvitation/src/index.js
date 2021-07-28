/* Amplify Params - DO NOT EDIT
	API_BEDSIDE_GRAPHQLAPIENDPOINTOUTPUT
	API_BEDSIDE_GRAPHQLAPIIDOUTPUT
	ENV
	REGION
Amplify Params - DO NOT EDIT */

var AWS = require("aws-sdk");
var documentClient = new AWS.DynamoDB.DocumentClient();
var uuid = require("uuid");
var uuidv4 = uuid.v4;
var ses = new AWS.SES({ region: "us-east-1" });
var tablesUtils = require("./tablesUtils");

let USER_TYPE = "User";
let INVITATION_TYPE = "UserInvitation";
let ORGANIZATION_TYPE = "Organization";
let HELP_URL = "[[ insert help url here ]]";

async function getById(id, tableName) {
  if (!id) throw "id cannot be null";
  let params = { TableName: tableName, Key: { id } };
  let result = await documentClient.get(params).promise();
  if (!result.Item) {
    throw `id: ${id} in table: ${tableName} does not exist`;
  } else {
    return result.Item;
  }
}

async function getUserInfo(userId, getTableName) {
  if (!userId) return;
  let userTableName = getTableName(USER_TYPE);
  return getById(userId, userTableName);
}

async function getOrgInfo(orgID, getTableName) {
  if (!orgID) return;
  let orgTableName = getTableName(ORGANIZATION_TYPE);
  return getById(orgID, orgTableName);
}

function createEmailBody(
  user,
  programAdmin,
  origin = "https://www.simpl-bedside.org"
) {
  if (!user) {
    throw "User not found for email creation.";
  }

  let invitationUrl = `${origin}/invitation/${user.email}`;
  return (
    `Dear ${user.firstName} ${user.lastName},\n\n` +
    `You have been invited to register ` +
    `an account with the SIMPL-Bedside application. Please visit ${invitationUrl} ` +
    `to create your unique user name and password.\n\n` +
    `New to SIMPL-Beside? Please contact help@simpl.org for questions.\n\n` +
    (programAdmin ? `- ${programAdmin.firstName} ${programAdmin.lastName}` : "")
  );
}

async function createUserInvitation(invitation, getTableName) {
  let userInvitationTableName = getTableName(INVITATION_TYPE);
  let creationDateString = new Date().toISOString();
  let userInvitationItem = {
    id: uuidv4(),
    __typename: INVITATION_TYPE,
    createdAt: creationDateString,
    updatedAt: creationDateString,
    ...invitation,
  };
  let params = {
    TableName: userInvitationTableName,
    Item: userInvitationItem,
  };
  try {
    let result = await documentClient.put(params).promise();
    console.log("invitationItem:", result);
    return result;
  } catch (error) {
    console.log("error w/documentClient:", error);
    throw error;
  }
}

exports.handler = async (event) => {
  let { inviteeId, email, programAdminId } = event.arguments.userInvitation;

  let getTableName = await tablesUtils.getTableNameFn();

  let userInvitationItem = await createUserInvitation(
    event.arguments.userInvitation,
    getTableName
  );

  let user = await getUserInfo(inviteeId, getTableName);
  let programAdmin = await getUserInfo(programAdminId, getTableName);
  let origin = event.request.headers.origin;
  let organization = await getOrgInfo(user.orgID, getTableName);

  let emailSubject = `Invitation to register SIMPL-Bedside account${
    organization ? ` ${organization.description}.` : `.`
  }`;

  console.log("origin", origin);

  let emailBody = createEmailBody(user, programAdmin, origin);
  var params = {
    Destination: {
      ToAddresses: [email],
    },
    Message: {
      Body: {
        Text: { Data: emailBody },
      },

      Subject: { Data: emailSubject },
    },
    Source: "admin@simpl-bedside.org",
  };

  var r = await ses.sendEmail(params).promise();

  const response = {
    statusCode: 200,
    body: JSON.stringify(userInvitationItem),
  };
  return response;
};
