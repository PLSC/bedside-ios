//
//  CertificationRecord.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation

public struct CertificationRecord : Codable, Identifiable {
    public let id : String
    //public let subject : User
    
    public let procedure: Procedure
    public let isCertified: Bool
    public let certificationMethod: String?
    public let totalProcedureEvals: Int
    public var certificationLog: [EvaluationResponse]?
}

extension ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item.Subject: UserRepresentible {
    var memberships: [Membership]? {
        return nil
    }
}
extension ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item.Rater: UserRepresentible {
    var memberships: [Membership]? {
        return nil
    }
}

extension DateFormatter {
    static let AWS_DATE_TIME_STRING_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
}

extension Date {
    var awsDateTimeString : String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.AWS_DATE_TIME_STRING_FORMAT
            return dateFormatter.string(from: self)
        }
    }
}

extension String {
    var awsDateTime : Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.AWS_DATE_TIME_STRING_FORMAT
            return dateFormatter.date(from: self)
        }
    }
}



extension CertificationRecord {
    
    func map(userListItem: UserRepresentible?) -> User? {
        guard let user = userListItem else { return nil }
        return User(id: user.id, userName: user.userName, email: user.email, phone: user.phone, firstName: user.firstName, lastName: user.lastName, npi: user.npi, memberships: nil)
    }
    
    func mapCertLogItem(_ certLogItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item?) -> EvaluationResponse? {
        
        guard let eval = certLogItem,
            let subject = self.map(userListItem: eval.subject),
            let rater = self.map(userListItem: eval.rater),
            let ratingLevel = eval.ratingLevel,
            let evalDate = eval.evauluationDate.awsDateTime
            else { return nil }
                   
        let p = eval.procedure!
        let procedure = Procedure(id: p.id, name: p.name, description: p.description)
                   
        return EvaluationResponse(id: eval.id, subject: subject, rater: rater, procedure: procedure, evaluationDate: evalDate, ratingLevel: ratingLevel)
    }
    
    init(certificationRecordItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item) {
        let p = certificationRecordItem.procedure
        let procedure = Procedure(id: p.id, name: p.name, description: p.description)
        
        self.id = certificationRecordItem.id
        self.procedure = procedure
        self.isCertified = certificationRecordItem.isCertified ?? false
        self.certificationMethod = certificationRecordItem.certificationMethod?.rawValue
        self.totalProcedureEvals = certificationRecordItem.totalProcedureEvals ?? 0
        self.certificationLog = []
        self.certificationLog = certificationRecordItem.certificationLog?.items?.compactMap(mapCertLogItem(_:))
    }
}
