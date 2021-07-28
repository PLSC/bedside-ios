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

function emailTemplate(emailData) {
  let rater = emailData.rater;
  let subject = emailData.subject;
  let dateString = emailData.dateString;
  let procedure = emailData.procedure;
  let rating = emailData.rating;
  return /* HTML */ `<html>
    <head>
      <meta charset "UTF-8">
    </head>
    <body>
      <p>Dr. ${rater.lastName}</p>
      <p>
        On ${dateString}, you rated Dr. ${subject.lastName}'s (${subject.email})
        ${procedure.name} procedure performance as ${rating}.
      </p>
      <p>
        Please contact your Bedside application program administrator with any
        questions or contact
        <a href="mailto:support@simpl.org">support@simpl.org</a>
      </p>
      <br />
      <br />
      <p style="font-size:10px">
        This information is confidential and privileged pursuant to the Patient
        Safety and Quality Improvement Act of 2005 (Public Law 109—41), T.C.A.
        63-1-150 and 68-11-272 et seq., and has as one of its purposes to
        improve quality and safety of patient care. Do not forward or otherwise
        share this information. This information may not be disclosed unless
        specifically authorized by Vanderbilt University Medical Center’s Office
        of Legal Affairs and/or the Office of Risk and Insurance Management.
      </p>
    </body>
  </html>`;
}

function renderEmailBody(subject, rater, procedure, rating) {
  let emailData = {
    dateString: moment().tz("America/Detroit").format("MMMM DD YYYY"),
    rater,
    subject,
    procedure,
    rating,
  };
  return emailTemplate(emailData);
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
  var emailBodyHTML = renderEmailBody(subject, rater, procedure, rating);
  var dateString = moment().tz("America/Detroit").format("MMMM DD YYYY");
  var emailBodyText = `Dr. ${rater.lastName} \n\n On ${dateString}, you rated Dr. ${subject.lastName}'s (${subject.email}) ${procedure.name} procedure performance as ${rating}. \n\nPlease contact your Bedside application program administrator with any questions or contact support@simpl.org \n\n\nThis information is confidential and privileged pursuant to the Patient Safety and Quality Improvement Act of 2005 (Public Law 109—41), T.C.A. 63-1-150 and 68-11-272 et seq., and has as one of its purposes to improve quality and safety of patient care.  Do not forward or otherwise share this information.  This information may not be disclosed unless specifically authorized by Vanderbilt University Medical Center’s Office of Legal Affairs and/or the Office of Risk and Insurance Management.`;

  var params = {
    Destination: {
      ToAddresses: [rater.email],
    },
    Message: {
      Body: {
        Text: {
          Data: emailBodyText,
        },
        Html: {
          Data: emailBodyHTML,
        },
      },

      Subject: { Data: "New SIMPL Bedside evaluation." },
    },
    Source: "evaluations@simpl-bedside.org",
  };

  var response = await ses.sendEmail(params).promise();
  console.log("ses response:", response);
}

exports.sendRaterEmail = sendRaterEmail;
