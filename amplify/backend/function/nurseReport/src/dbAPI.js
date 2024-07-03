const appsyncUrl = process.env.API_BEDSIDE_GRAPHQLAPIENDPOINTOUTPUT;
const apiKey = process.env.API_BEDSIDE_GRAPHQLAPIKEYOUTPUT;
const { request } = require("/opt/appSyncRequest");
const {
  getUserList,
  certRecordsBySubjectReport,
  getOrgDetails,
  membershipsByUser,
  programProceduresByProgram,
} = require("/opt/graphql/customQueries");

async function getOrganizationData(req, res) {
  let orgId = req.params.orgId;
  var xForwardedFor = req.headers["x-forwarded-for"];
  var sourceIPAddress = xForwardedFor.substr(0, xForwardedFor.indexOf(","));
  let orgInfo = await getOrgInfo(orgId);
  if (!orgInfo || orgInfo === "INVALID_ORGANIZATION_ID") {
    //return IP out of range message
    res.json({
      success: "INVALID_ORGANIZATION_ID",
    });
  } else if (
    orgInfo.ipRangeRegex !== "" &&
    sourceIPInRange(sourceIPAddress, orgInfo.ipRangeRegex)
  ) {
    console.log("Before query");
    var result = await request(
      {
        query: getUserList,
        operationName: "ListUsers",
        variables: {
          filter: {
            orgID: { eq: orgId },
          },
          limit: 5000,
        },
      },
      appsyncUrl,
      apiKey
    );

    var users = result.data.listUsers.items.map(function (user) {
      return {
        name: user.lastName + ", " + user.firstName,
        id: user.id,
        pgy: user.pgy ? user.pgy : null,
        memberships: user.memberships ? user.memberships : null,
      };
    });

    let filteredUsers = users.filter(
      (user) =>
        user.memberships.items.filter(
          (membership) =>
            membership.role === "ProgramAdmin" || membership.role === "Admin"
        ).length === 0 && user.pgy !== null
    );

    const sortedUsers = filteredUsers.sort((p1, p2) => {
      return p1.name > p2.name ? 1 : -1;
    });

    res.json({
      success: "ORG_USER_LIST_CREATED",
      orgName: orgInfo.description,
      users: sortedUsers,
    });
  } else {
    //return IP out of range message
    res.json({
      success: "IP_OUT_OF_RANGE",
    });
  }
}

async function getOrgInfo(orgId) {
  try {
    var result = await request(
      {
        query: getOrgDetails,
        operationName: "getOrgDetails",
        variables: {
          orgId: orgId,
        },
      },
      appsyncUrl,
      apiKey
    );
    console.log("Organization Details: ", result);
    return result.data.getOrganization;
  } catch (error) {
    return "INVALID_ORGANIZATION_ID";
  }
}

function sourceIPInRange(sourceIPAddress, ipRangeRegex) {
  console.log("Source IP: ", sourceIPAddress);
  console.log("Organization IP Range Regex: ", ipRangeRegex);
  var re = new RegExp(ipRangeRegex);
  return re.test(sourceIPAddress);
}

async function getUserProcedureCertifications(userId) {
  var result = await request(
    {
      query: certRecordsBySubjectReport,
      operationName: "CertRecordsBySubject",
      variables: {
        subjectId: userId,
        filter: {
          isCertified: { eq: true },
        },
        limit: 5000,
      },
    },
    appsyncUrl,
    apiKey
  );

  var certifiedProcedures = result.data.certRecordsBySubject.items.map(
    function (certRecord) {
      return {
        procedureName: certRecord.procedure ? certRecord.procedure.name : null,
        procedureId: certRecord.procedure ? certRecord.procedure.id : null,
      };
    }
  );
  console.log("query results:", certifiedProcedures);

  const sortedProcedures = certifiedProcedures.sort((p1, p2) => {
    return p1.procedureName > p2.procedureName ? 1 : -1;
  });
  console.log("after filter and sort:", sortedProcedures);
  return sortedProcedures;
}

async function getUserMemberships(userId) {
  //return user memberships in JSON object
  try {
    var result = await request(
      {
        query: membershipsByUser,
        operationName: "ListMemberships",
        variables: {
          filter: {
            userId: { eq: userId },
          },
          limit: 5000,
        },
      },
      appsyncUrl,
      apiKey
    );
    console.log("User Memberships: ", result);
    return result.data.listMemberships.items;
  } catch (error) {
    return "INVALID_USER_ID";
  }
}

async function getProceduresByProgram(programId) {
  //for each program membership, grab procedures
  try {
    var result = await request(
      {
        query: programProceduresByProgram,
        operationName: "ProceduresByProgram",
        variables: {
          programId: programId,
          limit: 5000,
        },
      },
      appsyncUrl,
      apiKey
    );
    return result.data.proceduresByProgram.items;
  } catch (error) {
    return "INVALID_PROGRAM_ID";
  }
}

async function getProcedureData(req, res) {
  let userId = req.params.userId;
  let certifiedProcedures = await getUserProcedureCertifications(userId);
  let memberships = await getUserMemberships(userId);
  let programProcedures = [];
  if (!memberships || memberships === "INVALID_USER_ID") {
    res.json({
      success: "INVALID_USER_ID",
    });
  } else {
    // for each membership (user role) call getProceduresByProgram (new function above) to get programProcedures list
    // concatenate the JSON results into one JSON object
    console.log("Memberships for ", userId, ": ", memberships);
    // Filter memberships to only include the user role
    let userMemberships = memberships.filter(
      (membership) => membership.role === "User"
    );
    if (userMemberships.length > 0) {
      // iterate through user memberships and gather programProcedures
      for (var i = 0; i < userMemberships.length; i++) {
        console.log("Membership: ", userMemberships[i]);
        try {
          let result = await getProceduresByProgram(
            userMemberships[i].programId
          );
          programProcedures.push(...result);
          console.log("Procedure lookup: ", result);
        } catch (error) {
          console.log(error);
        }
      }
    }
  }

  res.json({
    success: "Certified Procedures List Created!",
    certifiedProcedures: certifiedProcedures,
    programProcedures: programProcedures,
  });
}

exports.getOrganizationData = getOrganizationData;
exports.getProcedureData = getProcedureData;
