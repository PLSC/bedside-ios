const AWS = require("aws-sdk");
const SES = new AWS.SES();

function delay(time) {
  return new Promise((resolve) => setTimeout(resolve, time));
}
/**
 * @param all_emails output from the formatReportData function.
 * Individual records must contain a recipient_email field.
 * @return template and destination data for all emails, used
 * for the aws ses calls.
 */
const generateDestinations = (all_emails) => {
  return all_emails.map((emailData) => {
    return {
      Destination: {
        ToAddresses: [emailData.recipient_email],
      },
      ReplacementTemplateData: JSON.stringify(emailData),
    };
  });
};

/**
 * Splits all destinations into ses calls with appropriate
 * numbers of destinations that respects sending limits.
 *
 * https://aws.amazon.com/blogs/messaging-and-targeting/introducing-email-templates-and-bulk-sending/
 *
 * @param destinations output from generateDestinations
 * @param chunkSize the number of destinations to put in each
 * ses call. 50 is currently the limit.
 */
const generateSesCalls = (
  destinations,
  templateName = "",
  chunkSize = 50,
  defaultTemplatedata = {}
) => {
  // Create all email requests
  const sesCalls = destinations.reduce((resultArray, item, index) => {
    const chunkIndex = Math.floor(index / chunkSize);
    if (!resultArray[chunkIndex]) {
      resultArray[chunkIndex] = {
        Source: "admin@simpl-bedside.org",
        Template: templateName,
        ConfigurationSetName: "SIMPL",
        Destinations: [],
        DefaultTemplateData: JSON.stringify(defaultTemplatedata),
      };
    }
    resultArray[chunkIndex].Destinations.push(item);
    return resultArray;
  }, []);

  return sesCalls;
};

/**
 * Makes the calls to SES to send all
 * @param sesCalls output from generateSesCalls
 */
async function sendSesCalls(sesCalls) {
  for (call of sesCalls) {
    try {
      const result = await SES.sendBulkTemplatedEmail(call).promise();
      console.log("ses sending result:", JSON.stringify(result));
      await delay(1100);
    } catch (error) {
      console.log("Error sending:", call);
      console.log("error:", error);
    }
  }
}

exports.generateSesCalls = generateSesCalls;
exports.generateDestinations = generateDestinations;
exports.sendSesCalls = sendSesCalls;
