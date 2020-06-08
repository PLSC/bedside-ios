var AWS = require("aws-sdk");
var ses = new AWS.SES({ region: "us-east-1" });
var documentClient = new AWS.DynamoDB.DocumentClient();
var moment = require("moment-timezone");

async function getUser(userId, getTableName) {
  let userTableName = getTableName("User");
  let params = {
    TableName: userTableName,
    Key: { id: userId },
  };
  try {
    let data = await documentClient.get(params).promise();
    console.log("fetched user: ", data);
    return data.Item;
  } catch (error) {
    console.log("error fetching userId: " + userId, error);
  }
}

async function getProcedure(procedureId, getTableName) {
  let procedureTableName = getTableName("Procedure");
  let params = {
    TableName: procedureTableName,
    Key: { id: procedureId },
  };
  try {
    let data = await documentClient.get(params).promise();
    console.log("fetched procedure: ", data);
    return data.Item;
  } catch (error) {
    console.log("error fetching procedureId: " + procedureId, error);
  }
}

function ratingLevelToRating(ratingLevel) {
  switch (ratingLevel) {
    case 1:
      return "Unprepared / Critical Deficiency";
    case 2:
      return "Inexperienced w/ Procedure";
    case 3:
      return "Intermediate Performance";
    case 4:
      return "Practice-Ready Performance";
    case 5:
      return "Exceptional Performance";
    default:
      return "Invalid Rating";
  }
}

async function sendRaterEmail(evalResponseItem, getTableName) {
  var rater = await getUser(evalResponseItem.raterId, getTableName);
  var subject = await getUser(evalResponseItem.subjectId, getTableName);
  var procedure = await getProcedure(
    evalResponseItem.procedureId,
    getTableName
  );

  //TODO: get the timzone of the submitting user somehow.
  var rating = ratingLevelToRating(evalResponseItem.ratingLevel);
  var dateString = moment()
    .tz("America/Detroit")
    .format("MMMM Do YYYY, h:mm a z");
  var emailBody = `Dr. ${rater.lastName} \n\n On ${dateString}, you rated Dr. ${subject.lastName}'s (${subject.email}) ${procedure.name} procedure performance as ${rating}. \n\nPlease contact your Bedside application program administrator with any questions or contact support@simpl.org`;

  var params = {
    Destination: {
      ToAddresses: [rater.email],
    },
    Message: {
      Body: {
        Text: { Data: emailBody },
      },

      Subject: { Data: "New SIMPL Bedside evaluation." },
    },
    Source: "evaluations@simpl-bedside.org",
  };

  var response = await ses.sendEmail(params).promise();
  console.log("ses response:", response);
}

exports.sendRaterEmail = sendRaterEmail;
