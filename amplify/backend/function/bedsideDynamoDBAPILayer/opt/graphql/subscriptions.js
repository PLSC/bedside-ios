"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.onUpdateUser = exports.onUpdateProgramProcedure = exports.onUpdateProgram = exports.onUpdateProcedure = exports.onUpdateOrganization = exports.onUpdateMembership = exports.onUpdateCertificationRecord = exports.onDeleteUser = exports.onDeleteProgramProcedure = exports.onDeleteProgram = exports.onDeleteProcedure = exports.onDeleteOrganization = exports.onDeleteMembership = exports.onDeleteCertificationRecord = exports.onCreateUser = exports.onCreateProgramProcedure = exports.onCreateProgram = exports.onCreateProcedure = exports.onCreateOrganization = exports.onCreateMembership = exports.onCreateCertificationRecord = void 0;

/* eslint-disable */
// this is an auto generated file. This will be overwritten
const onCreateOrganization =
/* GraphQL */
`
  subscription OnCreateOrganization {
    onCreateOrganization {
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
exports.onCreateOrganization = onCreateOrganization;
const onUpdateOrganization =
/* GraphQL */
`
  subscription OnUpdateOrganization {
    onUpdateOrganization {
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
exports.onUpdateOrganization = onUpdateOrganization;
const onDeleteOrganization =
/* GraphQL */
`
  subscription OnDeleteOrganization {
    onDeleteOrganization {
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
exports.onDeleteOrganization = onDeleteOrganization;
const onCreateProgram =
/* GraphQL */
`
  subscription OnCreateProgram {
    onCreateProgram {
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
exports.onCreateProgram = onCreateProgram;
const onUpdateProgram =
/* GraphQL */
`
  subscription OnUpdateProgram {
    onUpdateProgram {
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
exports.onUpdateProgram = onUpdateProgram;
const onDeleteProgram =
/* GraphQL */
`
  subscription OnDeleteProgram {
    onDeleteProgram {
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
exports.onDeleteProgram = onDeleteProgram;
const onCreateMembership =
/* GraphQL */
`
  subscription OnCreateMembership {
    onCreateMembership {
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
exports.onCreateMembership = onCreateMembership;
const onUpdateMembership =
/* GraphQL */
`
  subscription OnUpdateMembership {
    onUpdateMembership {
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
exports.onUpdateMembership = onUpdateMembership;
const onDeleteMembership =
/* GraphQL */
`
  subscription OnDeleteMembership {
    onDeleteMembership {
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
exports.onDeleteMembership = onDeleteMembership;
const onCreateProcedure =
/* GraphQL */
`
  subscription OnCreateProcedure {
    onCreateProcedure {
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
exports.onCreateProcedure = onCreateProcedure;
const onUpdateProcedure =
/* GraphQL */
`
  subscription OnUpdateProcedure {
    onUpdateProcedure {
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
exports.onUpdateProcedure = onUpdateProcedure;
const onDeleteProcedure =
/* GraphQL */
`
  subscription OnDeleteProcedure {
    onDeleteProcedure {
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
exports.onDeleteProcedure = onDeleteProcedure;
const onCreateUser =
/* GraphQL */
`
  subscription OnCreateUser {
    onCreateUser {
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
exports.onCreateUser = onCreateUser;
const onUpdateUser =
/* GraphQL */
`
  subscription OnUpdateUser {
    onUpdateUser {
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
exports.onUpdateUser = onUpdateUser;
const onDeleteUser =
/* GraphQL */
`
  subscription OnDeleteUser {
    onDeleteUser {
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
exports.onDeleteUser = onDeleteUser;
const onCreateCertificationRecord =
/* GraphQL */
`
  subscription OnCreateCertificationRecord {
    onCreateCertificationRecord {
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
exports.onCreateCertificationRecord = onCreateCertificationRecord;
const onUpdateCertificationRecord =
/* GraphQL */
`
  subscription OnUpdateCertificationRecord {
    onUpdateCertificationRecord {
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
exports.onUpdateCertificationRecord = onUpdateCertificationRecord;
const onDeleteCertificationRecord =
/* GraphQL */
`
  subscription OnDeleteCertificationRecord {
    onDeleteCertificationRecord {
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
exports.onDeleteCertificationRecord = onDeleteCertificationRecord;
const onCreateProgramProcedure =
/* GraphQL */
`
  subscription OnCreateProgramProcedure {
    onCreateProgramProcedure {
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
exports.onCreateProgramProcedure = onCreateProgramProcedure;
const onUpdateProgramProcedure =
/* GraphQL */
`
  subscription OnUpdateProgramProcedure {
    onUpdateProgramProcedure {
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
exports.onUpdateProgramProcedure = onUpdateProgramProcedure;
const onDeleteProgramProcedure =
/* GraphQL */
`
  subscription OnDeleteProgramProcedure {
    onDeleteProgramProcedure {
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
exports.onDeleteProgramProcedure = onDeleteProgramProcedure;