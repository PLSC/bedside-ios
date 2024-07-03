//
//  AmplifyModelExtensions.swift
//  bedside-ios
//
//  Created by Chinthaka on 6/25/24.
//  Copyright © 2024 Andrew Lenox. All rights reserved.
//

import Foundation

extension User {

    var sortName : String {
        get {
            switch (self.firstName, self.lastName, self.email) {
            case let (nil, nil, email):
                return email!
            case let (firstName, lastName?, _):
                return "\(lastName) \(firstName ?? "")"
            default:
                return ""
            }
        }
    }

    var displayName : String {
        get {
            switch (self.firstName, self.lastName, self.email) {
            case let (firstName?, lastName?, _):
                return "Dr. \(firstName) \(lastName)"
            case let (nil, lastName?, _):
                return "Dr. \(lastName)"
            case let (nil, nil, email):
                return email ?? ""
            default:
                return ""
            }
        }
    }
}

extension User {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

//extension User : UserRepresentible {
//}
//
//
//protocol UserRepresentible {
//    var id: String { get }
//    var userName: String? { get }
//    var email: String? { get }
//    var phone: String? { get }
//    var firstName: String? { get }
//    var lastName: String? { get }
//    var npi: Int? { get }
//    var orgID: String? {get}
//}
//
//extension UserRepresentible {
//    func mapToUser() -> User {
//        return User(id: self.id, orgID: self.orgID, userName: self.userName, email: self.email ?? "", phone: self.phone, firstName: self.firstName, lastName: self.lastName, npi: self.npi)
//    }
//}
//
//extension ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item.Subject: UserRepresentible {}
//extension ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item.Rater: UserRepresentible {}
//extension UsersByEmailQuery.Data.UsersByEmail.Item: UserRepresentible {}
//extension UpdateUserMutation.Data.UpdateUser: UserRepresentible {}
//extension ListUsersQuery.Data.ListUser.Item : UserRepresentible {}

extension EvaluationResponse {
    var ratingDisplayText : String? {
        get {
            return answerOptions.filter { (answerOption) -> Bool in
                answerOption.assocValue == self.ratingLevel
            }
            .first?.displayText
        }
    }
}

//extension CertificationRecord {
//
//    func map(userListItem: UserRepresentible?) -> User? {
//        guard let user = userListItem else { return nil }
//        return user.mapToUser()
//    }
//
//    func mapCertLogItem(_ certLogItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item?) -> EvaluationResponse? {
//
//        guard let eval = certLogItem,
//            let subject = self.map(userListItem: eval.subject),
//            let rater = self.map(userListItem: eval.rater),
//            let ratingLevel = eval.ratingLevel,
//            let evalDate = eval.evaluationDate.awsDateTime
//            else { return nil }
//
//        if let p = eval.procedure {
//            let procedure = Procedure(id: p.id, name: p.name, description: p.description)
//
//            return EvaluationResponse(id: eval.id, subject: subject, rater: rater, procedure: procedure, evaluationDate: evalDate, ratingLevel: ratingLevel)
//        } else {
//            print("could not map procedure in certLogItem")
//            return nil
//        }
//
//    }
//
//    init?(certificationRecordItem: CertificationRecord) {
//        guard let p = certificationRecordItem.procedure else { return nil }
//
//        let procedureId = p.id
//        let procedure = Procedure(id: procedureId, name: p.name, description: p.description)
//
//        self.id = certificationRecordItem.id
//        self.procedure = procedure
//        self.isCertified = certificationRecordItem.isCertified ?? false
//        self.certificationMethod = certificationRecordItem.certificationMethod?.rawValue
//        self.totalProcedureEvals = certificationRecordItem.totalProcedureEvals ?? 0
//        self.certificationLog = []
//        self.certificationLog = certificationRecordItem.certificationLog?.items.compactMap(mapCertLogItem(_:))
//    }
//}

extension Procedure {
//    public func belongsToProgram(id: String) -> Bool {
//        self.programs.contains(id)
//    }

    public func belongsToAnyPrograms(ids: [String]) -> Bool {
//        !Set(ids).intersection(Set(self.programs)).isEmpty

        guard let programs = self.programs else {
            return false
        }

        for idToCheck in ids {
            if programs.contains(where: { $0.id == idToCheck }) {
                return true
            }
        }

        return false
    }
}
