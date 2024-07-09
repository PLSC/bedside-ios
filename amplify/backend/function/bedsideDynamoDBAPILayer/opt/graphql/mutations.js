"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.updateUser = exports.updateProgramProcedure = exports.updateProgram = exports.updateProcedure = exports.updateOrganization = exports.updateMembership = exports.updateCertificationRecord = exports.newUserInvitation = exports.deleteUser = exports.deleteProgramProcedure = exports.deleteProgram = exports.deleteProcedure = exports.deleteOrganization = exports.deleteMembership = exports.deleteCertificationRecord = exports.createUser = exports.createProgramProcedure = exports.createProgram = exports.createProcedure = exports.createOrganization = exports.createMembership = exports.createCertificationRecord = void 0;

/* eslint-disable */
// this is an auto generated file. This will be overwritten
const newUserInvitation =
/* GraphQL */
`
  mutation NewUserInvitation($userInvitation: CreateUserInvitationInput) {
    newUserInvitation(userInvitation: $userInvitation)
  }
`;
exports.newUserInvitation = newUserInvitation;
const createOrganization =
/* GraphQL */
`
  mutation CreateOrganization(
    $input: CreateOrganizationInput!
    $condition: ModelOrganizationConditionInput
  ) {
    createOrganization(input: $input, condition: $condition) {
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
exports.createOrganization = createOrganization;
const updateOrganization =
/* GraphQL */
`
  mutation UpdateOrganization(
    $input: UpdateOrganizationInput!
    $condition: ModelOrganizationConditionInput
  ) {
    updateOrganization(input: $input, condition: $condition) {
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
exports.updateOrganization = updateOrganization;
const deleteOrganization =
/* GraphQL */
`
  mutation DeleteOrganization(
    $input: DeleteOrganizationInput!
    $condition: ModelOrganizationConditionInput
  ) {
    deleteOrganization(input: $input, condition: $condition) {
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
exports.deleteOrganization = deleteOrganization;
const createProgram =
/* GraphQL */
`
  mutation CreateProgram(
    $input: CreateProgramInput!
    $condition: ModelProgramConditionInput
  ) {
    createProgram(input: $input, condition: $condition) {
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
exports.createProgram = createProgram;
const updateProgram =
/* GraphQL */
`
  mutation UpdateProgram(
    $input: UpdateProgramInput!
    $condition: ModelProgramConditionInput
  ) {
    updateProgram(input: $input, condition: $condition) {
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
exports.updateProgram = updateProgram;
const deleteProgram =
/* GraphQL */
`
  mutation DeleteProgram(
    $input: DeleteProgramInput!
    $condition: ModelProgramConditionInput
  ) {
    deleteProgram(input: $input, condition: $condition) {
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
exports.deleteProgram = deleteProgram;
const createMembership =
/* GraphQL */
`
  mutation CreateMembership(
    $input: CreateMembershipInput!
    $condition: ModelMembershipConditionInput
  ) {
    createMembership(input: $input, condition: $condition) {
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
exports.createMembership = createMembership;
const updateMembership =
/* GraphQL */
`
  mutation UpdateMembership(
    $input: UpdateMembershipInput!
    $condition: ModelMembershipConditionInput
  ) {
    updateMembership(input: $input, condition: $condition) {
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
exports.updateMembership = updateMembership;
const deleteMembership =
/* GraphQL */
`
  mutation DeleteMembership(
    $input: DeleteMembershipInput!
    $condition: ModelMembershipConditionInput
  ) {
    deleteMembership(input: $input, condition: $condition) {
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
exports.deleteMembership = deleteMembership;
const createProcedure =
/* GraphQL */
`
  mutation CreateProcedure(
    $input: CreateProcedureInput!
    $condition: ModelProcedureConditionInput
  ) {
    createProcedure(input: $input, condition: $condition) {
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
exports.createProcedure = createProcedure;
const updateProcedure =
/* GraphQL */
`
  mutation UpdateProcedure(
    $input: UpdateProcedureInput!
    $condition: ModelProcedureConditionInput
  ) {
    updateProcedure(input: $input, condition: $condition) {
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
exports.updateProcedure = updateProcedure;
const deleteProcedure =
/* GraphQL */
`
  mutation DeleteProcedure(
    $input: DeleteProcedureInput!
    $condition: ModelProcedureConditionInput
  ) {
    deleteProcedure(input: $input, condition: $condition) {
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
exports.deleteProcedure = deleteProcedure;
const createUser =
/* GraphQL */
`
  mutation CreateUser(
    $input: CreateUserInput!
    $condition: ModelUserConditionInput
  ) {
    createUser(input: $input, condition: $condition) {
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
exports.createUser = createUser;
const updateUser =
/* GraphQL */
`
  mutation UpdateUser(
    $input: UpdateUserInput!
    $condition: ModelUserConditionInput
  ) {
    updateUser(input: $input, condition: $condition) {
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
exports.updateUser = updateUser;
const deleteUser =
/* GraphQL */
`
  mutation DeleteUser(
    $input: DeleteUserInput!
    $condition: ModelUserConditionInput
  ) {
    deleteUser(input: $input, condition: $condition) {
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
exports.deleteUser = deleteUser;
const createCertificationRecord =
/* GraphQL */
`
  mutation CreateCertificationRecord(
    $input: CreateCertificationRecordInput!
    $condition: ModelCertificationRecordConditionInput
  ) {
    createCertificationRecord(input: $input, condition: $condition) {
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
exports.createCertificationRecord = createCertificationRecord;
const updateCertificationRecord =
/* GraphQL */
`
  mutation UpdateCertificationRecord(
    $input: UpdateCertificationRecordInput!
    $condition: ModelCertificationRecordConditionInput
  ) {
    updateCertificationRecord(input: $input, condition: $condition) {
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
exports.updateCertificationRecord = updateCertificationRecord;
const deleteCertificationRecord =
/* GraphQL */
`
  mutation DeleteCertificationRecord(
    $input: DeleteCertificationRecordInput!
    $condition: ModelCertificationRecordConditionInput
  ) {
    deleteCertificationRecord(input: $input, condition: $condition) {
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
exports.deleteCertificationRecord = deleteCertificationRecord;
const createProgramProcedure =
/* GraphQL */
`
  mutation CreateProgramProcedure(
    $input: CreateProgramProcedureInput!
    $condition: ModelProgramProcedureConditionInput
  ) {
    createProgramProcedure(input: $input, condition: $condition) {
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
exports.createProgramProcedure = createProgramProcedure;
const updateProgramProcedure =
/* GraphQL */
`
  mutation UpdateProgramProcedure(
    $input: UpdateProgramProcedureInput!
    $condition: ModelProgramProcedureConditionInput
  ) {
    updateProgramProcedure(input: $input, condition: $condition) {
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
exports.updateProgramProcedure = updateProgramProcedure;
const deleteProgramProcedure =
/* GraphQL */
`
  mutation DeleteProgramProcedure(
    $input: DeleteProgramProcedureInput!
    $condition: ModelProgramProcedureConditionInput
  ) {
    deleteProgramProcedure(input: $input, condition: $condition) {
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
exports.deleteProgramProcedure = deleteProgramProcedure;