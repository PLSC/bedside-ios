/* Amplify Params - DO NOT EDIT
You can access the following resource attributes as environment variables from your Lambda function
var environment = process.env.ENV
var region = process.env.REGION
var apiBedsideGraphQLAPIIdOutput = process.env.API_BEDSIDE_GRAPHQLAPIIDOUTPUT
var apiBedsideGraphQLAPIEndpointOutput = process.env.API_BEDSIDE_GRAPHQLAPIENDPOINTOUTPUT

Amplify Params - DO NOT EDIT */

var AWS = require("aws-sdk");
var documentClient = new AWS.DynamoDB.DocumentClient();
var uuid = require("uuid");
var uuidv4 = uuid.v4;
var email = require("./email");
var tablesUtils = require("./tablesUtils");

let certificationRecordTypename = "CertificationRecord";

async function getExistingCertRecord(tableName, subjectId, procedureId) {
  let params = {
    TableName: tableName,
    IndexName: "bySubjectProcedure",
    KeyConditionExpression:
      "subjectId = :subjectKey and procedureId = :procedureKey",
    ExpressionAttributeValues: {
      ":subjectKey": subjectId,
      ":procedureKey": procedureId,
    },
  };
  var data = await documentClient.query(params).promise();
  console.log("query result =", data);
  return data.Items[0];
}

// Either updates or inserts a cert record.
async function upsertCertRecord(
  certificationRecordTableName,
  subjectId,
  procedureId,
  creationDateString
) {
  let prevCertRecord = await getExistingCertRecord(
    certificationRecordTableName,
    subjectId,
    procedureId
  );
  // If there is no existing cert record, create one.
  let certRecordId = prevCertRecord ? prevCertRecord.id : uuidv4();

  let certRecordParams = {
    TableName: certificationRecordTableName,
    Key: {
      id: certRecordId,
    },
    ExpressionAttributeNames: {
      "#t": "createdAt",
      "#u": "updatedAt",
      "#c": "totalProcedureEvals",
      "#p": "procedureId",
      "#s": "subjectId",
      "#tn": "__typename",
    },
    ExpressionAttributeValues: {
      ":t": creationDateString,
      ":u": creationDateString,
      ":c": 1,
      ":p": procedureId,
      ":s": subjectId,
      ":tn": certificationRecordTypename,
    },
    UpdateExpression:
      "add #c :c set #u = :u, #t = if_not_exists(#t, :t), #p = :p, #s = :s, #tn = :tn",
    ReturnValues: "UPDATED_NEW",
  };

  let certRecord = await documentClient.update(certRecordParams).promise();

  return { ...certRecord.Attributes, id: certRecordId };
}

exports.handler = async (event) => {
  let evalResponseParams = event.arguments.evaluationResponse;
  let procedureId = evalResponseParams.procedureId;
  let subjectId = evalResponseParams.subjectId;
  let creationDateString = new Date().toISOString();
  let getTableName = await tablesUtils.getTableNameFn();

  let certificationRecordTableName = await getTableName(
    certificationRecordTypename
  );

  let certRecord = await upsertCertRecord(
    certificationRecordTableName,
    subjectId,
    procedureId,
    creationDateString
  );

  console.log("Cert Record", certRecord);

  let evaluationResponseTypename = "EvaluationResponse";

  var evalResponseItem = {
    id: uuidv4(),
    __typename: evaluationResponseTypename,
    createdAt: creationDateString,
    evaluationDate: evalResponseParams.evaluationDate,
    updatedAt: creationDateString,
    procedureId: procedureId,
    raterId: evalResponseParams.raterId,
    ratingLevel: evalResponseParams.ratingLevel,
    subjectId: subjectId,
    certificationRecordId: certRecord.id,
  };

  let evalTableName = await getTableName(evaluationResponseTypename);

  var params = {
    TableName: evalTableName,
    Item: evalResponseItem,
  };

  try {
    let data = await documentClient.put(params).promise();
    let emailResponse = await email.sendRaterEmail(
      evalResponseItem,
      getTableName
    );
    return { statusCode: 200, body: JSON.stringify({ params, data }) };
  } catch (err) {
    console.log("error", err);
    return { statusCode: 400, body: JSON.stringify({ params, err }) };
  }
};
