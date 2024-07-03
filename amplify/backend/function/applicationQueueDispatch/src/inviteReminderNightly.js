const { getQueryResults } = require("./queryResults");

const {
  generateSesCalls,
  sendSesCalls,
  generateDestinations,
} = require("./ses");
const dataForge = require("data-forge");
require("data-forge-fs");

/**
 * Creates a url for the email invite.
 * TODO: Only works for dev and prod environments
 * @param email email of the invitee
 * @return the url
 */
function createInviteUrlWithEmail(email, env = process.env.ENV) {
  const baseUrl =
    env === "dev"
      ? "https://develop.simpl-bedside.org"
      : "https://www.simpl-bedside.org";
  return baseUrl + "/invitation/" + email;
}

/**
 * Take csv output from the InviteReminderNightly report and
 * parses it into JSON objects. Also renames the recipientemail field.
 * @param emailInviteCsv output from bedside-dev-athena-glue-crawler InviteReminderNightly
 * @return an array of objects representing emails to send.
 */
function parseEmailInviteCsv(emailInviteCsv) {
  let dataframe = dataForge
    .fromCSV(emailInviteCsv)
    .renameSeries({ recipientemail: "recipient_email" })
    .select((row) => {
      const clone = Object.assign({}, row);
      clone["invite_url"] = createInviteUrlWithEmail(clone["recipient_email"]);
      return clone;
    });
  return JSON.parse(dataframe.toJSON());
}

/**
 * @param emailData output from parseEmailInviteCsv
 * @return ses calls that can be sent directly to SES in clusters of 50.
 */
function generateEmailTemplateData(emailData) {
  let destinations = generateDestinations(emailData);
  return generateSesCalls(destinations, "InviteReminderNightly", 50, {
    inviteefirstname: "first name",
    inviteelastname: "last name",
    institutionname: "your institution",
    programadminfirstname: "Program",
    programadminlastname: "Admin",
    invite_url: "https://www.simpl-bedside.org/",
  });
}

/**
 * Generate the InviteReminderNightly report and send.
 * @param data the message from SNS sent to this lambda with the
 * query results.
 */
async function inviteReminderNightly(dataLocation) {
  const reportQueryResults = await getQueryResults(dataLocation);
  console.log("query results retrieved:", reportQueryResults);
  let emailData = parseEmailInviteCsv(reportQueryResults);
  console.log("generating ses calls from emailData:", emailData);
  let emailTemplateData = generateEmailTemplateData(emailData);
  console.log("sending emailTemplateData:", JSON.stringify(emailTemplateData));
  await sendSesCalls(emailTemplateData);
}

exports.inviteReminderNightly = inviteReminderNightly;
exports.parseEmailInviteCsv = parseEmailInviteCsv;
exports.createInviteUrlWithEmail = createInviteUrlWithEmail;
