"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.programProceduresByProgram = exports.programById = exports.membershipsByUser = exports.listProcedures = exports.listOrgsProgramsMembershipsUsers = exports.listInvitations = exports.listEvaluationResponsesForTable = exports.listEvaluationResponsesForDetailsPage = exports.listCertificationRecordsForTable = exports.listCertificationRecordsForDetailsPage = exports.invitationByEmail = exports.getUserList = exports.getUserForDetailsPage = exports.getOrgUserList = exports.getOrgDetails = exports.evalsBySubject = exports.checkIfUserExists = exports.checkIfNpiExists = exports.checkIfMembershipExists = exports.checkIfEmailExists = exports.certRecordsBySubjectReport = exports.certRecordsBySubject = void 0;
const checkIfUserExists =
/* GraphQL */
`
  query CheckIfUserExists($userName: String, $limit: Int, $nextToken: String) {
    listUsers(
      filter: { userName: { eq: $userName } }
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        userName
      }
      nextToken
    }
  }
`;
exports.checkIfUserExists = checkIfUserExists;
const checkIfNpiExists =
/* GraphQL */
`
  query CheckIfNpiExists($npi: Int, $limit: Int, $nextToken: String) {
    listUsers(
      filter: { npi: { eq: $npi } }
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        userName
      }
      nextToken
    }
  }
`;
exports.checkIfNpiExists = checkIfNpiExists;
const checkIfEmailExists =
/* GraphQL */
`
  query CheckIfEmailExists($email: String, $limit: Int, $nextToken: String) {
    listUsers(
      filter: { email: { eq: $email } }
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        userName
      }
      nextToken
    }
  }
`;
exports.checkIfEmailExists = checkIfEmailExists;
const checkIfMembershipExists =
/* GraphQL */
`
  query CheckIfMembershipExists($programId: ID!, $userId: ID!) {
    listMemberships(
      filter: { programId: { eq: $programId }, userId: { eq: $userId } }
    ) {
      items {
        id
      }
    }
  }
`;
exports.checkIfMembershipExists = checkIfMembershipExists;
const getOrgDetails =
/* GraphQL */
`
  query getOrgDetails($orgId: ID!) {
    getOrganization(id: $orgId) {
      description
      id
      title
      ipRangeRegex
    }
  }
`;
exports.getOrgDetails = getOrgDetails;
const getOrgUserList =
/* GraphQL */
`
  query ListUsers(
    $filter: ModelUserFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listUsers(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        orgID
        userName
        email
        phone
        firstName
        lastName
        npi
        pgy
        isRater
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.getOrgUserList = getOrgUserList;
const getUserList =
/* GraphQL */
`
  query ListUsers(
    $filter: ModelUserFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listUsers(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        orgID
        userName
        email
        phone
        firstName
        lastName
        npi
        pgy
        isRater
        lastLogin
        memberships {
          items {
            id
            role
            programId
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            createdAt
            updatedAt
          }
          nextToken
        }
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.getUserList = getUserList;
const getUserForDetailsPage =
/* GraphQL */
`
  query GetUserForDetailsPage($userId: ID!) {
    getUser(id: $userId) {
      id
      email
      firstName
      lastLogin
      lastName
      pgy
      userName
    }
  }
`;
exports.getUserForDetailsPage = getUserForDetailsPage;
const listCertificationRecordsForDetailsPage =
/* GraphQL */
`
  query ListCertificationRecordsForDetailsPage($userId: ID!) {
    listCertificationRecords(filter: { subjectId: { eq: $userId }}) {
      items {
        certificationLog {
          items {
            ratingLevel
          }
        }
        certificationMethod
        id
        isCertified
        procedure {
          name
        }
        totalProcedureEvals
      }
    }
  }
`;
exports.listCertificationRecordsForDetailsPage = listCertificationRecordsForDetailsPage;
const listEvaluationResponsesForDetailsPage =
/* GraphQL */
`
  query ListEvaluationResponsesForDetailsPage($userId: ID!){
    listEvaluationResponses(filter: { subjectId: { eq: $userId}}) {
      items {
        evaluationDate
        certificationRecordId
        procedure {
          name
        }
        rater {
          firstName
          lastName
        }
        ratingLevel
      }
    }
  }
`;
exports.listEvaluationResponsesForDetailsPage = listEvaluationResponsesForDetailsPage;
const listOrgsProgramsMembershipsUsers =
/* GraphQL */
`
  query ListOrgsProgramsMembershipsUsers($orgId: ID!) {
    getOrganization(id: $orgId) {
      description
      id
      title
      programs {
        items {
          description
          id
          name
        }
      }
    }
  }
`;
exports.listOrgsProgramsMembershipsUsers = listOrgsProgramsMembershipsUsers;
const invitationByEmail =
/* GraphQL */
`
  query ListInvitations(
    $email: String!
    $invitationStatus: InvitationStatus!
    $limit: Int
    $nextToken: String
  ) {
    listUserInvitations(
      filter: {
        email: { eq: $email }
        invitationStatus: { ne: $invitationStatus }
      }
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        orgID
        inviteeId
        email
        invitationStatus
        permission
      }
      nextToken
    }
  }
`;
exports.invitationByEmail = invitationByEmail;
const listInvitations =
/* GraphQL */
`
  query ListInvitations {
    listUserInvitations {
      items {
        id
        orgID
        inviteeId
        email
        permission
      }
    }
  }
`;
exports.listInvitations = listInvitations;
const listCertificationRecordsForTable =
/* GraphQL */
`
  query ListCertificationRecords(
    $filter: ModelCertificationRecordFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listCertificationRecords(
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        procedureId
        procedure {
          name
        }
        isCertified
        certificationMethod
        subjectId
        certificationLog {
          items {
            id
            subjectId
            raterId
            procedureId
            evaluationDate
            ratingLevel
            certificationRecordId
            createdAt
            updatedAt
          }
          nextToken
        }
        totalProcedureEvals
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.listCertificationRecordsForTable = listCertificationRecordsForTable;
const listEvaluationResponsesForTable =
/* GraphQL */
`
  query ListEvaluationResponses(
    $filter: ModelEvaluationResponseFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listEvaluationResponses(
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        subjectId
        rater {
          firstName
          lastName
        }
        raterId
        procedure {
          id
          name
          description
          createdAt
          updatedAt
        }
        procedureId
        evaluationDate
        ratingLevel
        certificationRecordId
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.listEvaluationResponsesForTable = listEvaluationResponsesForTable;
const evalsBySubject =
/* GraphQL */
`
  query EvalsBySubject(
    $subjectId: ID
    $sortDirection: ModelSortDirection
    $filter: ModelEvaluationResponseFilterInput
    $limit: Int
    $nextToken: String
  ) {
    evalsBySubject(
      subjectId: $subjectId
      sortDirection: $sortDirection
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        subjectId
        rater {
          firstName
          lastName
        }
        raterId
        procedure {
          id
          name
          description
          createdAt
          updatedAt
        }
        procedureId
        evaluationDate
        ratingLevel
        certificationRecordId
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.evalsBySubject = evalsBySubject;
const certRecordsBySubject =
/* GraphQL */
`
  query CertRecordsBySubject(
    $subjectId: ID
    $sortDirection: ModelSortDirection
    $filter: ModelCertificationRecordFilterInput
    $limit: Int
    $nextToken: String
  ) {
    certRecordsBySubject(
      subjectId: $subjectId
      sortDirection: $sortDirection
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        procedureId
        procedure {
          id
          name
        }
        isCertified
        certificationMethod
        subjectId
        certificationLog {
          items {
            id
            subjectId
            raterId
            procedureId
            evaluationDate
            ratingLevel
            certificationRecordId
            createdAt
            updatedAt
          }
          nextToken
        }
        totalProcedureEvals
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.certRecordsBySubject = certRecordsBySubject;
const certRecordsBySubjectReport =
/* GraphQL */
`
  query CertRecordsBySubject(
    $subjectId: ID
    $sortDirection: ModelSortDirection
    $filter: ModelCertificationRecordFilterInput
    $limit: Int
    $nextToken: String
  ) {
    certRecordsBySubject(
      subjectId: $subjectId
      sortDirection: $sortDirection
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        procedureId
        procedure {
          id
          name
        }
        isCertified
        certificationMethod
        subjectId
        totalProcedureEvals
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.certRecordsBySubjectReport = certRecordsBySubjectReport;
const programProceduresByProgram =
/* GraphQL */
`
  query ProceduresByProgram(
    $programId: ID
    $sortDirection: ModelSortDirection
    $filter: ModelProgramProcedureFilterInput
    $limit: Int
    $nextToken: String
  ) {
    proceduresByProgram(
      programId: $programId
      sortDirection: $sortDirection
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        procedureId
        procedure {
          id
          name
          description
          createdAt
          updatedAt
        }
        programId
        program {
          id
          name
          orgID
          description
          createdAt
          updatedAt
        }
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.programProceduresByProgram = programProceduresByProgram;
const programById =
/* GraphQL */
`
  query GetProgram($id: ID!) {
    getProgram(id: $id) {
      id
      name
      orgID
      description
      createdAt
      updatedAt
    }
  }
`;
exports.programById = programById;
const listProcedures =
/* GraphQL */
`
  query ListProcedures(
    $filter: ModelProcedureFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listProcedures(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        name
        description
        programs {
          items {
            id
            procedureId
            programId
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            createdAt
            updatedAt
          }
          nextToken
        }
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.listProcedures = listProcedures;
const membershipsByUser =
/* GraphQL */
`
  query ListMemberships(
    $filter: ModelMembershipFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listMemberships(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        role
        userId
        programId
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
exports.membershipsByUser = membershipsByUser;