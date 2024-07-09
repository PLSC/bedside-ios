"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.usersByNPI = exports.usersByEmail = exports.programsByOrganization = exports.proceduresByProgram = exports.newEvaluationResponse = exports.listUsers = exports.listUserInvitations = exports.listPrograms = exports.listProgramProcedures = exports.listProcedures = exports.listOrganizations = exports.listMemberships = exports.listEvaluationResponses = exports.listCertificationRecords = exports.invitationsByEmail = exports.getUserInvitation = exports.getUser = exports.getProgramProcedure = exports.getProgram = exports.getProcedure = exports.getOrganization = exports.getMembership = exports.getEvaluationResponse = exports.getCertificationRecord = exports.evalsBySubject = exports.certRecordsBySubject = void 0;

/* eslint-disable */
// this is an auto generated file. This will be overwritten
const newEvaluationResponse =
/* GraphQL */
`
  query NewEvaluationResponse(
    $evaluationResponse: CreateEvaluationResponseInput
  ) {
    newEvaluationResponse(evaluationResponse: $evaluationResponse)
  }
`;
exports.newEvaluationResponse = newEvaluationResponse;
const getEvaluationResponse =
/* GraphQL */
`
  query GetEvaluationResponse($id: ID!) {
    getEvaluationResponse(id: $id) {
      id
      subjectId
      raterId
      procedureId
      evaluationDate
      ratingLevel
      certificationRecordId
      createdAt
      updatedAt
      procedure {
        id
        name
        description
        createdAt
        updatedAt
        programs {
          items {
            id
            procedureId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            procedure {
              id
              name
              description
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      subject {
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
        settings {
          receiveWeeklyNewEvaluationsEmail
        }
        lastLogin
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      rater {
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
        settings {
          receiveWeeklyNewEvaluationsEmail
        }
        lastLogin
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
    }
  }
`;
exports.getEvaluationResponse = getEvaluationResponse;
const listEvaluationResponses =
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
        raterId
        procedureId
        evaluationDate
        ratingLevel
        certificationRecordId
        createdAt
        updatedAt
        procedure {
          id
          name
          description
          createdAt
          updatedAt
          programs {
            items {
              id
              procedureId
              programId
              createdAt
              updatedAt
            }
            nextToken
          }
        }
        subject {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
        rater {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
      }
      nextToken
    }
  }
`;
exports.listEvaluationResponses = listEvaluationResponses;
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
        raterId
        procedureId
        evaluationDate
        ratingLevel
        certificationRecordId
        createdAt
        updatedAt
        procedure {
          id
          name
          description
          createdAt
          updatedAt
          programs {
            items {
              id
              procedureId
              programId
              createdAt
              updatedAt
            }
            nextToken
          }
        }
        subject {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
        rater {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
      }
      nextToken
    }
  }
`;
exports.evalsBySubject = evalsBySubject;
const getOrganization =
/* GraphQL */
`
  query GetOrganization($id: ID!) {
    getOrganization(id: $id) {
      id
      title
      description
      ipRangeRegex
      createdAt
      updatedAt
      programs {
        items {
          id
          name
          orgID
          description
          createdAt
          updatedAt
          memberships {
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
        nextToken
      }
    }
  }
`;
exports.getOrganization = getOrganization;
const listOrganizations =
/* GraphQL */
`
  query ListOrganizations(
    $filter: ModelOrganizationFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listOrganizations(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        title
        description
        ipRangeRegex
        createdAt
        updatedAt
        programs {
          items {
            id
            name
            orgID
            description
            createdAt
            updatedAt
            memberships {
              nextToken
            }
          }
          nextToken
        }
      }
      nextToken
    }
  }
`;
exports.listOrganizations = listOrganizations;
const getProgram =
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
      memberships {
        items {
          id
          role
          userId
          programId
          createdAt
          updatedAt
          program {
            id
            name
            orgID
            description
            createdAt
            updatedAt
            memberships {
              nextToken
            }
          }
          user {
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
            settings {
              receiveWeeklyNewEvaluationsEmail
            }
            lastLogin
            createdAt
            updatedAt
            memberships {
              nextToken
            }
          }
        }
        nextToken
      }
    }
  }
`;
exports.getProgram = getProgram;
const listPrograms =
/* GraphQL */
`
  query ListPrograms(
    $filter: ModelProgramFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listPrograms(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        name
        orgID
        description
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      nextToken
    }
  }
`;
exports.listPrograms = listPrograms;
const programsByOrganization =
/* GraphQL */
`
  query ProgramsByOrganization(
    $orgID: ID
    $name: ModelStringKeyConditionInput
    $sortDirection: ModelSortDirection
    $filter: ModelProgramFilterInput
    $limit: Int
    $nextToken: String
  ) {
    programsByOrganization(
      orgID: $orgID
      name: $name
      sortDirection: $sortDirection
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        name
        orgID
        description
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      nextToken
    }
  }
`;
exports.programsByOrganization = programsByOrganization;
const getMembership =
/* GraphQL */
`
  query GetMembership($id: ID!) {
    getMembership(id: $id) {
      id
      role
      userId
      programId
      createdAt
      updatedAt
      program {
        id
        name
        orgID
        description
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      user {
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
        settings {
          receiveWeeklyNewEvaluationsEmail
        }
        lastLogin
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
    }
  }
`;
exports.getMembership = getMembership;
const listMemberships =
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
        program {
          id
          name
          orgID
          description
          createdAt
          updatedAt
          memberships {
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
        user {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
      }
      nextToken
    }
  }
`;
exports.listMemberships = listMemberships;
const getProcedure =
/* GraphQL */
`
  query GetProcedure($id: ID!) {
    getProcedure(id: $id) {
      id
      name
      description
      createdAt
      updatedAt
      programs {
        items {
          id
          procedureId
          programId
          createdAt
          updatedAt
          program {
            id
            name
            orgID
            description
            createdAt
            updatedAt
            memberships {
              nextToken
            }
          }
          procedure {
            id
            name
            description
            createdAt
            updatedAt
            programs {
              nextToken
            }
          }
        }
        nextToken
      }
    }
  }
`;
exports.getProcedure = getProcedure;
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
        createdAt
        updatedAt
        programs {
          items {
            id
            procedureId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            procedure {
              id
              name
              description
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      nextToken
    }
  }
`;
exports.listProcedures = listProcedures;
const getUser =
/* GraphQL */
`
  query GetUser($id: ID!) {
    getUser(id: $id) {
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
      settings {
        receiveWeeklyNewEvaluationsEmail
      }
      lastLogin
      createdAt
      updatedAt
      memberships {
        items {
          id
          role
          userId
          programId
          createdAt
          updatedAt
          program {
            id
            name
            orgID
            description
            createdAt
            updatedAt
            memberships {
              nextToken
            }
          }
          user {
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
            settings {
              receiveWeeklyNewEvaluationsEmail
            }
            lastLogin
            createdAt
            updatedAt
            memberships {
              nextToken
            }
          }
        }
        nextToken
      }
    }
  }
`;
exports.getUser = getUser;
const listUsers =
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
        settings {
          receiveWeeklyNewEvaluationsEmail
        }
        lastLogin
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      nextToken
    }
  }
`;
exports.listUsers = listUsers;
const usersByEmail =
/* GraphQL */
`
  query UsersByEmail(
    $email: String
    $sortDirection: ModelSortDirection
    $filter: ModelUserFilterInput
    $limit: Int
    $nextToken: String
  ) {
    usersByEmail(
      email: $email
      sortDirection: $sortDirection
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
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
        settings {
          receiveWeeklyNewEvaluationsEmail
        }
        lastLogin
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      nextToken
    }
  }
`;
exports.usersByEmail = usersByEmail;
const usersByNPI =
/* GraphQL */
`
  query UsersByNPI(
    $npi: Int
    $sortDirection: ModelSortDirection
    $filter: ModelUserFilterInput
    $limit: Int
    $nextToken: String
  ) {
    usersByNPI(
      npi: $npi
      sortDirection: $sortDirection
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
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
        settings {
          receiveWeeklyNewEvaluationsEmail
        }
        lastLogin
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      nextToken
    }
  }
`;
exports.usersByNPI = usersByNPI;
const getCertificationRecord =
/* GraphQL */
`
  query GetCertificationRecord($id: ID!) {
    getCertificationRecord(id: $id) {
      id
      procedureId
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
          procedure {
            id
            name
            description
            createdAt
            updatedAt
            programs {
              nextToken
            }
          }
          subject {
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
            settings {
              receiveWeeklyNewEvaluationsEmail
            }
            lastLogin
            createdAt
            updatedAt
            memberships {
              nextToken
            }
          }
          rater {
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
            settings {
              receiveWeeklyNewEvaluationsEmail
            }
            lastLogin
            createdAt
            updatedAt
            memberships {
              nextToken
            }
          }
        }
        nextToken
      }
      totalProcedureEvals
      createdAt
      updatedAt
      procedure {
        id
        name
        description
        createdAt
        updatedAt
        programs {
          items {
            id
            procedureId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            procedure {
              id
              name
              description
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      subject {
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
        settings {
          receiveWeeklyNewEvaluationsEmail
        }
        lastLogin
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
    }
  }
`;
exports.getCertificationRecord = getCertificationRecord;
const listCertificationRecords =
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
            procedure {
              id
              name
              description
              createdAt
              updatedAt
            }
            subject {
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
              createdAt
              updatedAt
            }
            rater {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
        totalProcedureEvals
        createdAt
        updatedAt
        procedure {
          id
          name
          description
          createdAt
          updatedAt
          programs {
            items {
              id
              procedureId
              programId
              createdAt
              updatedAt
            }
            nextToken
          }
        }
        subject {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
      }
      nextToken
    }
  }
`;
exports.listCertificationRecords = listCertificationRecords;
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
            procedure {
              id
              name
              description
              createdAt
              updatedAt
            }
            subject {
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
              createdAt
              updatedAt
            }
            rater {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
        totalProcedureEvals
        createdAt
        updatedAt
        procedure {
          id
          name
          description
          createdAt
          updatedAt
          programs {
            items {
              id
              procedureId
              programId
              createdAt
              updatedAt
            }
            nextToken
          }
        }
        subject {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
      }
      nextToken
    }
  }
`;
exports.certRecordsBySubject = certRecordsBySubject;
const getUserInvitation =
/* GraphQL */
`
  query GetUserInvitation($id: ID!) {
    getUserInvitation(id: $id) {
      id
      orgID
      inviteeId
      invitationStatus
      email
      programAdminId
      permission
      createdAt
      updatedAt
      invitee {
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
        settings {
          receiveWeeklyNewEvaluationsEmail
        }
        lastLogin
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
    }
  }
`;
exports.getUserInvitation = getUserInvitation;
const listUserInvitations =
/* GraphQL */
`
  query ListUserInvitations(
    $filter: ModelUserInvitationFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listUserInvitations(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        orgID
        inviteeId
        invitationStatus
        email
        programAdminId
        permission
        createdAt
        updatedAt
        invitee {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
      }
      nextToken
    }
  }
`;
exports.listUserInvitations = listUserInvitations;
const invitationsByEmail =
/* GraphQL */
`
  query InvitationsByEmail(
    $email: String
    $sortDirection: ModelSortDirection
    $filter: ModelUserInvitationFilterInput
    $limit: Int
    $nextToken: String
  ) {
    invitationsByEmail(
      email: $email
      sortDirection: $sortDirection
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        orgID
        inviteeId
        invitationStatus
        email
        programAdminId
        permission
        createdAt
        updatedAt
        invitee {
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
          settings {
            receiveWeeklyNewEvaluationsEmail
          }
          lastLogin
          createdAt
          updatedAt
          memberships {
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
      }
      nextToken
    }
  }
`;
exports.invitationsByEmail = invitationsByEmail;
const getProgramProcedure =
/* GraphQL */
`
  query GetProgramProcedure($id: ID!) {
    getProgramProcedure(id: $id) {
      id
      procedureId
      programId
      createdAt
      updatedAt
      program {
        id
        name
        orgID
        description
        createdAt
        updatedAt
        memberships {
          items {
            id
            role
            userId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            user {
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
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
      procedure {
        id
        name
        description
        createdAt
        updatedAt
        programs {
          items {
            id
            procedureId
            programId
            createdAt
            updatedAt
            program {
              id
              name
              orgID
              description
              createdAt
              updatedAt
            }
            procedure {
              id
              name
              description
              createdAt
              updatedAt
            }
          }
          nextToken
        }
      }
    }
  }
`;
exports.getProgramProcedure = getProgramProcedure;
const listProgramProcedures =
/* GraphQL */
`
  query ListProgramProcedures(
    $filter: ModelProgramProcedureFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listProgramProcedures(
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        procedureId
        programId
        createdAt
        updatedAt
        program {
          id
          name
          orgID
          description
          createdAt
          updatedAt
          memberships {
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
        procedure {
          id
          name
          description
          createdAt
          updatedAt
          programs {
            items {
              id
              procedureId
              programId
              createdAt
              updatedAt
            }
            nextToken
          }
        }
      }
      nextToken
    }
  }
`;
exports.listProgramProcedures = listProgramProcedures;
const proceduresByProgram =
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
        programId
        createdAt
        updatedAt
        program {
          id
          name
          orgID
          description
          createdAt
          updatedAt
          memberships {
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
        procedure {
          id
          name
          description
          createdAt
          updatedAt
          programs {
            items {
              id
              procedureId
              programId
              createdAt
              updatedAt
            }
            nextToken
          }
        }
      }
      nextToken
    }
  }
`;
exports.proceduresByProgram = proceduresByProgram;