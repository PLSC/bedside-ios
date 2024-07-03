/* Amplify Params - DO NOT EDIT
	API_ADMINQUERIES_APIID
	API_ADMINQUERIES_APINAME
	API_BEDSIDE_CERTIFICATIONRECORDTABLE_ARN
	API_BEDSIDE_CERTIFICATIONRECORDTABLE_NAME
	API_BEDSIDE_EVALUATIONRESPONSETABLE_ARN
	API_BEDSIDE_EVALUATIONRESPONSETABLE_NAME
	API_BEDSIDE_GRAPHQLAPIENDPOINTOUTPUT
	API_BEDSIDE_GRAPHQLAPIIDOUTPUT
	API_BEDSIDE_GRAPHQLAPIKEYOUTPUT
	API_BEDSIDE_MEMBERSHIPTABLE_ARN
	API_BEDSIDE_MEMBERSHIPTABLE_NAME
	API_BEDSIDE_ORGANIZATIONTABLE_ARN
	API_BEDSIDE_ORGANIZATIONTABLE_NAME
	API_BEDSIDE_PROCEDURETABLE_ARN
	API_BEDSIDE_PROCEDURETABLE_NAME
	API_BEDSIDE_PROGRAMPROCEDURETABLE_ARN
	API_BEDSIDE_PROGRAMPROCEDURETABLE_NAME
	API_BEDSIDE_PROGRAMTABLE_ARN
	API_BEDSIDE_PROGRAMTABLE_NAME
	API_BEDSIDE_USERINVITATIONTABLE_ARN
	API_BEDSIDE_USERINVITATIONTABLE_NAME
	API_BEDSIDE_USERTABLE_ARN
	API_BEDSIDE_USERTABLE_NAME
	API_NURSEREPORT_APIID
	API_NURSEREPORT_APINAME
	ENV
	HOSTING_S3ANDCLOUDFRONT_HOSTINGBUCKETNAME
	REGION
	STORAGE_BEDSIDECONTENT_BUCKETNAME
Amplify Params - DO NOT EDIT */

const AWS = require("aws-sdk");
const S3 = new AWS.S3();
const SES = new AWS.SES();
const dataForge = require("data-forge");

const { getQueryResults } = require("./queryResults");
const { formatReportData } = require("./dataFormatting");
const {
  generateSesCalls,
  sendSesCalls,
  generateDestinations,
} = require("./ses");
const { inviteReminderNightly } = require("./inviteReminderNightly.js");

/**
 * Takes output from the ProgramAdminWeekly report call and generates
 * emails to send via SES.
 * @param data output from the bedside-dev-athena-glue-crawler
 */
async function generateProgramAdminWeekly(dataLocation) {
  const reportQueryResults = await getQueryResults(dataLocation);

  //TODO: Handle empty dataset.
  console.log("reportQueryResults:", reportQueryResults);
  const emailData = formatReportData(reportQueryResults);
  console.log("emailData:", JSON.stringify(emailData, null, 2));
  const destinations = generateDestinations(emailData);
  const sesCalls = generateSesCalls(destinations, "ProgramAdminWeekly", 50, {
    recipient_firstname: "Program Admin",
    one_week_ago: "N/A",
    trainees: [],
  });
  //TODO: Send all emails with SES
  console.log("sesCalls:", sesCalls);
  await sendSesCalls(sesCalls);
}

exports.handler = async (event) => {
  console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2));
  console.info("EVENT\n" + JSON.stringify(event, null, 2));

  const message = JSON.parse(event.Records[0].Sns.Message);

  const dataLocation =
    message.QueryExecution.ResultConfiguration.OutputLocation;
  //TODO: Figure out what to do with message.Env
  switch (message.ReportType) {
    case "ProgramAdminWeekly":
      console.log("generating ProgramAdminWeekly report");
      await generateProgramAdminWeekly(dataLocation);
      break;
    case "InviteReminderNightly":
      console.log("sending invite reminders");
      await inviteReminderNightly(dataLocation);
      break;
    default:
      break;
  }

  const response = {
    statusCode: 200,
    //  Uncomment below to enable CORS requests
    //  headers: {
    //      "Access-Control-Allow-Origin": "*",
    //      "Access-Control-Allow-Headers": "*"
    //  },
    body: JSON.stringify("Hello from Lambda!"),
  };
  return response;
};
