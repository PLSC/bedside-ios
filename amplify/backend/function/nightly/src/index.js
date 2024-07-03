var aws = require("aws-sdk");
var fs = require("fs");

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
  console.log(`EVENT: ${JSON.stringify(event)}`);

  const nightlyJobEnabled =
    process.env.ENV == "dev" || process.env.ENV == "prod";

  if (!nightlyJobEnabled) {
    return {
      statusCode: 200,
      body: results,
    };
  }

  try {
    const querystring = fs.readFileSync("invite-reminder-query", "utf8");
    const env = process.env.ENV;
    var params = {
      stateMachineArn:
        "arn:aws:states:us-east-1:597534837657:stateMachine:bedside-dev-athena-glue-crawler",
      input: JSON.stringify({
        QueryString: querystring,
        Env: env,
        ReportType: "InviteReminderNightly",
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
