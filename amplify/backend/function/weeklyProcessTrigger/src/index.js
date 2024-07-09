/* Amplify Params - DO NOT EDIT
	API_BEDSIDE_GRAPHQLAPIENDPOINTOUTPUT
	API_BEDSIDE_GRAPHQLAPIIDOUTPUT
	API_BEDSIDE_GRAPHQLAPIKEYOUTPUT
	ENV
	REGION
Amplify Params - DO NOT EDIT */

var aws = require("aws-sdk");
var fs = require("fs");

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
  console.log(`EVENT: ${JSON.stringify(event)}`);

  try {
    const querystring = fs.readFileSync("admin-email-weekly-query", "utf8");
    const env = process.env.ENV;
    var params = {
      stateMachineArn:
        "arn:aws:states:us-east-1:597534837657:stateMachine:bedside-dev-athena-glue-crawler",
      input: JSON.stringify({
        QueryString: querystring,
        Env: env,
        ReportType: "ProgramAdminWeekly",
      }),
    };
    var stepfunctions = new aws.StepFunctions();

    const results = await stepfunctions.startExecution(params).promise();
    console.log("Results from calling step function:", results);
    return {
      statusCode: 200,
      body: results,
    };
  } catch (e) {
    return {
      statusCode: 500,
      body: e,
    };
  }
};
