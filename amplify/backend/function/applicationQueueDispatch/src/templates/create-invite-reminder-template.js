const handlebars = require("handlebars");
const dataForge = require("data-forge");
const fs = require("fs");
require("data-forge-fs");
const { parseEmailInviteCsv } = require("../inviteReminderNightly");

const email_template = fs.readFileSync(
  __dirname + "/invite-reminder.html",
  "utf8"
);

/**
 * Creates a local test-render of the email that you can inspect
 * as you are doing development. This is for visual inspection
 * of the rendered email template. Modify the invite-rendered.html
 * file and run this to output a fully rendered html file.
 */
function testEmailRendering() {
  const queryResults = fs.readFileSync(
    __dirname + "/../test/data/email-invite-query-results.csv",
    "utf-8"
  );
  const parsed = parseEmailInviteCsv(queryResults);
  try {
    const email_compiled = handlebars.compile(email_template);
    const email_rendered = email_compiled(parsed[0]);
    fs.writeFileSync(__dirname + "/test/invite-rendered.html", email_rendered);
  } catch (error) {
    console.log(error);
  }
}

/**
 * After your template looks how you want it, use this function
 * to output the .json file used to update the email template in ses.
 *
 * You can then run the following aws-cli command to update your changes to the template.
 *
 * $ aws ses update-template --cli-input-json file://./program-admin-report.json --profile bedside
 */
function writeInviteEmailTemplate() {
  const sesTemplate = {
    Template: {
      TemplateName: "InviteReminderNightly",
      SubjectPart:
        "Reminder: Invitation to register SIMPL-Bedside account for {{institutionname}}",
      TextPart:
        "New SIMPL Bedside evaluations of your trainees have occurred recently.",
      HtmlPart: `${email_template}`,
    },
  };
  try {
    fs.writeFileSync(
      __dirname + "/email-reminder.json",
      JSON.stringify(sesTemplate)
    );
  } catch (error) {
    console.log(error);
  }
}

// testEmailRendering();
// writeInviteEmailTemplate();
