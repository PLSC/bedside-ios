const fs = require("fs");
const {
  inviteReminderNightly,
  parseEmailInviteCsv,
  createInviteUrlWithEmail,
} = require("./inviteReminderNightly.js");

const { generateSesCalls, generateDestinations } = require("./ses");

let invitesCsv = null;
let parsedData = null;

beforeAll(() => {
  invitesCsv = fs.readFileSync(
    __dirname + "/test/data/email-invite-query-results.csv",
    "utf-8"
  );
  parsedData = parseEmailInviteCsv(invitesCsv);
});

test("test data for email-invite exists", () => {
  expect(invitesCsv).not.toBeNull();
});

test("parsing email invite csv", () => {
  expect(parsedData.length).toEqual(8);
  expect(typeof parsedData[0] === "object").toEqual(true);
  expect(parsedData[0].invite_url).not.toBeNull();
});

test("email destinations are generated", () => {
  let destinations = generateDestinations(parsedData);
  expect(destinations.length).toEqual(8);
  expect(destinations[0]).toHaveProperty("Destination");
  expect(destinations[0]).toHaveProperty("ReplacementTemplateData");
});

test("calls to SES are generated", () => {
  let destinations = generateDestinations(parsedData);
  let calls = generateSesCalls(destinations, "TestTemplate", 50, {});
  expect(calls).not.toBeNull();
});

test("invite url link is correct.", () => {
  let inviteUrlDev = createInviteUrlWithEmail("andy@simpl.org", "dev");
  let inviteUrlProd = createInviteUrlWithEmail("andy@simpl.org", "prod");
  let inviteUrlOther = createInviteUrlWithEmail("andy@simpl.org", "other");
  expect(inviteUrlDev).toEqual(
    "https://develop.simpl-bedside.org/invitation/andy@simpl.org"
  );
  expect(inviteUrlProd).toEqual(
    "https://www.simpl-bedside.org/invitation/andy@simpl.org"
  );
  expect(inviteUrlOther).toEqual(
    "https://www.simpl-bedside.org/invitation/andy@simpl.org"
  );
});
